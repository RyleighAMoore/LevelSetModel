%Toal area, perimeter, pond count, saddles figure
surfname = 'realdataScaled' % Change this for the new surface
step = 0.01;
w=-1:step:1;
areanumarray = [];
%z=getSurface([0.2,0.85],0);
%z=topo2
z = dlmread(strcat(surfname, '.csv'),',');
perclevel = getFirstPercLevel(z,0,0.000001,8,0,100);
pondcount = [];
Area= [];
Per= [];
PerRegionProps=[]
for i=-1:step:1  
    i
    N = real(z <= i);
    s = sum(sum(N));
    Area = [Area s];
    [L,n]=bwlabel(N,8);
    pondcount = [pondcount n];
   
    A=N;
    perTotal = 0;
    [r, c]= size(A);
    for row=1:1:r
        for col=1:1:c
            if A(row,col)==1
                numZeros = getSurroundingZeros(A, row, col);
                perTotal = perTotal + numZeros;
            end
        end
    end
    Per = [Per perTotal];
    PerCount = 0;
    for j=1:1:n
        indpond = (L == j);
        P = regionprops(N,'perimeter');
        P = struct2array(P);
        if isempty(P)
            P=0;
        end
        PerCount = PerCount+P;
    end
    PerRegionProps = [PerRegionProps PerCount]
end

zsad = dlmread(strcat(surfname, 'Saddles.csv'),',');
zsad = reshape(zsad, size(z))
saddles= [];
w = -1:step:1;
for i=-1:step:1
    saddleHeights = zsad.*z;
    v = (saddleHeights <= i & saddleHeights ~=0);
    sum1 = nnz(v);
    saddles = [saddles sum1];
end

figure
hold on
plot(w, Per/max(Per), '.')
plot(w, Area/max(Area), '.')
plot(w, pondcount/max(pondcount), '.')
plot(w, saddles/max(saddles), '.')
y = linspace(0,1,100)
x= ones(size(y))
plot(perclevel*x, y)
legend('Per', 'Area', 'Saddles', 'Perc Thresh')
hold off

%csvwrite('surf1.csv',z)