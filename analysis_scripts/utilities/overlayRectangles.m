%% Plot Rectangles
% g - TP
% r - FN
% m - other boxes

% load('silaneMask');
% mask = testVol.data(500:3000, 500:5000, :);
% mask = mask ./ 255;

data = psd_synapsin_vglut;% .* double(mask); 

data = data > threshold;

win = 10;

% Loop over each slice and over each blob
for zInd=1:size(data, 3)
    figure;
    h = imagesc(data(:, :, zInd)); title(int2str(zInd));
    hold on;
    
    for n=1:length(pixellist_detections_thresh)
        
        
        [r, c, z] = ind2sub(CC_detections_thresh.ImageSize, pixellist_detections_thresh{n});
        if  (~isempty(find(z==zInd, 1)))
            
            [minr, maxr, minc, maxc] = getWindow(r, c, win, imagesize_labels);
            
            % Green True Detection
            if (tp_blobs(n) ~= 0)
                rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'g')
                text(minc, minr, num2str(n), 'FontSize', 12, 'Color', 'g');
                
            elseif (fp_blobs(n) ~= 0)
                % Red Missed Detection
                rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'r')
                text(minc, minr, num2str(n), 'FontSize', 12, 'Color', 'r');
                
            else
                % edge
                rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'c')
                text(minc, minr, num2str(n), 'FontSize', 12, 'Color', 'c');
                
            end
        end
    end
    
    for n=1:length(FN_synapseIDs)
        
        [r, c, z] = ind2sub(CC_detections_thresh.ImageSize, pixellist_labels{FN_synapseIDs(n)});
        
        if  (~isempty(find(z==zInd, 1)))
            
            [minr, maxr, minc, maxc] = getWindow(r, c, win, imagesize_labels);
            rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'y')
            text(minc, minr, num2str(FN_synapseIDs(n)), 'FontSize', 12, 'Color', 'y');
            
        end
    end
    
    filename = strcat('acc_slice', num2str(zInd), '.png');
    saveas(h, filename);
    close all;
end
