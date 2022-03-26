%Toal area, perimeter, pond count, saddles figure
%surfname = 'realdataScaled' % Change this for the new surface
step = 0.033;
step = 0.1;
w=-1:step:1;
areanumarray = [];
z = dlmread('.\FittedSquareReallinear.csv');
fname = ""
z = dlmread('.\SurfaceStudy\' + fname+'.csv');

perclevel = getFirstPercLevel(z,0,0.000001,4,1,10);

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
        P = P.Perimeter;
        if isempty(P)
            P=0;
        end
        PerCount = PerCount+P;
    end
    PerRegionProps = [PerRegionProps P2]
end
Area = Area

zsad = dlmread('.\FittedSquareRealLinearSaddles.csv');
zsad = dlmread('.\SurfaceStudy\' + fname+'saddles.csv');

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
% figure
% hold on
% plot(w,(maxcount-saddles+mincount)/max(maxcount-saddles+mincount), '*-r', 'LineWidth', 2, "markersize", 10)
% y = linspace(0,1,100); x = ones(size(y));
% plot(perclevel*x, y, "r")
% plot(w, Per/max(Per), "--", "markersize", 8)
% plot(w, Area/max(Area), ":" , "markersize", 8, "color", "[0 0.5 0]", 'LineWidth', 1)
% plot(w, pondcount/max(pondcount), '.b-', "markersize", 8, 'LineWidth', 0.5)
% plot(w, saddles/max(saddles), 'o', "markersize", 8, 'LineWidth', 1)
% plot(w, mincount/max(mincount), '.m', "markersize", 8, 'LineWidth', 1)
% plot(w,maxcount/max(maxcount), '.-', "markersize", 8, "color", "[0 0.5 0]", 'LineWidth', 0.5)
% lgnd = legend('# Maxima + # Minima - # Saddles',  'Percolation Threshold', 'Perimeter', 'Area', '# Ponds','# Saddles','# Minima', '# Maxima')
% set(lgnd,'color','none');
% legend boxoff
% axis([-1 1 0 1])
% %title('Normalized Real Pond Data')
% ylabel('Normalized Values', 'fontsize',16)
% xlabel('Level Set Height', 'fontsize',16)
% hold off


%% Non Normalized
figure
hold on
y = linspace(min(maxcount-saddles+mincount)-10,max(maxcount-saddles+mincount)+2,100); x = ones(size(y));
plot(perclevel*x, y, "r")
plot(w,(maxcount-saddles+mincount), '.-k', "markersize", 20, "linewidth", 2)
lgnd = legend('Percolation Threshold Level','# Maxima + # Minima - # Saddles', 'Location','northeast');
set(lgnd,'color','none');
legend boxoff
%title('Normalized Real Pond Data')
ylabel('Euler Characteristic', 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
%ylim([0, 120])
hold off


%%Area/ Perimeter
%% Non Normalized
figure
hold on
y = linspace(min(Area)-10,max(Area)+100,100); x = ones(size(y));
plot(perclevel*x, y, "r")
plot(w, Per, "-s", "markersize", 5, 'LineWidth', 2)
plot(w, Area, "o-" , "markersize", 5, "color", "[0 0.5 0]", 'LineWidth', 2)
lgnd = legend('Percolation Threshold Level', 'Perimeter', 'Area', 'Location','northwest');
set(lgnd,'color','none');
legend boxoff
%title('Normalized Real Pond Data')
ylabel('Perimeter (m) / Area (m^2)' , 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
ylim([0, 5500])
hold off


%%
figure
hold on
y = linspace(0,650); x = ones(size(y));
plot(perclevel*x, y, "r")
%plot(w, Per, "--", "markersize", 8)
%plot(w, Area, ":" , "markersize", 8, "color", "[0 0.5 0]", 'LineWidth', 2)
plot(w, pondcount, 'o-k', "markersize", 4, 'LineWidth',2)
plot(w, saddles, '-d', "markersize", 4, 'LineWidth', 2)
plot(w, mincount, '-vm', "markersize", 4, 'LineWidth', 2)
plot(w,maxcount, '-^', "markersize", 4, "color", "[0 0.5 0]", 'LineWidth', 2)
lgnd = legend('Percolation Threshold Level', '# Ponds','# Saddles','# Minima', '# Maxima', 'Location','northwest')
set(lgnd,'color','none');
legend boxoff
%title('Magnitude')
ylabel('Characteristic Count', 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
hold off



%%

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