function signalLineDensity(threshold, binSize)
% compare prob if detensity across layers
% divide sections into 200 px increments binSize


foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};

detectionsStr = '/data/anish/Synaptome/Chessboard/probVolumes/';
filebase = 'resultVol_';
maskStr = '/data/anish/Synaptome/Chessboard/masks/';


ifchannels = {'PSD', 'Synapsin', 'vGluT1', 'vGluT2', 'GluR1', 'GluR2',...
    'NR2B', 'Gephyrin', 'GABAARa', 'vGAT', 'GAD'};



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
    lineDensities = zeros(length(volumeList), length(ifchannels));
    volumeList = volumeList .* (0.1*0.1*0.07);
    
    
    % find filenames
    dataList = dir(strcat(detectionsStr, foldernames{folderInd}, filesep, '*.mat'));
    
    
    listOfFilenames = cell(length(ifchannels), 1);
    for chInd = 1:length(ifchannels)
        
        targetIFInd = 0;
        for IFind = 1:length(dataList)
            channelName = dataList(IFind).name;
            channelName = channelName(6:end);
            if (strcmp(channelName(1:length(ifchannels{chInd})), ifchannels{chInd}))
                targetIFInd = IFind;
                break;
            end
        end
        
        ch_fn = dataList(targetIFInd).name;
        ch_fn = ch_fn(1:end-4);
        listOfFilenames{chInd} = strcat(detectionsStr, foldernames{folderInd}, filesep,  ch_fn);
        
    end
    
    
    
    for nCase=1:length(listOfFilenames) % excitatory & inhibitory
        
        load(listOfFilenames{nCase});
        probVol = probVol > threshold;
        
        binStart = 1;
        
        for numSectionItr = 1:length(volumeList)
            
            if numSectionItr == length(volumeList)
                cc = bwconncomp(probVol(:, binStart:end, :), 26);
            else
                cc = bwconncomp(probVol(:, binStart:(binStart + binSize), :), 26);
            end
            binStart = binStart + binSize + 1;
            
            lineDensities(numSectionItr, nCase) = cc.NumObjects./ volumeList(numSectionItr);
        end
        
        disp(' Synapses density calculated');
        clear('resultVol');
        
        densityMat{folderInd} = lineDensities;
    end
    
end

save('signalLineDensity', 'densityMat', 'foldernames');
emailAnish('compare signalLineDensity completed');
