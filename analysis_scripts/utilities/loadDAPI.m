baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/ChessboardAnalysis/data_DL/';

foldernames = {'Ex2R18_C1_DAPI1', 'Ex2R18_C2_DAPI1', 'Ex3R43_C1_DAPI1', ...
    'Ex3R43_C2_DAPI1', 'Ex3R43_C3_DAPI1', 'Ex6R15_C1_DAPI1', 'Ex6R15_C2_DAPI1', ...
    'Ex10R55_DAPI1', 'Ex12R75_DAPI1', 'Ex12R76_DAPI1', 'Ex13R51_DAPI1', ...
    'Ex14R58_DAPI1'};


for folderInd = 10%:length(foldernames)
    disp(foldernames{folderInd}); 
    
    filename = sprintf('DAPI-1-S%03d.tif', 1);
    img = imread(strcat(baseStr, foldernames{folderInd}, filesep, filename));
    disp(filename);
    listoffiles = dir(strcat(baseStr, foldernames{folderInd}, filesep, '*.tif'));
    %rawVolumes = zeros(size(img, 1), size(img, 2), length(listoffiles));
    rawVolumes = zeros(size(img, 1), size(img, 2), 18);
    for n=20:length(listoffiles)-1
        filename = sprintf('DAPI-1-S%03d.tif', n);
        disp(filename);
        img = imread(strcat(baseStr, foldernames{folderInd}, filesep, filename));
        rawVolumes(:, :, n-19) = img;
        
    end
    
    
    targetFilepath = strcat(baseStr, foldernames{folderInd}, filesep, 'DAPI_1');
    save(targetFilepath, 'rawVolumes', '-v7.3');
    disp('File Saved');
    
end

