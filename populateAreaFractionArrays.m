function [PA NPA] = populateAreaFractionArrays(z, surfaceLevel,decRound)
PA=[]; %Vector of percolating area fractions
NPA=[]; %Vector of non percolating area fractions
PcLevel = surfaceLevel; % save the first perc surface
while surfaceLevel < 1
PA=[PA round(FindAreaFraction(z,surfaceLevel+0.1),decRound)];
surfaceLevel = surfaceLevel + 0.1;
end
surfaceLevel = PcLevel; %reset the surface level to perc level
while surfaceLevel > -1
NPA=[NPA round(FindAreaFraction(z,surfaceLevel-0.1),decRound)];
surfaceLevel = surfaceLevel - 0.1;
end
end