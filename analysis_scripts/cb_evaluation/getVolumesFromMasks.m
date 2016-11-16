% get volumes from masks  

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};

baseStr = '/data/anish/Synaptome/Chessboard/masks/';
cbvolume = zeros(12, 1);

for folderInd=1:length(foldernames)
    filename = strcat(baseStr, foldernames{folderInd}, 'mask'); 
    load(filename); 
    
    cbvolume(folderInd) = nnz(mask) * 0.1*0.1*0.07;
    
    disp(cbvolume(folderInd));
end

save('volumeStats', 'cbvolume', 'foldernames');


