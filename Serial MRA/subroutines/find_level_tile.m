function [ level, tile ] = find_level_tile( index, nRegions )
%% FIND_LEVEL_TILE Finds the level and tile number
%   This function finds the level and tile number given the continuous
%   index as an input
%
%   Input: index, nRegions
%
%   Output: level, tile
switch  index
    case 1
        level = 1; tile = 1; % Special case for zeroth region
    otherwise
        cumulativeRegions = cumsum(nRegions);
        indexSmaller = find(cumulativeRegions<index,1,'last');
        level = indexSmaller + 1;
        tile = index - cumulativeRegions(indexSmaller);
end
end

