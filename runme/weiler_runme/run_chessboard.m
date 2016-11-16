%% run synapse detection 
addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 
addpath(genpath('/Users/anish/Documents/Connectome/Synaptome-Duke/SynapseDetection/')); 


foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};

% Location of data 
baseStr = '/data/anish/Synaptome/Chessboard/';

% Foldername of data in probability space 
inputFolder = 'probVolumes';

% Output Foldername 
outputFolder = 'results';

% names of the channels being considered
ifchannels = {'PSD', 'Synapsin', 'vGluT1', 'vGluT2', 'GluR1', 'GluR2', ...
    'NR2B', 'Gephyrin', 'GABAARa', 'vGAT', 'GAD'};

%QueryList 
queryFilenameLists = {...
    'Chessboard_Queries - Ex2R18C1.csv', ...
    'Chessboard_Queries - Ex2R18C2.csv', ...
    'Chessboard_Queries - Ex3R43C1.csv', ...
    'Chessboard_Queries - Ex3R43C2.csv', ...
    'Chessboard_Queries - Ex3R43C3.csv', ...
    'Chessboard_Queries - Ex6R15C1.csv', ...
    'Chessboard_Queries - Ex6R15C2.csv', ...
    'Chessboard_Queries - Ex10R55.csv', ...
    'Chessboard_Queries - Ex12R75.csv', ...
    'Chessboard_Queries - Ex12R76.csv', ...
    'Chessboard_Queries - Ex13R51.csv'  ...   
};


for folderInd=1%:length(foldernames)
    
    % Create 'results' folder
    targetFolder = strcat(baseStr, outputFolder, filesep, foldernames{folderInd});
    isdir_result = isdir(targetFolder);
    if ~isdir_result
        mkdir(targetFolder);
    end
    
    dataLocation = strcat(baseStr, inputFolder, filesep, foldernames{folderInd}, filesep, 'prob_'); 
    
    queryList = createQueries(queryFilenameLists{folderInd});
    
    blobSize = 2;
    search_win = 2; 
    edge_win = 8; 
    
    for n=2%1:length(queryList)
        
        fprintf('about to start query %d \n', n);
        query = queryList{n};
        
        targetFileName = strcat(targetFolder, filesep, 'resultVol_', num2str(n));
        runQuery(query, dataLocation, targetFileName, blobSize, ...
                 search_win, edge_win)
        
    end
    
end

emailAnish('runCB completed');
