%% run synapse detection 
addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 

% Location of csv queries 
queryFilename = 'conjugate_queries - silane.csv';

% Location of data 
baseStr = '/data/anish/Synaptome/silane/';

% Foldername of data in probability space 
inputFolder = 'probVolumes/prob_';

% Output Foldername 
outputFolder = 'results';

% Create 'results' folder 
targetFolder = strcat(baseStr, outputFolder);
isdir_result = isdir(targetFolder);
if ~isdir_result
    mkdir(targetFolder);
end

dataLocation = strcat(baseStr, inputFolder); 

queryList = createQueries(queryFilename);

% convolution window size 
%blobSize = 101; %101*2.33mn

blobSize = 87; 

% search grid size
%search_win = 126;
search_win = 88;

% edge buffer size
edge_win = 200;


for n=1:length(queryList) 
    
    fprintf('about to start query %d \n', n); 
    query = queryList{n}; 
    
    targetFileName = strcat(targetFolder, filesep, 'resultVol_', num2str(n)); 
    runQuery(query, dataLocation, targetFileName, blobSize, search_win, edge_win); 
    
end

emailAnish('run_silane completed');



