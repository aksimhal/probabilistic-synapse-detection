% Determine appropriate thresholds 
load('cb_threshold.mat'); 
load('volumeStats.mat'); 

psdThresholds = zeros(12, 1);
gabaThresholds = zeros(12, 1);

for n = 1:length(psdThresholds)
    density = numOfPSDSynapses(n, :) ./ cbvolume(n);
    density = density - 1;
    [foo, foobar] = min(abs(density));
    psdThresholds(n) = foobar;
end

for n = 1:length(gabaThresholds)
    density = numOfGabaSynapses(n, :) ./ cbvolume(n);
    density = density - 0.1;
    [foo, foobar] = min(abs(density));
    gabaThresholds(n) = foobar;
end

totalS = 0; 
totalE = 0; 
totalI = 0; 

for n=1:12
    totalE = numOfPSDSynapses(n, psdThresholds(n)) + totalE; 
    totalI = numOfGabaSynapses(n, gabaThresholds(n)) + totalI;   
end

thresholdVec = 0.5:0.05:1;

psdThresholds = thresholdVec(psdThresholds); 
gabaThresholds = thresholdVec(gabaThresholds); 



save('tenToOne_thresholds', 'psdThresholds', 'gabaThresholds', ...
    'totalE', 'totalI'); 