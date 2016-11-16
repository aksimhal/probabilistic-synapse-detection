function lineDensities = synapseLineDensity(volLocations, mask, threshold, binSize)
% compare synapse detensity across layers
% divide sections into n px increments binSize

disp('Starting synapse detection density analysis');

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

lineDensities = zeros(length(volumeList), length(volLocations));
volumeList = volumeList .* (0.1*0.1*0.07);


for nCase=1:length(volLocations) 
    
    load(volLocations{nCase});
    
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
    
end

