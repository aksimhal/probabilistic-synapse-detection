function blobsWithLabelsIDs = findUniqueLabels(blobsWithLabels)


blobsWithLabelsIDs = zeros(length(blobsWithLabels), 1); 

nID = 1; 
for n=1:length(blobsWithLabels)
    if (isempty(blobsWithLabels{n}))
        continue; 
    end
    
    foo = blobsWithLabels{n}; 
    for m=1:length(foo) 
        blobsWithLabelsIDs(nID) = foo(m); 
        nID = nID + 1; 
    end
end
blobsWithLabelsIDs = unique(blobsWithLabelsIDs); 



end
