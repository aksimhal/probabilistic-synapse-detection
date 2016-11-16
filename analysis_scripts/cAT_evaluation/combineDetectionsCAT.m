function [psdandfriends, edgeandfriends, inds] = combineDetectionsCAT(inputStrs, gelatin)


if (gelatin)
    psd_labels = zeros(1457, 1);

else
    psd_labels = zeros(237, 1);
end


for n=1:length(inputStrs)
    %filename = strcat('calculate_accuracy_', num2str(inputStrs(n)));
    load(inputStrs{n});
    %dg = centroidMatch(CC_detections_thresh, CC_labels, edgelabels, 175); 
    psd_labels = isLabelGood_thresh + psd_labels;
    %psd_labels = dg + psd_labels;
end


psdandfriends = psd_labels;
galicia = false;

if(galicia)
    load('/data/anish/Synaptome/gelatin/gelatin_isedge');
    load('/data/anish/Synaptome/gelatin/gelatin_isgaba');
else
    if (gelatin)
        load('gelatin_isedge');
        load('gelatin_isgaba');
    else
        load('silane_isedge');
        load('silane_isgaba');
    end
    
end

if (gelatin)
    addedEdges = [106, 107, 108, 128, 141, 144, 158, 187, 188, 189, 190, 216, ...
        250, 251, 252, 285, 296, 317, 428, 445, 446, 482, 488, 493, 533, 539, 544, ...
        547, 560, 561, 585, 590, 591, 599, 607, 610, 611, 612, 614, 629, 630, 645, ...
        646, 647, 648, 649, 650, 651, 652, 654, 685, 701, 702, 707, 710, 711, 741,...
        750, 766, 771, 784, 795, 800, 807, 847, 864, 873, 874, 893, 903, 914, 929, ...
        931, 932, 933, 960, 961, 982, 1012, 1014, 1032, 1055, 1070, 1081, 1097, ...
        1123, 1149, 1173, 1197, 1198, 1199, 1210, 1214, 1215, 1217, 1218, 1233,...
        1243, 1244, 1245, 1245, 1247, 1319];
else
    addedEdges = [30, 139, 141, 161, 168, 181, 212, 234];
end


edgeandfriends = isgaba(:) + isedge(:) + edgelabels(:);
edgeandfriends(addedEdges) = 1;
edgeandfriends = edgeandfriends > 0;

gameplayers = edgeandfriends + psdandfriends;


inds = find(gameplayers == 0);

fprintf('Total Num of Synapses Detected: %d\n', nnz(psdandfriends));
fprintf('Number of Synapses Unclassified: %d\n', length(gameplayers) - nnz(gameplayers));
fprintf('\n');

psdandfriends = psdandfriends > 0;
%save('psdandfriends', 'psdandfriends');

end