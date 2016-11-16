function thresholdOutputs(threshold, gelatin, gaba)



if (gelatin)
    baseStr = '/data/anish/Synaptome/gelatin/gelatinResult_';
    targetStr = '/data/anish/Synaptome/gelatin/results/gelatinResultBinary';
    
    if (~gaba)
        
        for volNum = 1:7
            load(strcat(baseStr, num2str(volNum)));
            resultVol = resultVol > threshold;
            
            disp(volNum);
            resultVol = bwlabeln(resultVol, 26);
            targetDir = strcat(targetStr, filesep, num2str(volNum));
            
            isdir_result = isdir(targetDir);
            if ~isdir_result
                mkdir(targetDir);
            end
            
            for z = 1:size(resultVol, 3)
                img = resultVol(:, :, z);
                img = uint16(img);
                filename = sprintf('img_%03d.tif', z-1);
                disp(filename);
                filepath = strcat(targetDir, filesep, filename);
                imwrite(img, filepath);
            end
            
        end
        
    else
        for volNum = 8:14
            load(strcat(baseStr, num2str(volNum)));
            resultVol = resultVol > threshold;
            
            disp(volNum);
            resultVol = bwlabeln(resultVol, 26);
            targetDir = strcat(targetStr, filesep, num2str(volNum));
            
            isdir_result = isdir(targetDir);
            if ~isdir_result
                mkdir(targetDir);
            end
            
            for z = 1:size(resultVol, 3)
                img = resultVol(:, :, z);
                img = uint16(img);
                filename = sprintf('img_%03d.tif', z-1);
                disp(filename);
                filepath = strcat(targetDir, filesep, filename);
                imwrite(img, filepath);
            end
            
        end
    end
    
    
else
    baseStr = '/data/anish/Synaptome/silane/silaneResult_';
    targetStr = '/data/anish/Synaptome/silane/results/silaneResultBinary';
    
    for volNum = 1:7
        load(strcat(baseStr, num2str(volNum)));
        resultVol = resultVol > threshold;
        
        disp(volNum);
        resultVol = bwlabeln(resultVol, 26);
        targetDir = strcat(targetStr, filesep, num2str(volNum));
        
        isdir_result = isdir(targetDir);
        if ~isdir_result
            mkdir(targetDir);
        end
        
        for z = 1:size(resultVol, 3)
            img = resultVol(:, :, z);
            img = uint16(img);
            filename = sprintf('img_%03d.tif', z-1);
            disp(filename);
            filepath = strcat(targetDir, filesep, filename);
            imwrite(img, filepath);
        end
        
    end
    
end





end
