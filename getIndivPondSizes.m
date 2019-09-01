function IndivPondSizes = getIndivPondSizes(surface,height,labelnum)
    IndivPondSizes=[0];
    water = real(surface < height);
    [L,n] = bwlabel(water,labelnum);
    iter = 1;
    while iter <= n
        size = sum(sum(L==iter));
        
        IndivPondSizes = [IndivPondSizes size];
        iter=iter+1;
end

