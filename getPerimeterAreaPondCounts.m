function [pondcount, Area, Per] = getPerimeterAreaPondCounts(z, step)
    pondcount = [];
    Area= [];
    Per= [];
    PerRegionProps=[];
    for i=-1:step:1
        N = real(z <= i);
        s = sum(sum(N));
        Area = [Area s];
        [L,n]=bwlabel(N,8);
        pondcount = [pondcount n];
        A=N;
        perTotal = 0;
        rightleftTotal = 0;
        updownTotal = 0;
        [r, c]= size(A);
        for row=1:1:r
            for col=1:1:c
                if A(row,col)==1
                    [numZeros, rightleft, updown] = getSurroundingZeros(A, row, col);
                    %perTotal = perTotal + numZeros;
                    rightleftTotal = rightleftTotal + rightleft;
                    updownTotal = updownTotal + updown;
                    perTotal = perTotal + numZeros;
                end
            end
        end
        Per = [Per perTotal];
        PerCount = 0;
        P2 = bwperim(N);
        P2 = nnz(P2);
        for j=1:1:n
            indpond = (L == j);
            P = regionprops(indpond,'perimeter');
            P = P.Perimeter;
            if isempty(P)
                P=0;
            end
            PerCount = PerCount+P;
        end
        PerRegionProps = [PerRegionProps P2]
    end
    Area = Area;