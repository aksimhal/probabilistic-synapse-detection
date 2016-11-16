% createCBMasks

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};

baseStr = '/data/anish/Synaptome/Chessboard/rawVolumes/';
se = strel('disk', 25);
outputFolder = '/data/anish/Synaptome/Chessboard/masks/';

for folderInd=1:length(foldernames)
    dataList = dir(strcat(baseStr, foldernames{folderInd}, filesep, '*.mat'));
    
    folderStats = cell(length(dataList), 1);
    foldername = foldernames{folderInd};
    disp(foldername);
    
    
    for IFind = 1:length(dataList)
        channelName = dataList(IFind).name;
        if (~strcmp(channelName(1:3), 'PSD'))
            continue;
        end
        disp(dataList(IFind).name);
        
        fn1 = strcat(baseStr, foldernames{folderInd}, filesep, dataList(IFind).name);
        load(fn1);
        disp('volume loaded');
        
        mask = zeros(size(rawVol));
        
        for z=1:size(rawVol, 3)
            img = rawVol(:, :, z);
            img = img > 0;
            bw = imclose(img, se);
            
            mask(:, :, z) = bw;
            
        end
        
        mask = logical(mask);
        
        targetFolder = strcat(outputFolder, foldernames{folderInd});
        isdir_result = isdir(targetFolder);
        if ~isdir_result
            mkdir(targetFolder);
        end
        
        filename = strcat(targetFolder, 'mask');
        
        save(filename, 'mask', '-v7.3');
        
    end
    disp('masked saved');
    
end


emailAnish('CB Masks Calculated');





