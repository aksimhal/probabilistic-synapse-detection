function data = removeLargeBlobs(data, maxSize, threshold)
% remove large blobs

for n=1:size(data, 3)
    % Hard code to PSD
    img = data(:, :, n);
    
    % Threshold image
    bwimg = img > threshold;
    
    % Keep objects above a certain size.
    bwimg = bwareaopen(bwimg, maxSize);
    
    % invert mask 
    bwimg = ~bwimg; 

    % remove large objects 
    data(:, :, n) = img .* bwimg; 
end

end
