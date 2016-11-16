% Create Ramon Volume from data

dataVol = zeros(7936, 9888, 39, 'uint8');
channelNames = {'synapsin', 'VGluT1', 'PSDr', 'NR1', 'EM', 'GABA',...
    'GAD2', 'gephyrin', 'VGAT', 'bIIItubulin'};

img_ranges = {[1, 7936], [1, 9888]};

for ch_ind = 6:10
    
    for slicenum = 1:39
        dataVol(:, :, slicenum) = loadChannel(channelNames{ch_ind}, slicenum - 1, ...
            img_ranges);
    end
    
    save(channelNames{ch_ind}, 'dataVol', '-v7.3');
    disp('Data Loaded');
    disp(channelNames{ch_ind});
end

return
%%
data = zeros(7936, 9888, 39, 'uint8');

for ind = 1:39
    data(:, :, ind) = imread('/Volumes/Lightning/fcollman/dataset2_aligned/goodPixels_v2.tif', ind);
end

save('gelatinMask', 'data', '-v7.3');


%%
labelVol = zeros(7936, 9888, 39, 'uint8');
for slicenum = 1:39
    labelVol(:, :, slicenum) = loadChannel('LabelsFULL', slicenum - 1, ...
        img_ranges);
end


save('gelatin_labelsVol', 'labelVol', '-v7.3');
