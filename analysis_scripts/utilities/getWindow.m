function [minr, maxr, minc, maxc] = getWindow(r, c, win, imagesize) 


    if (min(r) - win < 1)
        minr = 1;
    else
        minr = min(r) - win;
    end
    
    if (min(c) - win < 1)
        minc = 1;
    else
        minc = min(c) - win;
    end
    
    if (max(r) + win > imagesize(1))
        maxr = imagesize(1);
    else
        maxr = max(r) + win;
    end
    
    if (max(c) + win > imagesize(2))
        maxc = imagesize(2);
    else
        maxc = max(c) + win;
    end
    
    

end
