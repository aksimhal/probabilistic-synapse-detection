% Extract data needed to create threshold vs density plots 

foldernames = {'Ex2R18C1', 'Ex2R18C2', ...
    'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', ...
    'Ex6R15C1', 'Ex6R15C2', ...
    'Ex10R55', 'Ex12R75', 'Ex12R76','Ex13R51'};

basestr = '/data/anish/Synaptome/Chessboard/results/';
filebase = 'resultVol_';

thresholdVec = 0.5:0.05:1;

numOfGabaSynapses = zeros(12, length(thresholdVec));
numOfPSDSynapses = zeros(12, length(thresholdVec));

%INHIBITORY SYNAPSES
disp('INHIBITORY SYNAPSES'); 

for folderind = 1:length(foldernames)
    disp(foldernames{folderind});
    
    thresholdItr = 1;
    
    for threshold = 0.5:0.05:1
        disp(threshold);
        
        load(strcat(basestr, foldernames{folderind}, filesep, filebase, num2str(7)));
        output = resultVol > threshold;
        
        for n = 8:12
            load(strcat(basestr, foldernames{folderind}, filesep, filebase, num2str(n)));
            foo = resultVol > threshold;
            output = output + foo;
        end
        
        cc = bwconncomp(output > 0, 26);
        
        numOfGabaSynapses(folderind, thresholdItr) =  cc.NumObjects;
        thresholdItr = thresholdItr + 1;
    end
    
    
end

%EXCITATORY SYNAPSES 
disp('EXCITATORY SYNAPSES'); 

for folderind = 1:length(foldernames)
    disp(foldernames{folderind});
    thresholdItr = 1;
    
    for threshold = 0.5:0.05:1
        disp(threshold);
        
        load(strcat(basestr, foldernames{folderind}, filesep, filebase, num2str(1)));
        output = resultVol > threshold;
        
        for n = 2:6
            load(strcat(basestr, foldernames{folderind}, filesep, filebase, num2str(n)));
            foo = resultVol > threshold;
            output = output + foo;
        end
        
        cc = bwconncomp(output > 0, 26);
        
        numOfPSDSynapses(folderind, thresholdItr) =  cc.NumObjects;
        thresholdItr = thresholdItr + 1;
        
    end
    
end

save('cb_threshold', 'numOfPSDSynapses', 'numOfGabaSynapses');

emailAnish('cb_threshold');
