
inputNumbers = [1, 2, 3, 4, 5, 6, 7];
load('gelatin_isgaba');

baseStr = '/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/gelatin_gaba_results/0.7/';

inputStrs = cell(length(inputNumbers), 1);
for n=1:length(inputStrs)
    inputStrs{n} = strcat(baseStr, 'calculate_accuracy_', num2str(inputNumbers(n)));
end

gelatin = true;
[truePositiveLabels, edgeLabels, detectedOther, numMissed, missedGABA] = combineDetectionsGABA(inputStrs, gelatin);
summarizeDetectors(inputStrs);

[pixelList_FP] = combine_FP(inputStrs, true);
[pixelList_TP] = combine_TP(inputStrs, true);

fprintf('FP Percentage: %f\n', length(pixelList_FP) / (length(pixelList_FP) + length(pixelList_TP)));
fprintf('Precision: %f\n', (length(pixelList_TP)) / (length(pixelList_FP) + length(pixelList_TP)));
fprintf('Recall: %f\n', nnz(truePositiveLabels) / (nnz(truePositiveLabels) + numMissed));


save('gelatin_gaba_results', 'pixelList_FP', 'pixelList_TP',...
        'truePositiveLabels', 'edgeLabels', 'missedGABA'); 