% Histogram Figures 

load('PSD95_488.mat')
testVol = testVol(:); 
figure; 
h = histogram(testVol);
h.Normalization = 'cdf';
h.BinWidth = 1;
xlim([0, 256]); 

xlabel('Intensity Values','FontSize', 14); 
ylabel('Cumulative Frequency (%)', 'FontSize', 14); 
title('PSD-95 Cumulative Histogram', 'FontSize', 14); 

hold on;
plot([10, 10], [0, 1], 'LineWidth', 2, 'Color', 'r')
set(gca,'fontsize', 20)

load('gephyrin594.mat'); 
testVol = testVol(:); 
figure; 
h = histogram(testVol);
h.Normalization = 'cdf';
h.BinWidth = 1;
xlim([0, 256]); 
xlabel('Intensity Values','FontSize', 14); 
ylabel('Cumulative Frequency (%)', 'FontSize', 14); 
title('Gephyrin Cumulative Histogram', 'FontSize', 14); 

hold on;
plot([15, 15], [0, 1], 'LineWidth', 2, 'Color', 'r')
set(gca,'fontsize', 20)


