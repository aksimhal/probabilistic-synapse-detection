inputNumbers = [1, 3, 4, 5, 6, 7]; %Gelatin
itr = 1;
precisionVec = zeros(length(0:0.1:1), 1);
recallVec = zeros(length(0:0.1:1), 1);

load('/data/anish/Synaptome/gelatin/gelatinLabels');
load('/data/anish/Synaptome/gelatin/gelatin_isedge');
load('/data/anish/Synaptome/gelatin/gelatin_isgaba');

CC_labels = CC;

% Define edge
edge_win = 125;
zedge = 1;

baseStr = '/data/anish/Synaptome/gelatin/newGelatin/';
load(strcat(baseStr, 'gelatinResult_', num2str(1)));
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


for threshold = 0.1:0.1:1
    itr = itr + 1;

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
    
    precisionVec(itr) = num_TP_blobs / (num_FP_blobs + num_TP_blobs); 
    recallVec(itr) = labels_TP / (labels_TP + labels_FN); 
    num_TP_blobs / (num_FP_blobs + num_TP_blobs)
    labels_TP / (labels_TP + labels_FN) 
end


save('pr_prob', 'precisionVec', 'recallVec');
