%% Plot Rectangles
% g - TP
% r - FN
% m - other boxes
if (galicia) 
    load('/data/anish/Synaptome/EM25K.mat');
    data = testVol.data; %(500:3000, 500:5000, :);

    load('/data/anish/Synaptome/silaneMask.mat');
    mask = testVol.data; %(500:3000, 500:5000, :);
    mask = mask ./ 255;

else 
    
load('EM25K')
data = testVol.data; %(500:3000, 500:5000, :);
load('silaneMask');
mask = testVol.data; %(500:3000, 500:5000, :);
mask = mask ./ 255;

end

data = data .* mask;

win = 10;

% Loop over each slice and over each blob
for zInd=1:size(data, 3)
    figure;
    h = imagesc(data(:, :, zInd)); title(int2str(zInd));
    colormap('gray');
    
    hold on;
    
    for n=1:length(pixellist_detections_thresh)
        
        
        [r, c, z] = ind2sub(CC_detections_thresh.ImageSize, pixellist_detections_thresh{n});
        if  (~isempty(find(z==zInd, 1)))
            
            [minr, maxr, minc, maxc] = getWindow(r, c, win, imagesize_labels);
            
            % Green True Detection
            if (tp_blobs(n) ~= 0)
                rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'g')
                text(minc, minr, num2str(n), 'FontSize', 14, 'Color', 'g');
                
            elseif (fp_blobs(n) ~= 0)
                % Red Incorrect Detection
                rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'r')
                text(minc, minr, num2str(n), 'FontSize', 14, 'Color', 'r');
                
            else
                % Detection on Edge
                rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'c')
                text(minc, minr, num2str(n), 'FontSize', 14, 'Color', 'c');
                
            end
        end
    end
    
    for n=1:length(FN_synapseIDs)
        
        [r, c, z] = ind2sub(CC_detections_thresh.ImageSize, pixellist_labels{FN_synapseIDs(n)});
        
        if  (~isempty(find(z==zInd, 1)))
            
            [minr, maxr, minc, maxc] = getWindow(r, c, win+10, imagesize_labels);
            rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'y', 'LineWidth', 3)
            text(maxc, minr, num2str(FN_synapseIDs(n)), 'FontSize', 14, 'Color', 'y');
            
        end
    end
    
    for n=1:length(CC_labels.PixelIdxList)
        
        [r, c, z] = ind2sub(CC_labels.ImageSize, CC_labels.PixelIdxList{n});
        if  (~isempty(find(z==zInd, 1)))
            [minr, maxr, minc, maxc] = getWindow(r, c, win, imagesize_labels);
            rectangle('Position', [minc, minr, maxc-minc, maxr-minr], 'EdgeColor', 'b')
            text(minc, minr, num2str(n), 'FontSize', 14, 'Color', 'b');
        end
    end
    
    
    
    filename = strcat('em_slice', num2str(zInd), '.fig');
    savefig(filename);
    close all;
end
