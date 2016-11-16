function compareBlobDensityDetections(threshold)
% compare synapse detensity across layers

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};


detectionsStr = '/data/anish/Synaptome/Chessboard/results/';
probStr = '/data/anish/Synaptome/Chessboard/probVolumes/';
filebase = 'resultVol_';
load('boundaryMarkings');
numOfSections = [3, 3, 3, 3, 3, 3, 3, 6, 9, 9, 6];

ifchannels = {'PSD'};



% 1 - excitatory.  2 - inhibitory
densityMat = zeros(2, length(foldernames), 9);
disp('Starting synapse detection density analysis');

for folderInd=1:length(foldernames)
    
    %find PSD Volume
    dataList = dir(strcat(probStr, foldernames{folderInd}, filesep, '*.mat'));
    disp(foldernames{folderInd});
    
    targetIFInd = 0;
    for dirInd = 1:length(dataList)
        channelName = dataList(dirInd).name;
        channelName = channelName(6:end);
        if (strcmp(channelName(1:length(ifchannels{1})), ifchannels{1}))
            targetIFInd = dirInd;
            break;
        end
    end
    
    ch1_fn = dataList(targetIFInd).name;
    ch1_fn = ch1_fn(1:end-4);
    disp(ch1_fn);
    fn1 = strcat(probStr, foldernames{folderInd}, filesep,  ch1_fn);
    load(fn1); % Loads as probVol
    disp('IF Volume loaded');
    
    volListItr = 1;
    for numSectionItr = 1:numOfSections(folderInd)
        
        xiyi = boundaryMarkings{folderInd, numSectionItr};
        maskImg = poly2mask(xiyi(:, 1), xiyi(:, 2) , size(probVol, 1), size(probVol, 2));
        maskVol = repmat(maskImg, 1, 1, size(probVol, 3));
        maskedData = probVol .* maskVol;
        clear('maskVol');
        
        volumeList(volListItr) = getVolume(maskedData);
        volListItr = volListItr + 1;
    end
    
    disp('Volume computed');
    clear('probVol');
    
    for nCase=1:2 % excitatory & inhibitory
        
        if nCase == 1
            load(strcat(detectionsStr, foldernames{folderInd}, filesep, filebase, num2str(1)));
            outputVol = resultVol > threshold;
            for nn = 2:6
                load(strcat(detectionsStr, foldernames{folderInd}, filesep, filebase, num2str(nn)));
                resultVol = resultVol > threshold;
                outputVol = outputVol + resultVol;
                fprintf('loaded resultvol: %d \n', nn);
            end
        else
            load(strcat(detectionsStr, foldernames{folderInd}, filesep, filebase, num2str(7)));
            outputVol = resultVol > threshold;
            for nn = 8:12
                load(strcat(detectionsStr, foldernames{folderInd}, filesep, filebase, num2str(nn)));
                resultVol = resultVol > threshold;
                outputVol = outputVol + resultVol;
                fprintf('loaded resultvol: %d \n', nn);
            end
        end
        
        densityMatItr = 1;
        
        for numSectionItr = 1:numOfSections(folderInd)
            
            xiyi = boundaryMarkings{folderInd, numSectionItr};
            maskImg = poly2mask(xiyi(:, 1), xiyi(:, 2) , size(outputVol, 1), size(outputVol, 2));
            maskVol = repmat(maskImg, 1, 1, size(outputVol, 3));
            maskedData = outputVol .* maskVol;
            clear('maskVol');
            
            cc = bwconncomp(maskedData > 0, 26);
            densityMat(nCase, folderInd, densityMatItr) = cc.NumObjects./ volumeList(densityMatItr);
            densityMatItr = densityMatItr + 1;
        end
        
        disp(' Synapses density calculated');
        
        clear('resultVol');
        clear('outputVol');
        
    end
    
end

save('densityMatSynapses', 'densityMat', 'foldernames', 'ifchannels');
emailAnish('compare synaptic density completed');
