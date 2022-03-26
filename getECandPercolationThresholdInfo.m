function [perclevel4, EC, spacingX, maxcount, mincount, saddles] = getECandPercolationThresholdInfo(z, zsad, step)
    spacingX=-1:step:1;
    
    %z,startingLevel,accuracy,bwlabelnum,HorizVert,decRound
    perclevel4 = getFirstPercLevel(z,0,0.000001,4,2,10);
    %perclevel8 = getFirstPercLevel(z,0,0.000001,8,2,10);

    zsad = reshape(zsad, size(z));
    zsad = reshape(zsad, size(z,1),size(z,2));

    saddles= [];
    %maxlocs = islocalmax(z,1).*islocalmax(z,2);
    maxlocs = zeros(size(z));
    maxlocs(2:end-1, 2:end-1) = imregionalmax(z(2:end-1, 2:end-1),8);
    maxvals = z.*maxlocs;
    
    %minlocs = islocalmin(z,1).*islocalmin(z,2);
    minlocs = zeros(size(z));
    minlocs(2:end-1, 2:end-1) = imregionalmin(z(2:end-1, 2:end-1),8);
    minvals = z.*minlocs;
    saddleHeights = zsad.*z;
    
    maxcount = [];
    mincount = [];
    for i=-1:step:1
        v = (saddleHeights <= i & saddleHeights ~=0);
        sum1 = nnz(v);
        saddles = [saddles sum1];

        v = (maxvals <= i & maxvals ~=0);
        sum1 = nnz(v);
        maxcount = [maxcount sum1];

        v = (minvals <= i & minvals ~=0);
        sum1 = nnz(v);
        mincount = [mincount sum1];

    end
    EC = maxcount + mincount - saddles;
end   