function thresoldtest(threshold, gaba, silane)
% runGelatinClassifiers


label_win = 134;
smallBlobWindow = 30;
genSynapto = false;
grayFlag = false;

if ~gaba
    for trialNum = 1:7
        calculate_accuracy(silane, threshold, smallBlobWindow, label_win, ...
            genSynapto, grayFlag, trialNum);
    end
    
else
    
    for trialNum = 8:25
        calculate_accuracy_gelatin_gaba(threshold, smallBlobWindow, label_win,...
            trialNum)
    end
end


emailAnish('thresoldtest');
