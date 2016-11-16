function data = getProbMap(data, mask) 
    % ALPHA == 2 
    % Create Foreground Probablities
    data = double(data); 
    
    for z=1:size(data, 3)
        % Mask Image
        img = data(:, :, z);
        imgvec = img(:);
        maskSlice = mask(:, :, z);
        maskvec = maskSlice(:);
        imgvec(maskvec == 0) = [];
        
        % Calculate foreground probabilities
        %imgvec(imgvec < (mean(imgvec) + alpha*std(double(imgvec)))) = [] ;
        probImg = normcdf(double(img), mean(imgvec), std(double(imgvec)));
        
        data(:, :, z) = probImg;
        
    end
    
end
