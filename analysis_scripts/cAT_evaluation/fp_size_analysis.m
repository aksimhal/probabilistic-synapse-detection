%% FP Size Analysis

pixellist_detections_thresh = CC_detections_thresh.PixelIdxList;

FP_BlobSize = zeros(length(pixellist_detections_thresh), 3);
TP_BlobSize = zeros(length(pixellist_detections_thresh), 3);

for n=1:length(pixellist_detections_thresh)
    
    if (fp_blobs(n) == 1)
        [r, c, z] = ind2sub(CC_detections_thresh.ImageSize, pixellist_detections_thresh{n});
        FP_BlobSize(n, 1) = max(r) - min(r) + 1;
        FP_BlobSize(n, 2) = max(c) - min(c) + 1;
        FP_BlobSize(n, 3) = max(z) - min(z) + 1;
        
    elseif (tp_blobs(n) ~= 0)
        [r, c, z] = ind2sub(CC_detections_thresh.ImageSize, pixellist_detections_thresh{n});        
        TP_BlobSize(n, 1) = max(r) - min(r) + 1;
        TP_BlobSize(n, 2) = max(c) - min(c) + 1;
        TP_BlobSize(n, 3) = max(z) - min(z) + 1;
    end
    
end


fp_z = FP_BlobSize(:, 3); 
fp_z(fp_z == 0) = []; 
tp_z = TP_BlobSize(:, 3); 
tp_z(tp_z == 0) = []; 

figure; 
histogram(tp_z)
hold on
histogram(fp_z)
legend('true positive', 'false positive')
xlabel('Number of Pixels');
ylabel('Number of detections');
title('z'); 


fp_c = FP_BlobSize(:, 2); 
fp_c(fp_c == 0) = []; 
tp_c = TP_BlobSize(:, 2); 
tp_c(tp_c == 0) = []; 

figure; 
histogram(tp_c)
hold on
histogram(fp_c)
legend('true positive', 'false positive')
xlabel('Number of Pixels');
ylabel('Number of detections');
title('c'); 


fp_r = FP_BlobSize(:, 1); 
fp_r(fp_r == 0) = []; 
tp_r = TP_BlobSize(:, 1); 
tp_r(tp_r == 0) = []; 

figure; 
histogram(tp_r)
hold on
histogram(fp_r)
legend('true positive', 'false positive')
xlabel('Number of Pixels');
ylabel('Number of detections');
title('r'); 

% volume 
fp_area = zeros(size(fp_c)); 
tp_area = zeros(size(tp_c)); 
for n=1:length(fp_c) 
    fp_area(n) = fp_c(n) * fp_r(n) * fp_z(n); 
end

for n=1:length(tp_c) 
    tp_area(n) = tp_c(n) * tp_r(n) * tp_z(n); 
end

figure; 
histogram(tp_area)
hold on
histogram(fp_area)
legend('true positive', 'false positive')
xlabel('Number of Pixels');
ylabel('Number of detections');
title('volume'); 








