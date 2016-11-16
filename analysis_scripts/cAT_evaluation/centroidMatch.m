function detectionGood = centroidMatch(CC_detections_thresh, CC_labels, edgelabels, win)

stats_detections = regionprops(CC_detections_thresh, 'Centroid'); 
stats_labels = regionprops(CC_labels, 'Centroid'); 
detectionGood = zeros(length(stats_labels), 1); 
spacing = 50; 

for n=1:length(stats_labels) 
    for m=1:length(stats_detections) 
        if (edgelabels(n) ~= 0) 
            continue; 
        end 
        
        pt1 = stats_detections(m).Centroid;
        pt1(3) = pt1(3) * spacing; 
        pt2 = stats_labels(n).Centroid;
        pt2(3) = pt2(3) * spacing;
        if (pdist([pt1; pt2]) < win)
            detectionGood(n) = 1; 
        end
        
    end
end

