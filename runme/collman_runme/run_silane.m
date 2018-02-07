%% run synapse detection 
% SYNAPTOME-Duke
addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 

% Location of csv queries 
queryFilename = 'cat_queries/conjugate_queries - silane.csv';

% Location of data 
dataLocation = '/data/anish/Synaptome/silane/rawVolumes/';

%Location of Mask
masklocation = '/data/anish/Synaptome/silane/silaneMask';

% Output Foldername 
outputFolder = '/data/anish/Synaptome/silane/results/';

queryList = createQueries(queryFilename);

% convolution window size 

blobSize = 87; 

% search grid size
search_win = 88;

% edge buffer size
edge_win = 200;


for n=1:length(queryList) 
    
    fprintf('about to start query %d \n', n); 
    query = queryList{n}; 
    
    outputfilename = strcat(outputFolder, filesep, 'resultVol_', num2str(n)); 

    runQuery(query, dataLocation, outputfilename, masklocation, blobSize, search_win, edge_win)
end


disp('Complete');




