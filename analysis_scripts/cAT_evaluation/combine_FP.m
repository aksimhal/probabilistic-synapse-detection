function [pixelList] = combine_FP(inputStrs, gelatin)
% count number of false positive blobs

%filename = strcat('calculate_accuracy_', num2str(inputNumbers(1)));

[idum, hostname]= system('hostname');
macStr = 'anish';
otherStr = 'wl-10';

if gelatin
    if (strcmp(hostname(1:length(macStr)), macStr))
        load('/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/gelatinLabels');
    elseif (strcmp(hostname(1:length(otherStr)), otherStr))
        load('/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/gelatinLabels');
    else
        load('/data/anish/Synaptome/gelatin/gelatinLabels');
    end
    
else
    if (strcmp(hostname(1:length(macStr)), macStr))
        load('/Users/anish/Documents/Connectome/Synaptome-Duke/data_DL/silane data/silaneLabels');
    else
        load('/data/anish/Synaptome/silane/silaneLabels');
    end
    
end

CC_labels = CC;




load(inputStrs{1});

pixelList = CC_detections_thresh.PixelIdxList;
inds = find(fp_blobs ~= 0);
pixelList = pixelList(inds);

if (length(inputStrs) == 1)
    return;
end


for nInd=2:length(inputStrs)
    %filename = strcat('calculate_accuracy_', num2str(inputNumbers(nInd)));
    load(inputStrs{nInd});
    
    newPixelList = CC_detections_thresh.PixelIdxList;
    inds = find(fp_blobs ~= 0);
    newPixelList = newPixelList(inds);
    
    itr = 1;
    indToRemove = [];
    for n=1:length(newPixelList)
        for m=1:length(pixelList)
            
            overlap_inds = fastintersect(pixelList{m}, newPixelList{n});
            if ~isempty(overlap_inds)
                indToRemove(itr) = m;
                itr = itr + 1;
            end
        end
        
    end
    
    pixelList(indToRemove) = [];
    pixelList = [pixelList, newPixelList];
    indToRemove = [];
    
end


%fprintf('Total Num of original FP: %d\n', length(pixelList));

CC_detections_thresh.PixelIdxList = pixelList;
CC_detections_thresh.NumObjects = length(pixelList);

dg = centroidMatch(CC_labels, CC_detections_thresh, zeros(length(pixelList), 1), 175);

pixelList(dg == 1) = [];

fprintf('Total Num of FP: %d\n', length(dg) - nnz(dg));


end
