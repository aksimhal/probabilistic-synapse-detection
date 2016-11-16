function calculate_accuracy(silane, gaba, threshold, smallBlobWindow, label_win,...
    trialNum)

if (silane)
    filename = strcat('/data/anish/Synaptome/silane/results/resultVol_', num2str(trialNum));
    load(filename);
    load('/data/anish/Synaptome/silane/silaneMask.mat');
    load('/data/anish/Synaptome/silane/silaneLabels.mat');
    load('/data/anish/Synaptome/silane/isedge');
    load('/data/anish/Synaptome/silane/isgaba');

else    
    if (gaba)
        filename = strcat('/data/anish/Synaptome/gelatin/gaba_results/resultVol_', num2str(trialNum));
    else
        filename = strcat('/data/anish/Synaptome/gelatin/results/resultVol_', num2str(trialNum));
    end 
    
    load(filename);
    load('/data/anish/Synaptome/gelatin/gelatinLabels');
    load('/data/anish/Synaptome/gelatin/gelatin_isedge');
    load('/data/anish/Synaptome/gelatin/gelatin_isgaba');
    disp('data loaded');
end

CC_labels = CC;

% Define edge
edge_win = 125;
zedge = 1;

% Label all detections
CC_detections = bwconncomp(resultVol > 0.01, 26);
disp('CC_detections');

% true if it is an edge blob
edgeblobs = findEdgeElement(CC_detections, CC_detections.PixelIdxList, ...
    edge_win, zedge);

% true if it is a label on the edge
edgelabels = findEdgeElement(CC_labels, CC_labels.PixelIdxList, ...
    edge_win, zedge);

% Consolidate edge labels
edgelabels = double(edgelabels) + double(isedge(:));
edgelabels = edgelabels > 0;
disp('edges determined');

isBlobGood = centroidMatch(CC_labels, CC_detections, edgeblobs, label_win);
isLabelGood = centroidMatch(CC_detections, CC_labels, edgelabels, label_win);
disp('Centroids matched');

% Threshold resultVol
CC_detections_thresh = bwconncomp(resultVol > threshold, 26);

edgeblobs_thresh = findEdgeElement(CC_detections_thresh, CC_detections_thresh.PixelIdxList, ...
    edge_win, zedge);

edgeblobs_thresh = getSmallBlobs(CC_detections_thresh, edgeblobs_thresh, smallBlobWindow);
disp('edges determined');

isBlobGood_thresh = centroidMatch(CC_labels, CC_detections_thresh, edgeblobs_thresh, label_win);
isLabelGood_thresh = centroidMatch(CC_detections_thresh, CC_labels, edgelabels, label_win);

sum(isLabelGood_thresh);
disp('labels with blobs threshold');

labels_TP = sum(isLabelGood_thresh);
labels_FN = sum(isLabelGood) - sum(isLabelGood_thresh);

tp_blobs = zeros(size(isBlobGood_thresh));
fp_blobs = zeros(size(isBlobGood_thresh));

for n=1:length(isBlobGood_thresh)
    if (edgeblobs_thresh(n) == 1)
        continue;
    end
    
    if isBlobGood_thresh(n) == 0
        fp_blobs(n) = 1;
    else
        tp_blobs(n) = 1;
    end
end

num_FP_blobs = nnz(fp_blobs);
num_TP_blobs = nnz(isBlobGood_thresh);


if (silane)
    baseDir = '/data/anish/Synaptome/silane/silane_results/';
else
    if(gaba)
        baseDir = '/data/anish/Synaptome/gelatin/gelatin_gaba_results/';
    else
        baseDir = '/data/anish/Synaptome/gelatin/gelatin_results/';
    end
    
end


targetFolder = strcat(baseDir, filesep, num2str(threshold));
isdir_result = isdir(targetFolder);
if ~isdir_result
    mkdir(targetFolder);
end


filename = strcat(targetFolder, filesep, 'calculate_accuracy_', num2str(trialNum));
save(filename, 'isgaba', 'isLabelGood_thresh',...
    'isedge', 'CC_detections_thresh', 'tp_blobs', 'fp_blobs', 'labels_FN', 'labels_TP', ...
    'edgeblobs_thresh', 'edgelabels', 'num_TP_blobs', '-v7.3');


disp('data saved');

