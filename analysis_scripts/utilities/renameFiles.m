%% RenameFiles
% Ex3R43C1
foldernames = {'Ex3R43C1', 'Ex2R18C1', ...
    'Ex2R18C2', 'Ex3R43C2', 'Ex3R43C3', 'Ex6R15C1' ...
    'Ex6R15C2', 'Ex12R75', 'Ex13R51', 'Ex10R55', 'Ex14R58', 'Ex12R76'};
baseStr = '/data/anish/Synaptome/Chessboard/rawVolumes/';


for folderInd=1%length(foldernames)
    
    dataList = dir(strcat(baseStr, foldernames{folderInd}, filesep, '*.mat'));
    
    for ifInd=1:length(dataList)
        disp(dataList(ifInd).name);
        
        fn1 = strcat(baseStr, foldernames{folderInd}, filesep, dataList(ifInd).name);
        load(fn1);
        ch1_fn = dataList(ifInd).name;
        ch1_fn = ch1_fn(1:end-4);
        try
            rawVol = eval(ch1_fn);
        catch
            disp('filename already fixed'); 
            clear('rawVol');
            continue;
        end
        
        clear(ch1_fn);
        
        targetFileName = strcat(baseStr, foldernames{folderInd}, filesep, ch1_fn);
        save(targetFileName, 'rawVol', '-v7.3');
        
        clear('rawVol');
        disp('filename fixed'); 
        
        disp(dataList(ifInd).name);
        
    end
    
end

emailAnish('renameFiles'); 
