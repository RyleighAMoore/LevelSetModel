%Toal area, perimeter, pond count, saddles figure
%surfname = 'realdataScaled' % Change this for the new surface
step = 0.033;
step = 0.01;
w=-1:step:1;
areanumarray = [];
z = dlmread('.\FittedSquareReallinear.csv');
%perclevel = getFirstPercLevel(z,0,0.000001,8,0,100);
perclevel = getFirstPercLevel(z,0,0.000001,4,0,100);
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
        P = struct2array(P);
        if isempty(P)
            P=0;
        end
        PerCount = PerCount+P;
    end
    PerRegionProps = [PerRegionProps P2]
end
Area = Area

zsad = dlmread('.\FittedSquareRealLinearSaddles.csv');
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
% figure; 
% hold on
% plot(w, mincount/max(mincount))
% plot(w,maxcount/max(maxcount))
% plot(w,saddles/max(saddles))
% y = linspace(0,1,100)
% x = ones(size(y))
% plot(perclevel*x, y)
% legend('mins','maxes','saddles', 'percthresh')
% hold off
% %%
% figure; 
% hold on
% plot(w, mincount)
% plot(w,maxcount)
% plot(w,saddles)
% y = linspace(0,2*max(maxcount),100)
% x = ones(size(y))
% plot(perclevel*x, y)
% legend('mins','maxes','saddles', 'Percolation Threshold')
% hold off



%%
figure
hold on
plot(w,(maxcount-saddles+mincount)/max(maxcount-saddles+mincount), '*r', "markersize", 10)
y = linspace(0,1,100); x = ones(size(y));
plot(perclevel*x, y, "r")
plot(w, Per/max(Per), "markersize", 8)
plot(w, Area/max(Area), "markersize", 8, "color", "[0 0.5 0]")
plot(w, pondcount/max(pondcount), '.b', "markersize", 8)
plot(w, saddles/max(saddles), '.', "markersize", 8)
plot(w, mincount/max(mincount), '.m', "markersize", 8)
plot(w,maxcount/max(maxcount), '.', "markersize", 8, "color", "[0 0.5 0]")
lgnd = legend('# Maxima + # Minima - # Saddles',  'Percolation Threshold', 'Perimeter', 'Area', '# Ponds','# Saddles','# Minima', '# Maxima')
set(lgnd,'color','none');
legend boxoff
axis([-1 1 0 1])
%title('Normalized Real Pond Data')
ylabel('Normalized Values', 'fontsize',16)
xlabel('Level Set Height', 'fontsize',16)
hold off


%% Non Normalized
figure
hold on
plot(w,(maxcount-saddles+mincount), '*r', "markersize", 10)
y = linspace(0,1,100); x = ones(size(y));
plot(perclevel*x, y, "r")
lgnd = legend('# Maxima + # Minima - # Saddles',  'Percolation Threshold', 'Perimeter', 'Area', '# Ponds','# Saddles','# Minima', '# Maxima')
set(lgnd,'color','none');
legend boxoff
axis([-1 1 0 1])
%title('Normalized Real Pond Data')
ylabel('Normalized Values', 'fontsize',16)
xlabel('Level Set Height', 'fontsize',16)
hold off

% [allArea, allPer, AreaList, PerList, AreaListB, PerListB] = getPondPerArea(z)
% 
% figure; hold on
% 
% loglog(allPer,allArea,'.')
% loglog(Per, Area./pondcount,'.')
% hold off
% %z=getSurface([0.3,0.3],0);
% %csvwrite('surf1.csv',z)
% %csvwrite('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\surf1.csv',z)