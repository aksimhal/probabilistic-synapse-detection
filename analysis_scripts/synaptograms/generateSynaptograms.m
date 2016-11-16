function generateSynaptograms(CC, listOfMatFiles, win, labelStrs, ...
    filenames, nm_px)

% loop through CC
% cutout proper portions of data
% create FN
% composesynaptograms


% load each ch as a mat obj
numOfChannels = length(listOfMatFiles);
objArray = cell(length(listOfMatFiles), 1);

for n=1:length(listOfMatFiles)
    objArray{n} = matfile(listOfMatFiles{n});
end
imagesize = CC.ImageSize;

% Loop over each synaptogram
for n=1:length(CC.PixelIdxList)
    
    [r, c, z] = ind2sub(CC.ImageSize, CC.PixelIdxList{n});
    
    [minr, maxr, minc, maxc] = getWindow(r, c, win, imagesize);
    
    numRows = maxr - minr + 1;
    numCols = maxc - minc + 1;
    
    
    % Add two slice padding
    if (min(z) == 1)
        minz = min(z);
    else
        minz = min(z) - 1;
    end
    
    if (max(z) == imagesize(3))
        maxz = max(z);
    else
        maxz = max(z) + 1;
    end
    
    numOfSlices = maxz - minz + 1;
    
    synapimg = zeros(numRows * numOfChannels, numCols * numOfSlices);
    
    blockWidth = numCols;
    blockHeight = numRows;
    
    slicepos = 1;
    ifpos = 1;

    for ch_ind = 1:numOfChannels
        disp(ch_ind)
        for sliceind = minz:maxz
            
            row_ranges = minr:maxr;
            col_ranges = minc:maxc;
            baseR_ranges = ifpos:(ifpos+numRows-1);
            baseC_ranges = slicepos:(slicepos+numCols-1);
            
            chObj = objArray{ch_ind};
            varlist = who(chObj);
            
            synapimg(baseR_ranges, baseC_ranges) = chObj.(varlist{1})(row_ranges, col_ranges, sliceind);
            
            slicepos = slicepos + numCols + 1;
            
        end
        slicepos = 1;
        ifpos = ifpos + numRows + 1;
        
    end
    


    % PLOT SYNAPTOGRAM
    hfig = figure('units','normalized','outerposition',[0 0 1 1], 'Visible','off');
    
    h = imagesc(synapimg);
    
    % add lines
    slicepos = 1;
    ifpos = 1;
    for ifch_ind = 1:numOfChannels
        for sliceind = minz:maxz
            line([slicepos, (slicepos)], [ifpos, (ifpos+numRows)]);
            line([slicepos, (slicepos+numCols)], [ifpos, (ifpos)]);
            
            slicepos = slicepos + numCols + 1;
        end
        slicepos = 1;
        ifpos = ifpos + numRows + 1;
    end
    
    labelStrItr = 1;
    for nRow=7:numRows+1:size(synapimg, 1)
        firstColFlag = 1;
        for mCol=3:numCols+1:size(synapimg, 2)-20
            if (firstColFlag == 1)
                text(mCol, nRow, labelStrs{labelStrItr}, 'Color' ,'g', 'FontSize', 14);
            end
            firstColFlag = firstColFlag + 1;
        end
        labelStrItr = labelStrItr + 1;
    end
    
    title(filenames{n});
    
    xlabel(sprintf('Block Width: %f nm', blockWidth * nm_px));
    ylabel(sprintf('Block Height: %f nm', blockHeight * nm_px));
    
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    colorbar;
    
    filename = strcat(filenames{n}, '.png');
    saveas(h, filename);
    disp(filename);
    close all;
end
end


