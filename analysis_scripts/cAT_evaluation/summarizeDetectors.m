function summarizeDetectors(inputStrs)

for n=1:length(inputStrs)
    %filename = strcat('calculate_accuracy_', num2str(inputNumbers(n)));
    load(inputStrs{n});
    fprintf('Classifier: %d\n', (n));
    fprintf('Num Synapse Labels Detected: %d\n', nnz(isLabelGood_thresh));
    fprintf('False Positive: %d blobs, TP: %d, FP Percentage: %f\n', ...
        nnz(fp_blobs), nnz(tp_blobs), nnz(fp_blobs)/(nnz(fp_blobs) + nnz(tp_blobs)));
    fprintf('\n');
end


end

