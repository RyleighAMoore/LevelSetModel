%Toal area, perimeter, pond count, saddles figure
%surfname = 'realdataScaled' % Change this for the new surface
clear all
step = 0.1;
w=-1:step:1;
areanumarray = [];
z = dlmread('.\PaperSurfaces\FittedSquareReallinear.csv');
zsad = dlmread('.\PaperSurfaces\FittedSquareRealLinearSaddles.csv');

perclevel = getFirstPercLevel(z,0,0.000001,4,1,10);
[pondcount, Area, Per] = getPerimeterAreaPondCounts(z, step)
[temp, EC, spacingX, maxcount, mincount, saddles] = getECandPercolationThresholdInfo(z, zsad, step)


%% Non Normalized
figure
hold on
y = linspace(min(maxcount-saddles+mincount)-20,max(maxcount-saddles+mincount)+2,100); x = ones(size(y));
plot(perclevel*x, y, "r")
plot(w,(maxcount-saddles+mincount), '.-k', "markersize", 20, "linewidth", 2)
lgnd = legend('Percolation Threshold Level','# Maxima + # Minima - # Saddles', 'Location','northeast');
set(lgnd,'color','none');
legend boxoff
%title('Normalized Real Pond Data')
ylabel('Euler Characteristic', 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
ylim([-60, 100])
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


%% Normalized
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
