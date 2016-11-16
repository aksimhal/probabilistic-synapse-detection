function thresholdCAT_Volumes(silane, gaba)
addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 


if silane
    label_win = 200;
else
    label_win = 134;
end


smallBlobWindow = 30;


if(~gaba)
    for trialNum = 1:7
        for threshold = 0.5:0.05:1
            calculate_accuracy(silane, gaba, threshold, smallBlobWindow, label_win, ...
                trialNum);
        end
    end
    
else
    for trialNum = 1:12
        for threshold = 0.5:0.05:1
            calculate_accuracy(silane, gaba, threshold, smallBlobWindow, label_win, ...
                trialNum);
        end
    end
end







