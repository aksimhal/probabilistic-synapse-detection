function edgeblobs = findEdgeElement(CC, pixellist, ...
    edge_win, zedge)

edgeblobs = zeros(length(pixellist), 1);
imagesize_labels = CC.ImageSize;


r_edge = imagesize_labels(1) - edge_win;
c_edge = imagesize_labels(2) - edge_win;
zend = imagesize_labels(3);


% Sort out edge blobs
for n=1:length(pixellist)
    
    [r, c, z] = ind2sub(CC.ImageSize, pixellist{n});
    
    % Determine if blob is on inner edge
    foo = r < edge_win;
    if (nnz(foo) > 0)
        edgeblobs(n) = 1;
    end
    
    foo = c < edge_win;
    if (nnz(foo) > 0)
        edgeblobs(n) = 1;
    end
    
    foo = z == zedge;
    if (nnz(foo) > 0)
        edgeblobs(n) = 1;
    end
    
    % Determine if blob is on outer edge
    foo = r > r_edge;
    if (nnz(foo) > 0)
        edgeblobs(n) = 1;
    end
    
    foo = c > c_edge;
    if (nnz(foo) > 0)
        edgeblobs(n) = 1;
    end
    
    foo = z == zend;
    if (nnz(foo) > 0)
        edgeblobs(n) = 1;
    end
    
    
end


end
