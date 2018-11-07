function [percolates] = CheckIfPercolatesGivenLattice(Lattice, PlaneHeight,neigh,HorizVert)
%Lattice is the surface we are looking at
%Plane height, a number representing the height of the plane that
%intersects the lattice.
%neighbors - 4 or 8 for nearest neighbor (4) or next nearest neighbor (8)
%horzvert - 0 for top to bottom, 1 for left to right check of percolation
%Set lattice values to 0 or 1 based on plane height
%Set lattice values to 0 or 1 based on plane height

Lattice = real(Lattice <= PlaneHeight);

L = bwlabel(Lattice,neigh); %Find the clusters
L(L==0) = NaN;


if HorizVert == 2
    if any(ismember(L(1,:),L(end,:))) || any(ismember(L(:,1),L(:,end)))
        percolates = 1;
    else
        percolates = 0;
    end
end
if HorizVert == 0
    if any(ismember(L(1,:),L(end,:)))
        percolates = 1;
    else
        percolates = 0;
    end
end
if any(ismember(L(:,1),L(:,end)))
    percolates = 1;
else
    percolates = 0;
end
end



