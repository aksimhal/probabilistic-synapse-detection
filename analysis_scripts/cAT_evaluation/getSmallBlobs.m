function edgelist = getSmallBlobs(CC, edgelist, threshold)

%smallblob = zeros(size(edgelist));
%threshold = 35;
for n=1:length(CC.PixelIdxList)
    
    if (edgelist(n) == 1)
        continue;
    end
    
    [r, c, ~] = ind2sub(CC.ImageSize, CC.PixelIdxList{n});
    if ((max(r) - min(r)) < threshold)
        edgelist(n) = 1;
    elseif ((max(c) - min(c)) < threshold)
        edgelist(n) = 1;
    end
    
    
end
