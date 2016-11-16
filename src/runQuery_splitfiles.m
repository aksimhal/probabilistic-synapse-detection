%% Select proper format to run queries
function runQuery_splitfiles(query, baseStr, targetFileName, blobSize, ...
    search_win, edge_win)
% Load each channel
% Convolve
% Factor
% combineVolumes

% Parameters
% Threshold the base channel for computational simplicity
baseThresh = 0.8;

% minumum blob size
convWindow = ones(blobSize, 1);


% Split datasets % matfile
fileToLoad = strcat(baseStr, query.preIF{1});
probVolObj = matfile(fileToLoad);
volSize = size(probVolObj, 'probVol');

%volSize = [7936, 9888, 39];

[rRangeList, cRangeList] = quadSplit(volSize, edge_win);

resultVolLocations = cell(4, 1);

% Load presynaptic channels
presynapticVolumes = cell(length(query.preIF), 1);
postsynapticVolumes = cell(length(query.postIF), 1);
caseNum = 0;

cItr = 1;
rItr = 1;

for overallItr = 1:4
    fprintf('Starting iteration num. %d \n', overallItr); 
    
    if cItr == 3
        cItr = 1;
        rItr = 2;
    end
    
    
    for n=1:length(presynapticVolumes)
        
        % There are no presynaptic channels
        if strcmp(query.preIF{n}, 'NULL')
            caseNum = 3;
            break;
        end
        
        fileToLoad = strcat(baseStr, query.preIF{n});
        fprintf('loading %s ... \n', query.preIF{n});
        
        probVolObj = matfile(fileToLoad);
        probVol = probVolObj.probVol(rRangeList(1, rItr):rRangeList(2, rItr),...
            cRangeList(1, cItr):cRangeList(2, cItr), :);
        
        %load(fileToLoad); % load as probVol
        fprintf('loaded %s \n', query.preIF{n});
        
        % convolve volumes
        disp('Convolve volumes');
        convVol = convolveVolume(probVol, convWindow);
        disp('Convolved volumes');
        clear probVol;
        
        disp('Factor');
        if (query.preIF_z(n) == 2)
            factorVol = computeFactor_2(convVol);
            convVol = convVol .* factorVol;
        elseif(query.preIF_z(n) == 3)
            factorVol = computeFactor(convVol);
            convVol = convVol .* factorVol;
        end
        
        presynapticVolumes{n} = convVol;
        
        disp('volume preprocessed');
    end
    
    
    for n=1:length(postsynapticVolumes)
        
        % There are no postsynaptic channels
        if strcmp(query.postIF{n}, 'NULL')
            caseNum = 4;
            break;
        end
        
        fileToLoad = strcat(baseStr, query.postIF{n});
        fprintf('loading %s ... \n', query.postIF{n});
        probVolObj = matfile(fileToLoad);
        probVol = probVolObj.probVol(rRangeList(1, rItr):rRangeList(2, rItr),...
            cRangeList(1, cItr):cRangeList(2, cItr), :);
        
        %load(fileToLoad); % load as probVol
        fprintf('loaded %s \n', query.postIF{n});
        
        % convolve volumes
        disp('Convolve volumes');
        convVol = convolveVolume(probVol, convWindow);
        disp('Convolved volumes');
        clear probVol;
        
        disp('Calculate factor');
        
        if (query.postIF_z(n) == 2)
            factorVol = computeFactor_2(convVol);
            convVol = convVol .* factorVol;
        elseif(query.postIF_z(n) == 3)
            factorVol = computeFactor(convVol);
            convVol = convVol .* factorVol;
        end
        
        postsynapticVolumes{n} = convVol;
        disp('volume preprocessed');
        
    end
    
    if (caseNum == 0)
        if length(query.postIF) > 1
            caseNum = 2;
        else
            caseNum = 1;
        end
    end
    
    fprintf('about to start case %d \n', caseNum);
    
    switch caseNum
        
        case 1
            % CASE 1 -> 1-POST, N-PRE
            resultVol = combineVolumes2(postsynapticVolumes{1}, presynapticVolumes, ...
                baseThresh, edge_win, search_win);
            
        case 2
            % CASE 2 -> M-POST, N-PRE (M > 1)
            resultVol = combineVolumes_quadch(postsynapticVolumes{1}, presynapticVolumes, ...
                postsynapticVolumes(2:end), baseThresh, edge_win, search_win);
            
        case 3
            % CASE 3 -> N-POST
            resultVol = combineVolumes_oneside(postsynapticVolumes{1}, postsynapticVolumes(2:end), ...
                baseThresh, edge_win, search_win);
            
        case 4
            %CASE 4 -> N-PRE
            resultVol = combineVolumes_oneside(presynapticVolumes{1}, presynapticVolumes(2:end), ...
                baseThresh, edge_win, search_win);
    end
    
    fprintf('case %d completed \n', caseNum);
    
    portionTargetFileName = strcat(targetFileName(1:end-1), '_v', num2str(overallItr));
    save(portionTargetFileName, 'resultVol', '-v7.3');
    resultVolLocations{overallItr} = portionTargetFileName;
    disp(portionTargetFileName);
    
    cItr = cItr + 1; 
    
end

resultVol = combineResultVolumes(resultVolLocations, ...
    edge_win, volSize, rRangeList, cRangeList);

save(targetFileName, 'resultVol', '-v7.3');

end
