% Create Ramon Volume from data

data = zeros(4518, 6306, 27, 'uint8');
channelNames = {'Synapsin647', 'VGluT1_647', 'PSD95_488', ...
    'GABA488', 'GAD647', 'gephyrin594', 'GS594', 'NR1594', 'MBP488', 'EM25K'};

img_ranges = {[1, 4518], [1, 6306]};

for ch_ind = 1:length(channelNames)
    
    for slicenum = 31:1:57
        data(:, :, slicenum - 30) = loadSilaneChannel(channelNames{ch_ind}, slicenum, ...
            img_ranges);
    end
    
    testVol = RAMONVolume();
    testVol.setCutout(data);
    save(channelNames{ch_ind}, 'testVol');
    disp('Data Loaded');
    disp(channelNames{ch_ind});
end

%%
data = zeros(4518, 6306, 27, 'uint8');

for ind = 1:27
    data(:, :, ind) = imread('GoodPixels_silane.tif', ind);
end 
    testVol = RAMONVolume();
    testVol.setCutout(data);
    save('silaneMask', 'testVol');

    
%%
data = zeros(4518, 6306, 27, 'uint8');
   for slicenum = 1:27
        data(:, :, slicenum) = loadSilaneChannel('LabelsFULL', slicenum - 1, ...
            img_ranges);
    end
    labelVol = RAMONVolume();
    labelVol.setCutout(data);
    save('labelsVol', 'labelVol');
