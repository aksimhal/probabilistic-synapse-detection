function volume = getVolume(data)

se = strel('disk',17);
img = sum(data, 3);
img = img > 0;
bw = imclose(img, se);
[r, c] = find(bw == 1);
DT = delaunayTriangulation(c, r);

if ~isempty(DT.Points)
    
    [k, v] = convexHull(DT);
    volume = v * 0.1*0.1*0.07 * size(data, 3);
    
else
    volume = 0;
end


end
