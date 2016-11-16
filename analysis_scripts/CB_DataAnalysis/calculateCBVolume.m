%Calculate CB dataset volumes using dulaney triagulation 

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51', 'Ex14R58'};

baseStr = '/data/anish/Synaptome/Chessboard/rawVolumes/';

cbvolume = zeros(length(foldernames), 1);
se = strel('disk',17);


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
        
        areaVector = zeros(size(rawVol, 3), 1);
        
        for sliceInd = 1:size(rawVol, 3)
            img = rawVol(:, :, sliceInd);
            img = img > 0;
            bw = imclose(img, se);
            [r, c] = find(bw == 1);
            DT = delaunayTriangulation(c, r);
            [k, v] = convexHull(DT);
            disp(v);
            areaVector(sliceInd) = v * 0.1*0.1*0.07;
            
        end
        
        
    end
    
    cbvolume(folderInd) = sum(areaVector);
    
    disp(cbvolume(folderInd));
    
    disp(foldernames{folderInd});
end

save('volumeStats', 'cbvolume', 'foldernames');

emailAnish('CB Volume Calculated'); 

