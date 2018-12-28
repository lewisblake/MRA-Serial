function [ indexChildren ] = find_children( index, nRegions, NUM_PARTITIONS_J  )
%% FIND_CHILDREN finds immediate children for different cases of index
%   Find children at resolution right below current
%
%   Input: index (double), nRegions (vector), NUM_PARTITIONS_J (double)
%
%   Output: indexChildren (vector)
cumulativeRegions = cumsum(nRegions);

if length(cumulativeRegions) == 1  % Check that there is more than one region total
    error('myfuns:find_children:OnlyOneRegion', ...
        'no chidren if only one region');
end

if index > cumulativeRegions(end-1)
    indexChildren = []; % No children on finest resolution level
else
    switch  index
        case 1
            % Special case for zeroth region
            indexChildren = 2 : cumulativeRegions(2);
        otherwise
            indexChildren = find_child( index,nRegions,NUM_PARTITIONS_J  ); % Only immediate children
    end
end
end


