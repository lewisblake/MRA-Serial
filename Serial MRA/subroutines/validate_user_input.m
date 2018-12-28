function [] = validate_user_input(NUM_LEVELS_M, NUM_PARTITIONS_J, NUM_KNOTS_r, offsetPercentage, nXGrid, nYGrid, displayPlots, savePlots, verbose, resultsFilePath, plotsFilePath)
%% USER_INPUT_ERROR_HANDLING checks validity of user input
%
%   Input: NUM_LEVELS_M (double), NUM_PARTITIONS_J (double), NUM_KNOTS_r
%   (knots), offsetPercentage (double), nXGrid (double), nYGrid (double)
%
%   Output: [] (empty vector)
%

% Error handling on all input arguments except for dataSource which is
% checked within load_data.m
if (~isinf(NUM_LEVELS_M) && floor(NUM_LEVELS_M) ~= NUM_LEVELS_M) || ~isa(NUM_LEVELS_M, 'double') || isinf(NUM_LEVELS_M)
    error('myfuns:user_input_error_handling: NUM_LEVELS_M must be a positive integer of class double.')
elseif (NUM_PARTITIONS_J ~= 2 && NUM_PARTITIONS_J ~= 4) || (~isinf(NUM_PARTITIONS_J) && floor(NUM_PARTITIONS_J) ~= NUM_PARTITIONS_J) || ~isa(NUM_PARTITIONS_J, 'double') || isinf(NUM_PARTITIONS_J)
    error('myfuns:user_input_error_handling: NUM_PARTITIONS_J must be either 2 or 4.')
elseif (~isinf(NUM_KNOTS_r) && floor(NUM_KNOTS_r) ~= NUM_KNOTS_r) || ~isa(NUM_KNOTS_r, 'double') || isinf(NUM_KNOTS_r)
    error('myfuns:user_input_error_handling: NUM_KNOTS_r must be a positive integer of class double.')
elseif (offsetPercentage < 0 || offsetPercentage >= 1) || ~isa(offsetPercentage, 'double') || isinf(offsetPercentage)
    error('myfuns:user_input_error_handling: offsetPercentage must be between 0 and 1.')
elseif (~isinf(nXGrid) && floor(nXGrid) ~= nXGrid) || ~isa(nXGrid, 'double') || isinf(nXGrid) || nXGrid < 1
    error('myfuns:user_input_error_handling: nXGrid must be a positive integer of class double.')
elseif (~isinf(nYGrid) && floor(nYGrid) ~= nYGrid) || ~isa(nYGrid, 'double') || isinf(nYGrid) || nYGrid < 1
    error('myfuns:user_input_error_handling: nYGrid must be a positive integer of class double.')
elseif ~islogical(displayPlots)
    error('myfuns:user_input_error_handling: displayPlots must be a boolean.')
elseif ~islogical(savePlots)
    error('myfuns:user_input_error_handling: savePlots must be a boolean.')
elseif ~islogical(verbose)
    error('myfuns:user_input_error_handling: verbose must be a boolean.')
elseif ~ischar(resultsFilePath)
    error('myfuns:user_input_error_handling: resultsFilePath must be a char. See default.')
elseif ~ischar(plotsFilePath)
    error('myfuns:user_input_error_handling: plotsFilePath must be a char. See default.')
end

end

