%%
figure;
%xcrop = [2400, 2530];
%ycrop = [880, 1050];
xcrop = [2425, 2455];
ycrop = [930, 970];
    
imagesc(resultVol(:, :, 10))
xlim(xcrop)
ylim(ycrop)
colorbar
title('Output Probability Map');
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'fontsize', 20)
caxis([0, 1])
colormap(bone)



%%
figure;
imagesc(resultVol(:, :, 10) > 0.9)
xlim(xcrop)
ylim(ycrop)
colorbar
title('Thresholded Probability Map');
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'fontsize', 20)
caxis([0, 1])
colormap(flipud(gray));

%%
figure;
img = resultVol(:, :, 10);
imgvec = img(:);
 imgvec(imgvec < 0.055) = [] ;
h = histogram(imgvec);
h.Normalization = 'probability';
maxy = max(imgvec);
xlim([0, 1]);
title('Probability Map Histogram');
set(gca,'fontsize', 20)

%%

for n=9:11
    load('PSD25_2.mat')
    psdimg = rawVol(:, :, n);
    load('Synapsin1_3.mat')
    synapsinimg = rawVol(:, :, n);
    load('vGluT1_3.mat');
    vglut1img = rawVol(:, :, n);
    
    synapsinimg(synapsinimg > 6000) = 6000;
    psdimg(psdimg > 6000) = 6000;
    vglut1img(vglut1img > 6000) = 6000;
    
    %C = imfuse(psdimg, synapsinimg, 'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
    resultImg = resultVol(:, :, n) > 0.9;
    
    
    redimg = zeros(size(psdimg, 1), size(psdimg, 2), 3);
    greenimg = zeros(size(psdimg, 1), size(psdimg, 2), 3);
    blueimg = zeros(size(psdimg, 1), size(psdimg, 2), 3);
    redimg(:, :, 1) = ones(size(psdimg, 1), size(psdimg, 2));
    greenimg(:, :, 2) = ones(size(psdimg, 1), size(psdimg, 2));
    blueimg(:, :, 3) = ones(size(psdimg, 1), size(psdimg, 2));
    normpsdimg = psdimg ./ max(psdimg(:));
    normsynapsin = synapsinimg ./ max(synapsinimg(:));
    normvglut = vglut1img ./ max(vglut1img(:));
    
    figure;
    
    h1 = imagesc(redimg);
    hold on
    set(h1, 'AlphaData', normpsdimg);
    h2 = imagesc(greenimg);
    set(h2, 'AlphaData', normsynapsin);
    h3 = imagesc(blueimg);
    set(h3, 'AlphaData', normvglut);
    
    xcrop2 = [2425, 2455];
    ycrop2 = [930, 970];
    
    xlim(xcrop2)
    ylim(ycrop2)
    
    
    %resultImg = resultImg(ycrop(1):ycrop(2), xcrop(1):xcrop(2));
    
    %Ccrop = C(ycrop(1):ycrop(2), xcrop(1):xcrop(2), :);
    
    cc = bwconncomp(resultImg);
    
    stats = regionprops(cc, 'Centroid');
    %figure; imagesc(Ccrop)
    hold on;
%     for n = 1:length(stats)
%         centerPt = stats(n).Centroid;
%         plot(centerPt(1), centerPt(2), 'ko', 'MarkerSize', 15, 'LineWidth', 5);
%     end
    
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
    title('IF Data with Detections');
    %colorbar
    set(gca,'fontsize', 20)
    
end
