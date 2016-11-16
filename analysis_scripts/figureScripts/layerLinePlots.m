%% LAYER 4 VS (probable) LAYER 5

% densityMat
close all; clear all;
% plot data
setNum = 3;


miceList = {'Ex2', 'Ex3', 'Ex6', 'Ex10', 'Ex12R75', 'Ex12R76', 'Ex13'};
foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51', 'Ex14R58'};

switch setNum
    case 1
        load('densityMat.mat')
        densityMat = densityMat(:, :, :, 5);
        ifchannels = {'PSD', 'Synapsin', 'vGluT1', 'vGluT2', 'GluR1', 'GluR2', ...
            'NR2B', 'Gephyrin', 'GABAARa', 'vGAT', 'GAD'};
        
    case 2
        load('densityMatSynapses.mat')
        ifchannels = {'excitatory', 'inhibitory'};
        
    case 3
        load('indiDenDetections.mat')
        
        gabaThresholds = [9,9,9,9,9,9,9,9,10,10,10];
        gabaThresholds = gabaThresholds - 6;
        
        %densityMat = densityMat(:, :, :, 3);
        ifchannels = {'mPSD mSynapsin', 'PSD mSynapsin vGluT1', 'PSD mSynapsin vGluT2', ...
            'PSD mSynapsin GluR1', 'PSD mSynapsin GluR2', 'PSD mSynapsin NR2B', ...
            'Gephyrin mSynapsin GABAAR', 'Gephyrin mSynapsin vGAT', 'Gephyrin mSynapsin GAD', ...
            'Gephyrin mSynapsin mGABAAR', 'Gephyrin mSynapsin mvGAT', 'Gephyrin mSynapsin mGAD'};
end

querystrs = {'Inhibitory Query 1', 'Inhibitory Query 2', 'Inhibitory Query 3'}; 

for n=3%7:9%size(densityMat, 1)
    %figure('units','normalized','outerposition',[0 0 1 1]);
    figure; 
    hold on;
    %title(querystrs(n-6));
    title('Excitatory Query 3'); 
    
    for tItr = 1:11
        layer3pts(tItr) = squeeze(densityMat(n, tItr, 1, gabaThresholds(tItr)));
        
        
        layer4pts(tItr) = squeeze(densityMat(n, tItr, 2, gabaThresholds(tItr)));
        layer5pts(tItr) = squeeze(densityMat(n, tItr, 3, gabaThresholds(tItr)));
        layer3_2pts(tItr) = squeeze(densityMat(n, tItr, 4, gabaThresholds(tItr)));
        layer4_2pts(tItr) = squeeze(densityMat(n, tItr, 5, gabaThresholds(tItr)));
        layer5_2pts(tItr) = squeeze(densityMat(n, tItr, 6, gabaThresholds(tItr)));
    end
    avgL4 = zeros(7, 1);
    avgL5 = zeros(7, 1);
    
    avgL4(1) = mean([layer4pts(1), layer4pts(2)]); %Ex2
    avgL4(2) = mean([layer4pts(3), layer4pts(4)]); %Ex3
    avgL4(3) = mean([layer4pts(6), layer4pts(7)]); %Ex6
    avgL4(4) = mean([layer4pts(8), layer4_2pts(8)]); %Ex10
    avgL4(5) = mean([layer4pts(9), layer4_2pts(9)]); %Ex12R75
    avgL4(6) = mean([layer4pts(10), layer4_2pts(10)]); %Ex12R76
    avgL4(7) = mean([layer4pts(11), layer4_2pts(11)]); %Ex13
    
    avgL5(1) = mean([layer5pts(1), layer5pts(2)]); %Ex2
    avgL5(2) = mean([layer5pts(3), layer5pts(4)]); %Ex3
    avgL5(3) = mean([layer5pts(6), layer5pts(7)]); %Ex6
    avgL5(4) = mean([layer5pts(8), layer5_2pts(8)]); %Ex10
    avgL5(5) = mean([layer5pts(9), layer5_2pts(9)]); %Ex12R75
    avgL5(6) = mean([layer5pts(10), layer5_2pts(10)]); %Ex12R76
    avgL5(7) = mean([layer5pts(11), layer5_2pts(11)]); %Ex13
    
    percentDifference = (avgL4 - avgL5) ./ avgL4;
    disp(mean(percentDifference));
    
    for folderInd = 1:length(avgL5)
        h = plot([avgL4(folderInd), avgL5(folderInd)], '--', 'LineWidth', 2);
        %text(2.2, avgL5(folderInd), miceList{folderInd}, 'FontSize', 14);
    end
    
    
    xlim([0.8, 2.2]);
    lengendStrs = cell(length(miceList), 1);
    for strItr = 1:length(miceList)
        miceStr = miceList{strItr};
        lengendStrs(strItr) = strcat(miceStr, {'   '}, num2str(percentDifference(strItr)), '%');
        
    end
    
    ylabel('Synapses / micron^3', 'FontSize', 14);
    %h_legend = legend(lengendStrs);
        h_legend = legend(miceList);

    set(h_legend,'FontSize',14);
    %set(h_legend, 'Location', 'eastoutside');
    
    set(gca,'XTick',1:2, 'XTickLabel',{'L4', 'L5'}, 'FontSize',14)
    set(gca,'fontsize', 18)

    filename = strcat('L_', ifchannels{n}, '.png');
    %saveas(h, filename);
    
    
end
