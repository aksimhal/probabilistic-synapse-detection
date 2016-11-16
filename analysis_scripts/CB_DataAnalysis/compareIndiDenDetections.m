%% compareIndiDenDetections
%compare synapse detensity across layers

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};


detectionsStr = '/data/anish/Synaptome/Chessboard/results/';
maskBaseStr = '/data/anish/Synaptome/Chessboard/masks/';

probStr = '/data/anish/Synaptome/Chessboard/probVolumes/';
filebase = 'resultVol_';
load('boundaryMarkings');
numOfSections = [3, 3, 3, 3, 3, 3, 3, 6, 9, 9, 6];

ifchannels = {'PSD'};
thresholdList = 0.8:0.05:1;

% 1 - excitatory.  2 - inhibitory
densityMat = zeros(12, length(foldernames), 9, length(thresholdList));
disp('Starting synapse detection density analysis');

for folderInd=1:length(foldernames)
    filename = strcat(maskBaseStr, foldernames{folderInd}, 'mask'); 
    load(filename); 
    
    volListItr = 1;
    for numSectionItr = 1:numOfSections(folderInd)
        
        xiyi = boundaryMarkings{folderInd, numSectionItr};
        maskImg = poly2mask(xiyi(:, 1), xiyi(:, 2) , size(mask, 1), size(mask, 2));
        maskVol = repmat(maskImg, 1, 1, size(mask, 3));
        maskedData = mask .* maskVol;
        clear('maskVol');
        
        volumeList(volListItr) = nnz(maskedData);
        volListItr = volListItr + 1;
    end
    
    disp('Volume computed');
    clear('mask');
 

    for nCase=1:12 % excitatory & inhibitory
        
        load(strcat(detectionsStr, foldernames{folderInd}, filesep, filebase, num2str(nCase)));
        %resultVol = resultVol > threshold;
        
        densityMatItr = 1;
        
        for numSectionItr = 1:numOfSections(folderInd)
            
            xiyi = boundaryMarkings{folderInd, numSectionItr};
            maskImg = poly2mask(xiyi(:, 1), xiyi(:, 2) , size(resultVol, 1), size(resultVol, 2));
            maskVol = repmat(maskImg, 1, 1, size(resultVol, 3));
            maskedData = resultVol .* logical(maskVol);
            clear('maskVol');
            
            for thresholdItr = 1:length(thresholdList)
                cc = bwconncomp(maskedData > thresholdList(thresholdItr), 26);
                densityMat(nCase, folderInd, densityMatItr, thresholdItr) = cc.NumObjects./ volumeList(densityMatItr);
            end
            
            densityMatItr = densityMatItr + 1;
        end
        
        disp(' Synapses density calculated');
        
        clear('resultVol');
        clear('outputVol');
        
    end
    
end

save('indiDenDetections', 'densityMat', 'foldernames', 'ifchannels');
emailAnish('compare compareIndiDenDetections completed');
