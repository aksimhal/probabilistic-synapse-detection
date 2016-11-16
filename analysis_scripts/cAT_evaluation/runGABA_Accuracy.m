% runGABA_Accuracy 

label_win = 175;
smallBlobWindow = 10;
threshold = 0.6;


for n=1:18 
    calculate_accuracy_gelatin_gaba(threshold, smallBlobWindow, label_win, n); 
end
