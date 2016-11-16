%% C1 VS C2

% densityMat
close all; clear all;
% plot data
setNum = 3;

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51', 'Ex14R58'};
miceList = {'Ex2', 'Ex3', 'Ex6', 'Ex10', 'Ex12R75', 'Ex12R76', 'Ex13 (flipped)'};

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
        
        ifchannels = {'mPSD mSynapsin', 'PSD mSynapsin vGluT1', 'PSD mSynapsin vGluT2', ...
            'PSD mSynapsin GluR1', 'PSD mSynapsin GluR2', 'PSD mSynapsin NR2B', ...
            'Gephyrin mSynapsin GABAAR', 'Gephyrin mSynapsin vGAT', 'Gephyrin mSynapsin GAD', ...
            'Gephyrin Synapsin GABAAR', 'Gephyrin Synapsin vGAT', 'Gephyrin Synapsin GAD'};
end


for n=1:size(densityMat, 1)
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    hold on;
    title(ifchannels(n));
    
    
    
    for tItr = 1:11
        layer3pts(tItr) = squeeze(densityMat(n, tItr, 1, gabaThresholds(tItr)));
        layer4pts(tItr) = squeeze(densityMat(n, tItr, 2, gabaThresholds(tItr)));
        layer5pts(tItr) = squeeze(densityMat(n, tItr, 3, gabaThresholds(tItr)));
        layer3_2pts(tItr) = squeeze(densityMat(n, tItr, 4, gabaThresholds(tItr)));
        layer4_2pts(tItr) = squeeze(densityMat(n, tItr, 5, gabaThresholds(tItr)));
        layer5_2pts(tItr) = squeeze(densityMat(n, tItr, 6, gabaThresholds(tItr)));
    end
    

    trim = zeros(7, 1);
    untrimmed = zeros(7, 1);
    
    trim(1) = layer4pts(1); %Ex2
    trim(2) = layer4pts(3); %Ex3
    trim(3) = layer4pts(6); %Ex6
    trim(4) = layer4_2pts(8);  %Ex10
    trim(5) = layer4_2pts(9);  %Ex12R75
    trim(6) = layer4_2pts(10);  %Ex12R76
    trim(7) = layer4_2pts(11); %Ex13
    
    untrimmed(1) = layer4pts(2); %Ex2
    untrimmed(2) = layer4pts(4); %Ex3
    untrimmed(3) = layer4pts(7); %Ex6
    untrimmed(4) = layer4pts(8); %Ex10
    untrimmed(5) = layer4pts(9); %Ex12R75
    untrimmed(6) = layer4pts(10); %Ex12R76
    untrimmed(7) = layer4pts(11);  %Ex13
    
    
    for folderInd = 1:length(untrimmed)
        h = plot([trim(folderInd), untrimmed(folderInd)], '--');
        text(2.2, untrimmed(folderInd), miceList{folderInd});
    end
    
    percentDifference = (trim - untrimmed) ./ trim;
    mean(percentDifference)
    
    xlim([0, 3]);
    lengendStrs = cell(length(miceList), 1);
    for strItr = 1:length(miceList)
        miceStr = miceList{strItr};
        lengendStrs(strItr) = strcat(miceStr, {'   '}, num2str(percentDifference(strItr)), '%');
    end
    
    
    
    ylabel('puncta per cubic micron', 'FontSize', 14);
    h_legend = legend(lengendStrs);
    set(h_legend,'FontSize',14);
    set(h_legend, 'Location', 'eastoutside');
    
    set(gca,'XTick',1:2, 'XTickLabel',{'trim', 'untrimmed'}, 'FontSize',14)
    
    filename = strcat('B_', ifchannels{n}, '.png');
    saveas(h, filename);
    
    
end
