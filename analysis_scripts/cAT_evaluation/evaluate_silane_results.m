% Evaluate silane detection results 
% Adapted from "thresholdCAT_Volumes.m 

addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 

label_win = 200;    
smallBlobWindow = 30; %removes upsampling artifacts
silane = true; 
gaba = false; 

for trialNum = 1:7
    for threshold = 0.55
        % Change filepaths in this file 
        calculate_accuracy(silane, gaba, threshold, smallBlobWindow, label_win, ...
            trialNum);
    end
end

% This file loads the output of 'calculate_accuracy'
aggregateDetections(false)




