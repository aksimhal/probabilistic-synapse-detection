
baseStr = '/data/anish/Synaptome/kristina15/rawVolumesParts/';
targetFolder = '/data/anish/Synaptome/kristina15/rawVolumes/';

dataList = dir(strcat(baseStr, '*.mat'));

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
    fn1 = strcat(baseStr, strs{n}, '_p1');
    fn2 = strcat(baseStr, strs{n}, '_p2');
    fn3 = strcat(baseStr, strs{n}, '_p3');
    
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

emailAnish('CombineMultipleFiles');




