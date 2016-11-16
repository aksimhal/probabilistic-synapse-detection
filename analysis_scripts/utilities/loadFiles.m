baseStr = '/Users/anish/Documents/Connectome/data/Ex10R55_YFP1/';




filename = sprintf('YFP-1-S%03d.tif', 1);
img = imread(strcat(baseStr, filename));
disp(filename);
listoffiles = dir(strcat(baseStr, '*.tif'));
rawVolumes = zeros(size(img, 1), size(img, 2), length(listoffiles));

for n=0:length(listoffiles)-1
    filename = sprintf('YFP-1-S%03d.tif', n);
    disp(filename);
    img = imread(strcat(baseStr, filename));
    rawVolumes(:, :, n+1) = img;
    
end


targetFilepath = strcat(baseStr, 'YFP-1');
save(targetFilepath, 'rawVolumes', '-v7.3');
disp('File Saved');


