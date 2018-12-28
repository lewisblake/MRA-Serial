function [ indexChildren ] = find_child( index, nRegions, NUM_PARTITIONS_J )
%% FIND_CHILD finds child of region
%   Input: index (double), nRegions (vector), NUM_PARTITIONS_J (double)
%
%   Output: indexChildren (vector)
        [ level, tile ] = find_level_tile( index, nRegions );
        levelChildren = level + 1;
        tileChildren=(NUM_PARTITIONS_J * (tile-1) + 1) : (NUM_PARTITIONS_J * tile);
        indexChildren=zeros(length(tileChildren),1, 'int64');
        for k = 1 : length(tileChildren)
            indexChildren(k) = find_index( levelChildren, tileChildren(k), nRegions );
        end

end

