% raw data
n=20;
load('PSD95_488.mat')
figure;
img = testVol(:, :, 15);
h = imagesc(log(double(img)));
ylim([600 3100])
xlim([840 3100])
set(gca, 'XTick', [])
set(gca, 'YTick', [])
colormap('bone');
climits = caxis;
caxis([0, climits(2)])

colorbar('FontSize', 20); 
saveas(h, 'raw_bone.png');


% prob map
load('prob_PSD95_488.mat')
figure;
img = probVol(:, :, 15);
h = imagesc((img));
ylim([600 3100])
xlim([840 3100])
set(gca, 'XTick', [])
set(gca, 'YTick', [])
colormap('bone');
colorbar('FontSize', 20); 
climits = caxis;
caxis([0, climits(2)])
saveas(h, 'prob_bone.png');


% conv data
load('conv_PSD95_488.mat')
figure;
img = convVol(:, :, 15);
h = imagesc(img);
ylim([600 3100])
xlim([840 3100])
set(gca, 'XTick', [])
set(gca, 'YTick', [])
colormap('bone');
colorbar('FontSize', 20); 
climits = caxis;
caxis([0, climits(2)])
saveas(h, 'conv_bone.png');


figure;
h = imagesc(convVol(600:3100, 840:3100, 14));
colormap('bone');
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'conv14_bone.png');

figure;
h = imagesc(convVol(600:3100, 840:3100, 15));
colormap('bone');
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'conv15_bone.png');

figure;
h = imagesc(convVol(600:3100, 840:3100, 16));
colormap('bone');
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'conv16_bone.png');


% factor result
load('factor_psd.mat')
figure;
h = imagesc(psd_prob(:, :, 15));
ylim([600 3100])
xlim([840 3100])
colormap('bone');
set(gca, 'XTick', [])
set(gca, 'YTick', [])
colorbar;
saveas(h, 'factor_result_bone.png');


% factor result
figure;
h = imagesc(factorVol(:, :, 4));
ylim([600 3100])
xlim([840 3100])
colormap('bone');
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'factor_bone.png');


% result
load('psd_synapsin_vglut_full.mat')
imagesc(psd_synapsin_vglut(:, :, 15))
ylim([600 3100])
xlim([840 3100])
colorbar


% label data
load('labelVol.mat')
imagesc(labelVol.data(:, :, 15))
ylim([600 3100])
xlim([840 3100])
colorbar

%%
load('conv_PSD95_488.mat')
psdconv = convVol;
clear convVol
load('conv_Synapsin647.mat')
synapsinconv = convVol;
clear convVol
psdimg = psdconv(:, :, 15);

convImg14 = synapsinconv(:, :, 14);
convImg15 = synapsinconv(:, :, 15);
convImg16 = synapsinconv(:, :, 16);


%%
linethickness = 2; 
figure;
h = imagesc(psdimg); 
ylim([2095 2587]);
xlim([1377 1987]);
hold on; 

xpt = 1667;
ypt = 2316;
plot(xpt, ypt, '*'); 
colormap('bone');
colorbar;
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'psdWithPt.png');

figure;
h = imagesc(convImg14); 
ylim([2095 2587]);
xlim([1377 1987]);
stepsize = 84;
r_g_s = ypt - round(1.5*stepsize);
c_g_s = xpt - round(1.5 * stepsize);

for gridC = 1:4
    line([c_g_s, c_g_s], [r_g_s, r_g_s + 3 * stepsize], 'Color', 'm','LineWidth', linethickness);
    c_g_s = c_g_s + stepsize;
end
c_g_s = xpt - round(1.5 * stepsize);


for gridR = 1:4
    line([c_g_s, c_g_s + 3 * stepsize], [r_g_s, r_g_s], 'Color', 'm','LineWidth', linethickness);
    r_g_s = r_g_s + stepsize;
end
colormap('bone');
colorbar;
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'conv14grid.png');


figure;
h = imagesc(convImg15); 
ylim([2095 2587]);
xlim([1377 1987]);
stepsize = 84;
r_g_s = ypt - round(1.5*stepsize);
c_g_s = xpt - round(1.5 * stepsize);

for gridC = 1:4
    line([c_g_s, c_g_s], [r_g_s, r_g_s + 3 * stepsize], 'Color', 'm','LineWidth', linethickness);
    c_g_s = c_g_s + stepsize;
end
c_g_s = xpt - round(1.5 * stepsize);


for gridR = 1:4
    line([c_g_s, c_g_s + 3 * stepsize], [r_g_s, r_g_s], 'Color', 'm','LineWidth', linethickness);
    r_g_s = r_g_s + stepsize;
end
colormap('bone');
colorbar;
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'conv15grid.png');

figure;
h = imagesc(convImg16); 
ylim([2095 2587]);
xlim([1377 1987]);
stepsize = 84;
r_g_s = ypt - round(1.5*stepsize);
c_g_s = xpt - round(1.5 * stepsize);

for gridC = 1:4
    line([c_g_s, c_g_s], [r_g_s, r_g_s + 3 * stepsize], 'Color', 'm','LineWidth', linethickness);
    c_g_s = c_g_s + stepsize;
end
c_g_s = xpt - round(1.5 * stepsize);


for gridR = 1:4
    line([c_g_s, c_g_s + 3 * stepsize], [r_g_s, r_g_s], 'Color', 'm','LineWidth', linethickness);
    r_g_s = r_g_s + stepsize;
end
colormap('bone');
colorbar;
set(gca, 'XTick', [])
set(gca, 'YTick', [])
saveas(h, 'conv16grid.png');


%%
load('EM25K.mat')
emimg = testVol(:, :, 15);
load('PSD95_488.mat')
psdimg = testVol(:, :, 15);
load('Synapsin647.mat')
synapsinimg = testVol(:, :, 15);
clear testVol
psdimgBW = psdimg > 15; 
synapsinBW = synapsinimg > 30; 

B_synapsin = bwboundaries(synapsinBW);
B_psd = bwboundaries(psdimgBW);


%% 
green = cat(3, zeros(size(emimg), 'uint8'), ...
    255*ones(size(emimg), 'uint8'), ones(size(emimg), 'uint8'));
red = cat(3, 255*ones(size(emimg), 'uint8'), ...
    zeros(size(emimg), 'uint8'), ones(size(emimg), 'uint8'));



figure; 
h = imagesc(emimg); 
colormap(gray); 
hold on 
h1 = imagesc(red); 
set(h1, 'AlphaData', 1*psdimg); 

h2 = imagesc(green); 
set(h2, 'AlphaData', 1*synapsinimg); 

%9
% 25
for n=1:length(B_synapsin) 
    foo = B_synapsin{n}; 
    plot(foo(:, 2), foo(:, 1), 'Color', 'g', 'LineWidth',2); 
    %text(foo(1, 2), foo(1, 1), num2str(n)); 
end

for n=9%1:length(B_synapsin) 
    foo = B_psd{n}; 
    plot(foo(:, 2), foo(:, 1), 'Color', 'r', 'LineWidth',2); 
    %text(foo(1, 2), foo(1, 1), num2str(n)); 
end

xlim([1210, 1757]);
ylim([1394, 1902]);
%set(gca, 'XTick', [])
%set(gca, 'YTick', [])
saveas(h, 'emSynapse.png');

%%

xi = ([1481, 1493, 1706, 1694, 1481]); 
yi = ([1734, 1802, 1767, 1700, 1734]);

figure; 
hold on;

h1 = imagesc(log(double(psdimg))); 
colormap('bone');

plot(xi, yi, 'Color', 'b', 'LineWidth',2); 

xlim([1210, 1757]);
ylim([1394, 1902]);
set(gca,'Ydir','reverse')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
climits = caxis;
caxis([0, climits(2)])
colorbar('FontSize', 20); 

saveas(h1, 'synapsePSD.png');

%%

figure; 
h1 = imagesc(log(double(synapsinimg))); 
colormap('bone');
hold on;
plot(xi, yi, 'Color', 'b', 'LineWidth', 2); 

xlim([1210, 1757]);
ylim([1394, 1902]);
set(gca,'Ydir','reverse')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
climits = caxis; 
caxis([0, climits(2)])

colorbar('FontSize', 16);
saveas(h1, 'emSynapseSynapsin.png');

%% Final Prob Map Figure 

figure; 
imagesc(resultVol(:, :, 15));
ylim([600 3100])
xlim([840 3100])
set(gca, 'XTick', [])
set(gca, 'YTick', [])
colorbar; 
colormap('bone');
















