function firstPercLevel = getFirstPercLevel(z,startingLevel,accuracy,bwlabelnum,HorizVert,decRound)
%Lattice is the surface we are looking at
%startingLevel, a number representing the starting level of the plane that
%intersects the lattice.]
%accuracy - a number used for delta height
%neighbors - 4 or 8 for nearest neighbor (4) or next nearest neighbor (8)
%horzvert - 0 for top to bottom, 1 for left to right check of percolation,
%2 for either
count = 0;
surfaceLevel = startingLevel;
iterations = ceil(sqrt(2/accuracy));
while count<= iterations
    count = count +1;
    if CheckIfPercolatesGivenLattice(z, surfaceLevel, bwlabelnum,HorizVert) == 1
        surfaceLevel = round(surfaceLevel - (1/(2^count)),decRound);
    else
        surfaceLevel = round(surfaceLevel + (1/(2^count)),decRound);
    end
end

firstPercLevel = surfaceLevel;
end