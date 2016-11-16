function matchedBlobs = findOverlap(setA_labels, pixellist_setA, CC_setA, ...
    setB_labels, pixellist_setB, label_win)

% Iterate over each element of set A to see if it matches any element in
% set B


matchedBlobs = cell(size(setA_labels));

% Determine which boxes contain PSD signal

% Loop over set A
for n=1:length(pixellist_setA)
    
    if setA_labels(n) == 1
        continue;
    end
    if (isempty(pixellist_setA{n})) %for when n=18
        continue; 
    end
    
    
    % Loop over blobs
    
    [r, c, z] = ind2sub(CC_setA.ImageSize, pixellist_setA{n});
    [minr, maxr, minc, maxc] = getWindow(r, c, label_win, CC_setA.ImageSize);
    
    box = ones(length(minr:maxr), length(minc:maxc), length(min(z):max(z)));
    
    CC = bwconncomp(box > 0, 26);
    labelPixellist = CC.PixelIdxList{1};
    [r_expanded, c_expanded, z_expanded] = ind2sub(CC.ImageSize, labelPixellist);

    
    if ((max(r_expanded) + minr) > CC_setA.ImageSize(1)) 
        minr = CC_setA.ImageSize(1) - max(r_expanded) - 1; 
    end
    
    if ((max(c_expanded) + minc) > CC_setA.ImageSize(2))
        minc = CC_setA.ImageSize(2) - max(c_expanded) - 1;
    end
    
        
    r_expanded = r_expanded + minr;
    c_expanded = c_expanded + minc;
    z_expanded = z_expanded + min(z);
    
    labelPixellist = sub2ind(CC_setA.ImageSize, r_expanded, c_expanded, z_expanded);
    
    
    % Loop over blobs
    mb_ind = 1; 
    for m=1:length(pixellist_setB)
%         if setB_labels(m) == 1
%             continue;
%         end
        overlap_inds = fastintersect(pixellist_setB{m}, labelPixellist);
        
        if (~isempty(overlap_inds))
            foo = matchedBlobs{n}; 
            foo(mb_ind) = m; 
            mb_ind = mb_ind + 1; 
            matchedBlobs{n} = foo; 
            
        end
        
    end
end



end


