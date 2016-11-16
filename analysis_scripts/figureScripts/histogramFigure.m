%load('PSD95_488.mat')
alpha = 2; 
slice = double(testVol(:, :, 10)); 
tau = mean(slice(:)) + alpha*std(slice(:)); 

bgslice = slice; 
bgslice(bgslice > tau) = []; 

data = normrnd(mean(slice(:)), std(slice(:)), [10000, 1]); 
bgdata = normrnd(mean(bgslice), std(bgslice), [10000, 1]); 

% h = histogram(data); 
% h.BinWidth = 1; 
% h.Normalization = 'probability';

figure;
hold on; 

h_bg = histogram(bgdata); 
h_bg.BinWidth = 1; 
h_bg.Normalization = 'probability';


h_orig = histogram(slice(:)); 
h_orig.BinWidth = 1; 
h_orig.Normalization = 'probability'; 

plot([tau, tau], ylim); 
xlim([0, 50])
legend('Background Model', 'Original Data', 'Tau')