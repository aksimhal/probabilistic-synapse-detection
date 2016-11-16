function cb_synapseLineDensity(threshold, binSize)
% compare synapse detensity across layers
% divide sections into 200 px increments binSize


foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};

detectionsStr = '/data/anish/Synaptome/Chessboard/results/';
filebase = 'resultVol_';
maskStr = '/data/anish/Synaptome/Chessboard/masks/';

numOfQueries = 12; % 6 excitatory, 6 inhibitory
densityMat = cell(length(foldernames), 1);

disp('Starting synapse detection density analysis');

for folderInd=1:length(foldernames)
    
    disp(foldernames{folderInd});
    
    %find Mask Volume
    maskToLoad = strcat(maskStr, foldernames{folderInd}, 'mask');
    load(maskToLoad);
    disp('Mask Volume loaded');
    
    volumeList = zeros(floor(size(mask, 2) / binSize), 1);
    binStart = 1;
    for numSectionItr = 1:length(volumeList)
        
        if numSectionItr == length(volumeList)
            volumeList(numSectionItr) = nnz(mask(:, binStart:end, :));
        else
            volumeList(numSectionItr) = nnz(mask(:, binStart:(binStart + binSize), :));
        end
        binStart = binStart + binSize + 1;
        
    end
    
    disp('Volume computed');
    clear('mask');
    lineDensities = zeros(length(volumeList), 12);
    volumeList = volumeList .* (0.1*0.1*0.07);
    
    
    for nCase=1:12 % excitatory & inhibitory
        
        load(strcat(detectionsStr, foldernames{folderInd}, filesep, filebase, num2str(nCase)));
        resultVol = resultVol > threshold;
        
        binStart = 1;
        
        for numSectionItr = 1:length(volumeList)
            
            if numSectionItr == length(volumeList)
                cc = bwconncomp(resultVol(:, binStart:end, :), 26);
            else
                cc = bwconncomp(resultVol(:, binStart:(binStart + binSize), :), 26);
            end
            binStart = binStart + binSize + 1;
            
            lineDensities(numSectionItr, nCase) = cc.NumObjects./ volumeList(numSectionItr);
        end
        
        disp(' Synapses density calculated');
        clear('resultVol');
        
        densityMat{folderInd} = lineDensities;
    end
    
end

save('synapseLineDensity', 'densityMat', 'foldernames');
emailAnish('compare synapseLineDensity completed');
