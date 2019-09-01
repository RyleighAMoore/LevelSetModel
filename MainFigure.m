%Toal area, perimeter, pond count, saddles figure
surfname = 'realdataScaled' % Change this for the new surface
step = 0.01;
w=-1:step:1;
areanumarray = [];
z = dlmread(strcat('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\',surfname, '.csv'),',');
perclevel = getFirstPercLevel(z,0,0.000001,8,0,100);
pondcount = [];
Area= [];
Per= [];
PerRegionProps=[]
maxes = []
mins = []
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
    P2 = bwperim(N);
    P2 = nnz(P2)
    for j=1:1:n
        indpond = (L == j);
        P = regionprops(indpond,'perimeter');
        P = struct2array(P);
        if isempty(P)
            P=0;
        end
        PerCount = PerCount+P;
    end
    PerRegionProps = [PerRegionProps P2]
end

zsad = dlmread(strcat('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\',surfname,'Saddles.csv'),',');
zsad = reshape(zsad, size(z))
zsad = reshape(zsad, size(z,1),size(z,2))

saddles= [];
w = -1:step:1;
maxlocs = islocalmax(z,1).*islocalmax(z,2);
maxvals = z.*maxlocs;
minlocs = islocalmin(z,1).*islocalmin(z,2);
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
%%
figure; 
hold on
plot(w, mincount/max(mincount))
plot(w,maxcount/max(maxcount))
plot(w,saddles/max(saddles))
y = linspace(0,1,100)
x = ones(size(y))
plot(perclevel*x, y)
legend('mins','maxes','saddles', 'percthresh')
hold off
%%
figure; 
hold on
plot(w, mincount)
plot(w,maxcount)
plot(w,saddles)
y = linspace(0,2*max(maxcount),100)
x = ones(size(y))
plot(perclevel*x, y)
legend('mins','maxes','saddles', 'Percolation Threshold')
hold off



%%
figure
hold on
plot(w, Per/max(Per), '.')
plot(w, Area/max(Area), '.')
plot(w, pondcount/max(pondcount), '.')
plot(w, saddles/max(saddles))
plot(w, mincount/max(mincount))
plot(w,maxcount/max(maxcount))
plot(w,(maxcount-saddles+mincount)/max(maxcount-saddles+mincount), '*')
y = linspace(0,1,100)
x = ones(size(y))
plot(perclevel*x, y)
legend('Perimeter', 'Area', 'pondcount','Saddles','mins', 'maxes', '#Maxes+#Mins-#Saddles', 'Percolation Threshold')
axis([-1 1 0 1])
title('Normalized Real Pond Data')
hold off


[allArea, allPer, AreaList, PerList, AreaListB, PerListB] = getPondPerArea(z)

figure; hold on

loglog(allPer,allArea,'.')
loglog(Per, Area./pondcount,'.')
hold off
%z=getSurface([0.3,0.3],0);
%csvwrite('surf1.csv',z)
%csvwrite('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\surf1.csv',z)