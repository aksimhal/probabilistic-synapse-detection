function finalResultVol = combineResultVolumes(resultVolLocations, ...
    edge_win, volSize, rRangeList, cRangeList)

finalResultVol = zeros(volSize);
% 
% resultVol = zeros(length(rRangeList(1, 1):rRangeList(2, 1)), ...
% length(cRangeList(1, 1):cRangeList(2, 1)), 39, 'uint8');


load(resultVolLocations{1}); 
finalResultVol(1:(rRangeList(2, 1) - edge_win), ...
    1:(cRangeList(2, 1) - edge_win), :) = ...
    resultVol(1:(end-edge_win), 1:(end-edge_win), :); 
disp('Merge one completed'); 

% resultVol = zeros(length(rRangeList(1, 1):rRangeList(2, 1)), ...
%  length(cRangeList(1, 2):cRangeList(2, 2)), 39, 'uint8');

load(resultVolLocations{2}); 
finalResultVol(1:(rRangeList(2, 1) - edge_win), ...
    (cRangeList(1, 2) + edge_win):end, :) = ...
    resultVol(1:(end-edge_win), (edge_win+1):end, :); 
disp('Merge two completed'); 

% resultVol = zeros(length(rRangeList(1, 2):rRangeList(2, 2)), ...
%   length(cRangeList(1, 1):cRangeList(2, 1)), 39, 'uint8');

load(resultVolLocations{3}); 
finalResultVol((rRangeList(1, 2) + edge_win):end, ...
    1:(cRangeList(2, 1) - edge_win), :) = ...
    resultVol((edge_win+1):end, 1:(end-edge_win), :); 
disp('Merge three completed'); 

% resultVol = zeros(length(rRangeList(1, 2):rRangeList(2, 2)), ...
%   length(cRangeList(1, 2):cRangeList(2, 2)), 39, 'uint8');


load(resultVolLocations{4}); 
finalResultVol((rRangeList(1, 2) + edge_win):end, ...
    (cRangeList(1, 2) + edge_win):end, :) = ...
    resultVol((edge_win+1):end, (edge_win+1):end, :); 
disp('Merge four completed'); 



end
























