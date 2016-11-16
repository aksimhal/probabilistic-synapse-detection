%% gelatin synaptograms
addpath(genpath('/home/anish/Connectome/Synaptome/Synaptome-Duke/SynapseDetection/')); 

nm_px = 3.72; % nm/px
win = 126;

labelStrs = {'Label', 'Result', 'PSD95', 'Synapsin', 'VGluT1', 'NR1', 'EM'};
listOfMatFiles = {...
    '/data/anish/Synaptome/gelatin/gelatin_labelsVolBinary', ...
    '/data/anish/Synaptome/gelatin/results/resultVol_5', ...
    '/data/anish/Synaptome/gelatin/probVolumes/prob_PSDr',...
    '/data/anish/Synaptome/gelatin/probVolumes/prob_synapsin', ...
    '/data/anish/Synaptome/gelatin/probVolumes/prob_VGluT1', ...
    '/data/anish/Synaptome/gelatin/probVolumes/prob_NR1', ...
    '/data/anish/Synaptome/gelatin/EM_scaled'};

% Organize CC

load('/data/anish/Synaptome/gelatin/gelatinLabels');
CC_labels = CC;
load('/data/anish/Synaptome/gelatin/gelatin_results');


%% True Positive Labels
tpinds = find(truePositiveLabels == 1);
pxlist = CC_labels.PixelIdxList;
pxlist(~truePositiveLabels) = [];
cc_tp = CC_labels;
cc_tp.PixelIdxList = pxlist;

filenames = cell(length(pxlist), 1);
for n=1:length(pxlist)
    filenames{n} = strcat('tp-label-', num2str(tpinds(n)));
end

generateSynaptograms(cc_tp, listOfMatFiles, win, labelStrs, ...
    filenames, nm_px);

%% False Negative Labels
pxlist = CC_labels.PixelIdxList;
notmissed = logical(truePositiveLabels + edgeLabels);
fninds = find(~notmissed == 1);

pxlist(notmissed) = [];
cc_fp = CC_labels;
cc_fp.PixelIdxList = pxlist;


filenames = cell(length(pxlist), 1);
for n=1:length(pxlist)
    filenames{n} = strcat('fn-label-', num2str(fninds(n)));
end

generateSynaptograms(cc_fp, listOfMatFiles, win, labelStrs, ...
    filenames, nm_px)




%% Edge Labels
pxlist = CC_labels.PixelIdxList;
edge_inds = find(edgeLabels == 1);
pxlist(~edgeLabels) = [];

cc_edge = CC_labels;
cc_edge.PixelIdxList = pxlist;

filenames = cell(length(pxlist), 1);
for n=1:length(pxlist)
    filenames{n} = strcat('edge-label-', num2str(edge_inds(n)));
end
generateSynaptograms(cc_edge, listOfMatFiles, win, labelStrs, ...
    filenames, nm_px)


%% False Positive Blobs
cc_blobs = CC_labels;
cc_blobs.PixelIdxList = pixelList_FP;

filenames = cell(length(pixelList_FP), 1);
for n=1:length(pixelList_FP)
    filenames{n} = strcat('fp-blobs-', num2str(n));
end

generateSynaptograms(cc_blobs, listOfMatFiles, win, labelStrs, ...
    filenames, nm_px)
%% True Positive Blobs

cc_blobs.PixelIdxList = pixelList_TP;

filenames = cell(length(pixelList_TP), 1);
for n=1:length(pixelList_TP)
    filenames{n} = strcat('tp-blobs-', num2str(n));
end

generateSynaptograms(cc_blobs, listOfMatFiles, win, labelStrs, ...
    filenames, nm_px)












