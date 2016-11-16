function [pixelList] = combine_TP(inputStrs, gelatin)
% count number of false positive blobs

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

%filename = strcat('calculate_accuracy_', num2str(inputNumbers(1)));
load(inputStrs{1});

pixelList = CC_detections_thresh.PixelIdxList;
inds = find(tp_blobs ~= 0);
pixelList = pixelList(inds);
numOfBlobs = nnz(tp_blobs); 
indToRemove = []; 

if (length(inputStrs) == 1)
    return; 
end



for nFile=2:length(inputStrs)
    %filename = strcat('calculate_accuracy_', num2str(inputNumbers(nFile)));
    load(inputStrs{nFile});

    numOfBlobs = nnz(tp_blobs) + numOfBlobs; 
    
    newPixelList = CC_detections_thresh.PixelIdxList;
    inds = find(tp_blobs ~= 0 );
    newPixelList = newPixelList(inds);
    
    itr = 1;
    for n=1:length(newPixelList)
        for m=1:length(pixelList)
            
            overlap_inds = fastintersect(pixelList{m}, newPixelList{n});
            if ~isempty(overlap_inds)
                indToRemove(itr) = m;
                itr = itr + 1;
            end
        end
        
    end
    
    if (~isempty(indToRemove))
        pixelList(indToRemove) = []; 
    end
    indToRemove = []; 

    pixelList = [pixelList, newPixelList];
    
end


%fprintf('Total Num of original TP: %d\n', length(pixelList)); 


CC_detections_thresh.PixelIdxList = pixelList; 
CC_detections_thresh.NumObjects = length(pixelList); 

dg = centroidMatch(CC_labels, CC_detections_thresh, zeros(length(pixelList), 1), 175); 

pixelList(dg == 0) = []; 

fprintf('Total Num of TP: %d\n', nnz(dg)); 


end
