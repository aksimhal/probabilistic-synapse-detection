function collateResults(threshold)
% collate gelatin into a single volume

filename = strcat('/data/anish/Synaptome/gelatin/gelatinResult_', num2str(1));
load(filename);
resultVolFinal = resultVol > threshold; 
disp('loaded first file'); 

for n=2:7 
    filename = strcat('/data/anish/Synaptome/gelatin/gelatinResult_', num2str(n));
    load(filename);
    resultVol = resultVol > threshold; 
    resultVolFinal = resultVolFinal + resultVol; 
    disp('loaded another file'); 
    disp(n) 
end
    
resultVol = resultVolFinal > 0; 

filename = '/data/anish/Synaptome/gelatin/gelatinResult_collate';
save(filename, 'resultVol', '-v7.3');
disp('file saved'); 
end


