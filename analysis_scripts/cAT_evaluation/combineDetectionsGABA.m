function [detectedGABA, edgeandfriends, detectedOther, numMissed, missedGABA] = combineDetectionsGABA(inputStrs, gelatin)


if (gelatin)
    psd_labels = zeros(1457, 1);
    
else
    psd_labels = zeros(237, 1);
end


for n=1:length(inputStrs)
    load(inputStrs{n});
    psd_labels = isLabelGood_thresh + psd_labels;
end


detectedLabels = psd_labels;

if (gelatin)
    load('gelatin_isedge');
    load('gelatin_isgaba');
else
    load('isedge');
    load('isgaba');
end

edgeandfriends = isedge(:);

nogephyrin = [146, 246, 314, 382, 391, 477, 545, 580, 603, 657, 658, 692,...
    862, 908, 956, 1111, 1124, 1231];
addededges = 676;

edgeandfriends(nogephyrin) = 1;
edgeandfriends(addededges) = 1;

% These are all the labels listed as being on the edge
edgeandfriends = edgeandfriends > 0;
detectedLabels = detectedLabels > 0;

% These are all the labels marked as gaba and all the detected labels
gameplayers = isgaba(:) + detectedLabels(:);

% All the labels marked gaba that were detected
gabadetections = find(gameplayers == 2);
detectedGABA = zeros(size(psd_labels));
detectedGABA(gabadetections) = 1;

%All the other labels that were detected
detectedOther = detectedLabels;
detectedOther(gabadetections) = 0;

% All the gaba labels that are on the edge
gabaedge = edgeandfriends(:) + isgaba(:);
gabaedge = find(gabaedge == 2);

% gaba labels that are not on the edge or detected
missedGABA = isgaba(:);
missedGABA(gabadetections) = 0;
missedGABA(gabaedge) = 0;


fprintf('Num of GABA Synapses Detected: %d\n', length(gabadetections));
fprintf('Number of Synapses Unclassified: %d\n', nnz(missedGABA));
numMissed = nnz(missedGABA);

fprintf('Number of other synapses classified: %d\n', nnz(detectedLabels) - length(gabadetections));
fprintf('\n');



end