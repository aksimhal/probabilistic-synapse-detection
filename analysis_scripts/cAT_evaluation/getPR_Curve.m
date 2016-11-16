% Result Analysis


gaba = true;
gelatin = true;
if (gelatin)
    inputNumbers = [1, 2, 3, 4, 5, 6, 7]; %Gelatin
    baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/gelatin_results/';
else
    inputNumbers = [1, 3, 4, 6, 7]; %Silane
    baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/silane data/silane_results/';
end


if gaba
    baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/gelatin_gaba_results/';
    inputNumbers = 1:9;
end


thresholdVec = 0.5:0.05:1;

precisionVec = zeros(length(thresholdVec), 1);
recallVec = zeros(length(thresholdVec), 1);
vecItr = 1;
load('gelatin_isgaba');

for threshold = 0.5:0.05:1
    disp(threshold);
    
    folderStr = strcat(baseStr, num2str(threshold));
    
    inputStrs = cell(length(inputNumbers), 1);
    for n=1:length(inputStrs)
        inputStrs{n} = strcat(folderStr, filesep, 'calculate_accuracy_', num2str(inputNumbers(n)));
    end
    
    disp('Combine detections');
    if gaba
        [detectedGABA, edgeandfriends, detectedOther, numMissed, gabaedge] = combineDetectionsGABA(inputStrs, gelatin);
    else
        [psdandfriends, edgeandfriends, inds] = combineDetectionsCAT(inputStrs, gelatin);
    end
    disp('Comebine FP');
    [pixelList_FP] = combine_FP(inputStrs, gelatin);
    disp('Combine TP');
    [pixelList_TP] = combine_TP(inputStrs, gelatin);
    
    if gaba
        
        fprintf('FP Percentage: %f\n', length(pixelList_FP) / (length(pixelList_FP) + length(pixelList_TP)));
        
        
        fprintf('Precision: %f\n', (length(pixelList_TP)) / (length(pixelList_FP) + length(pixelList_TP)));
        fprintf('Recall: %f\n', nnz(detectedGABA) / (nnz(detectedGABA) + numMissed));
        
        precisionVec(vecItr) = (length(pixelList_TP)) / (length(pixelList_FP) + length(pixelList_TP));
        recallVec(vecItr) = nnz(detectedGABA) / (nnz(detectedGABA) + numMissed);
        
    else
        
        fprintf('Precision: %f\n', (length(pixelList_TP)) / (length(pixelList_FP) + length(pixelList_TP)));
        fprintf('Recall: %f\n', nnz(psdandfriends) / (nnz(psdandfriends) + length(inds)));
        
        precisionVec(vecItr) = (length(pixelList_TP)) / (length(pixelList_FP) + length(pixelList_TP));
        recallVec(vecItr) = nnz(psdandfriends) / (nnz(psdandfriends) + length(inds));
    end
    
    
    vecItr = vecItr + 1;
end

precisionVec(end) = 1;

figure;
plot(thresholdVec, precisionVec, 'LineWidth', 4);
hold on;
plot(thresholdVec, recallVec, 'LineWidth', 4);
legend('Precision', 'Recall');
xlabel('Threshold Values');
ylabel('Precision/Recall');
%title('Excitatory Synapse Detection in KDM-SYN-140115'); %Gelatin
%title('Inhibitory Synapse Detection in KDM-SYN-140115'); %Gelatin
title('Excitatory Synapse Detection in KDM-SYN-120905'); %Silane
set(gca,'fontsize', 18)

