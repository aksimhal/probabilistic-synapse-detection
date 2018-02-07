function aggregateDetections(gelatin)

addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 

if (gelatin)
    inputNumbers = [1, 2, 3, 4, 5, 6, 7]; %Gelatin

else
    inputNumbers = [1, 2, 3, 4, 6, 7]; %Silane
end


[idum, hostname]= system('hostname');
macStr = 'anish';

if gelatin
    
    if (strcmp(hostname(1:length(macStr)), macStr))
        baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/gelatin_results/0.55/';
    else
        baseStr = '/data/anish/Synaptome/gelatin/gelatin_results/0.6/';
    end
    
else
    
    if (strcmp(hostname(1:length(macStr)), macStr))
        baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/silane data/silane_results/0.55/';
    else
        baseStr = '/data/anish/Synaptome/silane/silane_results/0.55/';
    end
    
end


inputStrs = cell(length(inputNumbers), 1);

for n=1:length(inputStrs)
    inputStrs{n} = strcat(baseStr, 'calculate_accuracy_', num2str(inputNumbers(n)));
end


[truePositiveLabels, edgeLabels, inds] = combineDetectionsCAT(inputStrs, gelatin);
summarizeDetectors(inputStrs);

[pixelList_FP] = combine_FP(inputStrs, gelatin);
[pixelList_TP] = combine_TP(inputStrs, gelatin);


fprintf('FP Percentage: %f\n', length(pixelList_FP) / (length(pixelList_FP) + length(pixelList_TP)));

fprintf('Precision: %f\n', (length(pixelList_TP)) / (length(pixelList_FP) + length(pixelList_TP)));
fprintf('Recall: %f\n', nnz(truePositiveLabels) / (nnz(truePositiveLabels) + length(inds)));

if (gelatin) 
    save('gelatin_results', 'pixelList_FP', 'pixelList_TP',...
        'truePositiveLabels', 'edgeLabels'); 
else 
    save('silane_results', 'pixelList_FP', 'pixelList_TP',...
        'truePositiveLabels', 'edgeLabels'); 

end






