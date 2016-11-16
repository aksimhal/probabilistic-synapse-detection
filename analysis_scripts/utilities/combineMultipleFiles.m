% Combine multiple files into one
foldernames = {'Ex14R58'};

% foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
%     'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
%     'Ex6R15C1', 'Ex6R15C2', ...
%     'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51', 'Ex14R58'};

baseStr = '/data/anish/Synaptome/Chessboard/rawVolumes/';
targetStr = '/data/anish/Synaptome/Chessboard/rawVolumes_full/';

for folderInd=1:length(foldernames)
    disp(foldernames{folderInd});
    % get list of IF channels
    dataList = dir(strcat(baseStr, foldernames{folderInd}, filesep, '*.mat'));
    targetFolder = strcat(targetStr, foldernames{folderInd});
    
    isdir_result = isdir(targetFolder);
    if ~isdir_result
        mkdir(targetFolder);
    end
    
    strs = cell(length(dataList), 1);
    for n=1:length(dataList)
        foo = dataList(n).name;
        strs{n} = foo(1:end-7);
    end
    strs = unique(strs);
    
    for n = 1:length(strs)
        disp(strs{n});
        fn1 = strcat(baseStr, foldernames{folderInd}, filesep, strs{n}, '_p1');
        fn2 = strcat(baseStr, foldernames{folderInd}, filesep, strs{n}, '_p2');
        fn3 = strcat(baseStr, foldernames{folderInd}, filesep, strs{n}, '_p3');
        
        load(fn1);
        ch1_fn = strs{n};
        subVol1 = eval(ch1_fn);
        clear(ch1_fn);
        disp(size(subVol1));
        
        load(fn2);
        subVol2 = eval(ch1_fn);
        clear(ch1_fn);
        disp(size(subVol2));
        
        load(fn3);
        subVol3 = eval(ch1_fn);
        clear(ch1_fn);
        disp(size(subVol3));
        
        zDim = size(subVol1, 3) + size(subVol2, 3) + size(subVol3, 3);
        rawVol = zeros(size(subVol1, 1), size(subVol1, 2), zDim);
        startZ = 1; 
        endZ = size(subVol1, 3); 
        rawVol(1:size(subVol1, 1), 1:size(subVol1, 2), startZ:endZ) = subVol1;
        
        startZ = endZ + 1; 
        endZ = endZ + size(subVol2, 3); 
        rawVol(1:size(subVol1, 1), 1:size(subVol1, 2), startZ:endZ) = subVol2;
        
        startZ = endZ + 1; 
        endZ = endZ + size(subVol3, 3); 
        rawVol(1:size(subVol1, 1), 1:size(subVol1, 2), startZ:endZ) = subVol3;
        
        
        targetFileName = strcat(targetFolder, filesep, ch1_fn);
        
        save(targetFileName, 'rawVol', '-v7.3');
        
        clear('rawVol');
        disp('file merged');
        
        
    end
end


emailAnish('CombineMultipleFiles');


