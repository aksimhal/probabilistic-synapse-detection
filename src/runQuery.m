%% Select proper format to run queries
function runQuery(query, baseStr, outputfilename, maskFlag, blobSize, ...
    search_win, edge_win)
% Load each channel
% Convolve
% Factor
% combineVolumes

% Parameters
% Threshold the base channel for computational simplicity
baseThresh = 0.5;

% minumum blob size
convWindow = ones(blobSize, 1);


% Load presynaptic channels
presynapticVolumes = cell(length(query.preIF), 1);
postsynapticVolumes = cell(length(query.postIF), 1);
caseNum = 0;

for n=1:length(presynapticVolumes)
    
    % There are no presynaptic channels
    if strcmp(query.preIF{n}, 'NULL')
        caseNum = 3;
        break;
    end
    
    fileToLoad = strcat(baseStr, query.preIF{n});
    fprintf('loading %s ... \n', query.preIF{n});
    load(fileToLoad); % load as rawVol
    fprintf('loaded %s \n', query.preIF{n});
    
    %load mask
    if maskFlag ~= -1
        load(maskFlag);
    else 
        mask = -1;
    end

    % convert to prob space
    probVol = getProbMap(rawVol, mask);
    clear rawVol;
    clear mask;

    
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
    load(fileToLoad); % load as probVol
    fprintf('loaded %s \n', query.postIF{n});
    
    %load mask
    if maskFlag ~= -1
        load(maskFlag);
    else 
        mask = -1;
    end    
    
    % convert to prob space
    probVol = getProbMap(rawVol, mask);
    clear rawVol;
    clear mask;
    
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
save(outputfilename, 'resultVol', '-v7.3');
disp(outputfilename);

end
