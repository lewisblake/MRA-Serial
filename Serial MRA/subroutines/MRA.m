function [ sumLogLikelihood, predictions ] = MRA( theta, data, knots, MAX_LEVEL_M, NUM_PARTITIONS_J, ...
    nRegions, isPredicting, verbose, varargin )
%% MRA.m is the primary Multi-resolution approximation function
%
%  First, this function pre-allocates the memory needed for objects used in
%  subsequent calculations. Then, the prior distribution is created by
%  looping from coarsest resolution to finest resolution. After
%  the prior has been created, the algorithm works from second-finest
%  resolution to coarsest resolution computing the posterior inference. 
%  The algorithm loops between iLevel's in serial an performs calculations in serial.
%  Finally, if in prediction mode, spatial prediction takes with
%  with the use of the spatial_prediction() function.
%
%  Input: theta (vector), data (cell), knots (cell), NUM_LEVELS_M (double),
%  NUM_PARTITIONS_J (double), nRegions (vector), isPredicting (boolean),
%  verbose(boolean), varargin (varargin can be varEps(double) and predictionLocationsj (matrix))
%
%  Output: sumLogLikelihood (double), predictions (matrix)
%%
% Check number of optional input arguments
numVarArgsIn = length(varargin);
if numVarArgsIn > 2
    error('myfuns:createPrior:TooManyInputs', ...
        'requires at most 2 optional inputs');
end

% Set defaults for optional inputs
optArgs = {0 NaN};
% overwrite the ones specified in varargin.
optArgs(1:numVarArgsIn) = varargin;
 [varEps, predictionLocationsj] = optArgs{:};

% Calculate key quantities
totalRegions = sum(nRegions);
cumulativeRegions = cumsum(nRegions);

% Pre-allocate quantities
RpriorChol = cell(totalRegions,1);
KcB = cell(totalRegions,1);
AtildePrevious = cell(totalRegions,1);
wtildePrevious = cell(totalRegions,1);
logLikelihood = NaN(totalRegions,1);
if isPredicting  % If predicting, pre-allocate space for necessary quantities
    posteriorMean = cell(totalRegions,1); 
    posteriorVariance = cell(totalRegions,1);
    Btilde = cell(totalRegions,1);
    predictions = cell(totalRegions,1);
    RposteriorChol = cell(totalRegions,1);
    KcholA = cell(totalRegions,1);
    Kcholw = cell(totalRegions,1);    
else 
    predictionLocationsj = num2cell(nan(totalRegions,1));  
end
% Check if predicting
%isPredicting = ~isnan(predictionLocationsj{end});

%% loop from coarsest to finest level

for iLevel = 1 : MAX_LEVEL_M    
    % Loop through all indices for a given iLevel and find ancestry
    for jIndex = (cumulativeRegions(iLevel) - nRegions(iLevel) + 1) : cumulativeRegions(iLevel)
        % Find ancestry of this jIndex
        indexAncestry = find_ancestry( jIndex, nRegions, NUM_PARTITIONS_J );
        % Calculate the prior quantities for this region using create_prior()
        [thisRpriorChol, thisKcholBchol, thisAtj, thiswtj, thisRetLikPred] = create_prior(theta, ...
            MAX_LEVEL_M, knots([indexAncestry;jIndex],1),RpriorChol(indexAncestry,1),KcB(indexAncestry,1), data{jIndex,1}, varEps, predictionLocationsj{jIndex,1});
        % Collect prior quantities for this region
        RpriorChol{jIndex} = thisRpriorChol;
        KcB{jIndex} = thisKcholBchol;
        if iLevel == MAX_LEVEL_M  % If highest resolution level
            AtildePrevious{jIndex} = thisAtj;
            wtildePrevious{jIndex} = thiswtj;
            if isPredicting  % If predicting
                posteriorMean{jIndex} = thisRetLikPred{1};
                posteriorVariance{jIndex}=thisRetLikPred{2};
                Btilde{jIndex} = thisRetLikPred{3};
            else % If not predicting
                logLikelihood(jIndex,1) = thisRetLikPred;
            end
        end
    end
    if verbose
        disp(['Prior Level ',num2str(iLevel), ' completed'])
    end
end
% Uncomment below if needed to save memory. Setting to empty vectors forces freeing memory as opposed to using clear.
% KcB = []; knots = []; % To save memory
%% Posterior inference 
% Loop iLevel from second finest to coarsest resolution
for iLevel = MAX_LEVEL_M-1 : -1 : 1
    if verbose
        disp(['Posterior Level ',num2str(iLevel),' starting']);
    end
    AtildeCurrrent = cell(totalRegions,1);
    wtildeCurrent = cell(totalRegions,1);
    % Loop jIndex through all regions for the level 
    for jIndex = (cumulativeRegions(iLevel) - nRegions(iLevel) + 1) : cumulativeRegions(iLevel)
        % Find index of child for this jIndex
        [ indexChildren ] = find_children( jIndex, nRegions, NUM_PARTITIONS_J  );             
        % Calculate posterior quantities
        RpriorCholj = RpriorChol{jIndex};
        wtildeChildren = wtildePrevious(indexChildren);
        AtildeChildren = AtildePrevious(indexChildren);
        % Calculate posterior_inference()
        [ wtildeCurrentj, AtildeCurrentj, logLikelihoodj, ...
            RposteriorCholj, Kcholwj, KcholAj ] = posterior_inference( RpriorCholj, ...
            wtildeChildren, AtildeChildren );

        wtildeCurrent{jIndex} = wtildeCurrentj;
        AtildeCurrrent{jIndex} = AtildeCurrentj;
        
        if isPredicting
            RposteriorChol{jIndex} = RposteriorCholj;
            Kcholw{jIndex} = Kcholwj;
            KcholA{jIndex} = KcholAj;          
        else
        logLikelihood(jIndex,1)=logLikelihoodj;
        end
    end
    wtildePrevious=wtildeCurrent;
    AtildePrevious=AtildeCurrrent;
end
% Uncomment below if needed to save memory. Setting to empty vectors forces freeing memory as opposed to using clear.
% wtildePrevious = []; AtildePrevious = []; RpriorChol = []; % To save memory

sumLogLikelihood=sum(logLikelihood);
%% Spatial prediction
if isPredicting    
    for jIndex = (cumulativeRegions(MAX_LEVEL_M) - nRegions(MAX_LEVEL_M) + 1) : cumulativeRegions(MAX_LEVEL_M)
        if (MAX_LEVEL_M > 0)
            indexAncestry = find_ancestry( jIndex, nRegions,NUM_PARTITIONS_J );
            predictions{jIndex,1} = spatial_prediction(posteriorMean{jIndex,1}, ...
                posteriorVariance{jIndex,1}, Btilde{jIndex,1}, ...
                RposteriorChol(indexAncestry,1), KcholA(indexAncestry,1), ...
                Kcholw(indexAncestry,1));
        else
            predictions{jIndex,:} = [posteriorMean(jIndex,1), posteriorVariance(jIndex,1)];
        end
    end
end