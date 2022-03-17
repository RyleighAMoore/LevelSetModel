function [numZeros, rightleft, updown] = getSurroundingZeros(lattice, row, col)
numZeros = 0;
rightleft = 0;
updown = 0;
[r,c] = size(lattice);
    try
       if (lattice(row,col+1)==0)
           numZeros = numZeros +1;
           rightleft = rightleft +1;
       end
    catch
       numZeros = numZeros + 1;
       rightleft = rightleft +1;
    end
    
    try
       if (lattice(row,col-1)==0)
           numZeros = numZeros +1;
           rightleft = rightleft +1;
       end
    catch
       numZeros = numZeros +1;
       rightleft = rightleft +1;
    end 
    
    try
       if (lattice(row-1,col)==0)
           numZeros = numZeros +1;
           updown = updown +1;
       end
    catch
       numZeros = numZeros +1;
       updown = updown +1;

    end
    
    try
       if (lattice(row+1,col)==0)
           numZeros = numZeros +1;
           updown = updown +1;

       end
    catch
       numZeros = numZeros +1;
       updown = updown +1;
    end
end
    