%% run synapse detection 
addpath(genpath('/Users/anish/Documents/Connectome/probabilistic-synapse-detection/')); 

% Location of csv queries 
queryFilename = 'sampleQueries.csv';

% Location of data 
baseStr = '/Users/anish/Documents/Connectome/probabilistic-synapse-detection/runme/sample_runme/sample_data/';

% Output Foldername 
outputFolder = 'results';


% Create 'results' folder 
targetFolder = strcat(baseStr, outputFolder);
isdir_result = isdir(targetFolder);
if ~isdir_result
    mkdir(targetFolder);
end

dataLocation = baseStr; 

queryList = createQueries(queryFilename);

% convolution window size 
blobSize = 2; 

% search grid size
search_win = 2;

% edge buffer size
edge_win = 8;

for n=1:length(queryList) 
    
    fprintf('about to start query %d \n', n); 
    query = queryList{n}; 
    
    targetFileName = strcat(targetFolder, filesep, 'resultVol_', num2str(n)); 
    
    runQuery(query, dataLocation, targetFileName, blobSize, search_win, edge_win);


end






