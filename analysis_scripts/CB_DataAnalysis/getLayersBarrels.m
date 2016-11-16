% get sections

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51', 'Ex14R58'};

baseStr = '/Users/anish/Documents/Connectome/dapi/';

numOfSections = [3, 3, 3, 3, 3, 3, 3, 6, 9, 9, 6, 9]; 

%boundaryMarkings = cell(length(foldernames), 9); 
figure('units','normalized','outerposition',[0 0 1 1])

% LAYER FIRST, BARREL SECOND 
for n=11%:length(foldernames)
    
    load(strcat(baseStr, foldernames{n}, filesep, 'mipdapi'));
    imagesc(mipdapi); 
    title(foldernames{n}); 
    sectionItr = 1; 
    disp(foldernames{n}); 
    for m = 1:numOfSections(n)
        disp(numOfSections(n));
        disp(sectionItr); 
        [x, y, BW, xi, yi] = roipoly;
        boundaryMarkings{n, sectionItr} = [xi, yi]; 
        sectionItr = sectionItr + 1; 
        disp(xi); 
        disp(xi); 
        
    end
    
end

save('boundaryMarkings', 'boundaryMarkings'); 
