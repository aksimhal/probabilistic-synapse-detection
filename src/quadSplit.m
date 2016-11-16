function [rRangeList, cRangeList] = quadSplit(volSize, edge_win) 

rRangeList = zeros(2, 2); 
cRangeList = zeros(2, 2); 

rangeWinR = floor(volSize(1) / 2);
rangeWinC = floor(volSize(2) / 2);

rRangeList(:, 1) = [1, rangeWinR + edge_win]; 
rRangeList(:, 2) = [rangeWinR - edge_win, volSize(1)]; 

cRangeList(:, 1) = [1, rangeWinC + edge_win]; 
cRangeList(:, 2) = [rangeWinC - edge_win, volSize(2)]; 

end 

