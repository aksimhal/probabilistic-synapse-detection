load('tenToOne_thresholds'); 
load('cb_threshold.mat'); 
load('volumeStats.mat'); 

thresholdVec = 0.5:0.05:1;

%%
figure;
hold on;
for n=1:11
    plot(thresholdVec, numOfPSDSynapses(n, :) ./ cbvolume(n), 'LineWidth', 2);
end
plot([thresholdVec(1), thresholdVec(end)], [0.75, 0.75], 'LineWidth', 2, 'Color', 'r');
plot([thresholdVec(1), thresholdVec(end)], [1.05, 1.05], 'LineWidth', 2, 'Color', 'r');
xlabel('Threshold');
ylabel('Density: Number of Synapses per cubic micron');
title('Chessboard Excitatory Synapses');
legend(foldernames)
xlim([0.8, 1]);
set(gca,'fontsize',18)

%%

figure;
hold on;
for n=1:11
    plot(thresholdVec, numOfGabaSynapses(n, :) ./ cbvolume(n), 'LineWidth', 2);
end
plot([thresholdVec(1), thresholdVec(end)], [0.05, 0.05], 'LineWidth', 2, 'Color', 'r');
plot([thresholdVec(1), thresholdVec(end)], [0.15, 0.15], 'LineWidth', 2, 'Color', 'r');
xlabel('Threshold');
ylabel('Density: Number of Synapses per cubic micron');
title('Chessboard Inhibitory Synapses');
legend(foldernames)
xlim([0.8, 1]);
set(gca,'fontsize',18)

