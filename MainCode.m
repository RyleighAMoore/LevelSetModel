function Pc = MainCode(numSurf, bwlabelnum, graphNums,p)
%numSurf = 500; % Number of surfaces to test
%bwlabelnum = 4; % 4 nearest neighbor, 8 next nearest neighbor
%graphNums = 1; %0 Only histogram, 1 only perc graph, 2 both
%p=[p1,p2] which are between 0 and 1.
decRound = 10; %Number of decimal places for rounding
deltaX = 0.001; %bin size on plot
accuracy = .01; %a number used for delta height when moving plane up surface
PcLevels = [];
HorizVert = 2;
areaFracs = [];
PAall =[];
NPAall =[];
for r=1:1:numSurf
    r
    [z,Off,Coef] = getSurface(p,1); % Brady code for surface
    percolated = 0; %0 no, 1 yes.
    startingLevel = 0;
    surfaceLevel = getFirstPercLevel(z,startingLevel,accuracy,bwlabelnum,HorizVert,decRound);
    Af = FindAreaFraction(z, surfaceLevel);
    areaFracs = [areaFracs Af];
    if graphNums == 1 || graphNums == 2
        [PA, NPA] = populateAreaFractionArrays(z, surfaceLevel, decRound);
        PAall =[PAall PA];
        NPAall =[NPAall NPA];
    end
end
if graphNums == 1 || graphNums == 2
    Pc = graphPc(deltaX,p,PAall,NPAall,bwlabelnum,numSurf,decRound);
end
if graphNums == 0 || graphNums == 2
    graphHistogram(areaFracs, deltaX,p,bwlabelnum,numSurf,decRound)
end
end