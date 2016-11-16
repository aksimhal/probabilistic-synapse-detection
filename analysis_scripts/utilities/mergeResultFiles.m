function mergeResultFiles(caseNum)
% Merge result files 

load('gelatin_filenames');
numOfSplits = 2;
volSize = [7936, 9888, 39];
overlapWin = 1000;


resultVolume = zeros(7936, 9888, 39); 
load(filenames{1});
resultVolume(1:4969-500, 1:5945-500, :) = resultVol(1:end-500, 1:end-500, :); 
load(filenames{2});
resultVolume(1:4969-500, 4945+500:end, :) = resultVol(1:end-500, 501:end, :);
load(filenames{3}); 
resultVolume(3969+500:end, 1:5945-500, :) = resultVol(501:end, 1:end-500, :); 
load(filenames{4}); 
resultVolume(3969+500:end, 4945+500:end, :) = resultVol(501:end, 501:end, :); 

resultVol = resultVolume; 
clear resultVolume; 

resultVol = resultVol ./ max(resultVol(:));

filename = strcat('/data/anish/Synaptome/gelatin/gelatinResult_', num2str(caseNum)); 

save(filename, 'resultVol', '-v7.3');
disp('merge complete'); 

%            1        4969
%            1        5945
% 
% 
% ans =
% 
%            1        4969
%         4945        9888
% 
% 
% ans =
% 
%         3969        7936
%            1        5945
% 
% 
% ans =
% 
%         3969        7936
%         4945        9888




