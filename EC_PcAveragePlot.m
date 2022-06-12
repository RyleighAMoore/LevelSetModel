%This file is used to plot the Euler Characteristic vs percoaltion
%threshold graph.

%% This block of code can be used to generate surfaces if needed. Skip if surfaces are ready to go.
%After generatiing surfaces, use SaddlesPytonCode/SaddlesLoop.py to
%compute all the associated saddle points. 


% surfacesDir = ".\IsotropicSurfaces"
% for i=1:500
%     i
%     surf = getSurface([0.5,0.5], 0);
%     csvwrite(strcat(surfacesDir, '\05-05-', string(i), ".csv"), surf);
% end


%%
clear all
surfacesDir = ".\IsotropicSurfaces"
saddleDir = ".\IsotropicSurfacesSaddles"

myFiles = dir(fullfile(surfacesDir,'*.csv'))
percLevels4 = [];
%percLevels8 = [];
ECs = [];
Mins = []
Maxes = []
Saddles = []
for k = 1:length(myFiles)
   k
   baseFileName = myFiles(k).name;
   surf = dlmread(strcat(surfacesDir, "\", baseFileName));
   saddleSurf = dlmread(strcat(saddleDir, "\", baseFileName));
   [perclevel4, EC, stepping, maxcount, mincount, saddlecount] = getECandPercolationThresholdInfo(surf, saddleSurf, 0.01);
   percLevels4 = [percLevels4, perclevel4];
   Mins = [Mins; mincount];
   Maxes = [Maxes; maxcount];
   Saddles = [Saddles; saddlecount];
   %percLevels8 = [percLevels8, perclevel8];
   ECs = [ECs; EC];
end

%%
Ponds = []
Perimeters = []
Areas = []
for k = 1:length(myFiles)
   k
   baseFileName = myFiles(k).name;
   surf = dlmread(strcat(surfacesDir, "\", baseFileName));
   saddleSurf = dlmread(strcat(saddleDir, "\", baseFileName));
   [pondcount, Area, Per] = getPerimeterAreaPondCounts(surf, step)
   Ponds = [Ponds; pondcount]
   Perimeters = [Perimeters; Per]
   Areas = [Areas; Area]
end

%%
p1 = 25
p2= 75
figure
hold on
y = linspace(-28,28); x = ones(size(y));
percentile_25 = prctile(ECs, p1);
percentile_75 = prctile(ECs, p2);

xfill = [stepping, fliplr(stepping)]
yfill = [percentile_25, fliplr(percentile_75)];
fill(xfill, yfill, 'g', 'DisplayName','EC 25-75th');

plot(stepping, mean(ECs), 'color',[0 0.5 0], "markersize", 20, "linewidth", 2, 'DisplayName','EC average')
plot(mean(percLevels4)*x, y, "r", "linewidth", 2)
get(gca)
axis on
a = line(xlim, [0,0], 'Color', 'k', 'LineWidth', 1); % Draw line for X axis.
% uistack(a,'bottom') %you can also do uistack(b,'bottom')
%legend boxoff
%title('Normalizced Real Pond Data')
ylabel('Euler Characteristic', 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
hold off



%%
clear all
surfacesDir = ".\IsotropicSurfaces"
saddleDir = ".\IsotropicSurfacesSaddles"
myFiles = dir(fullfile(surfacesDir,'*.csv'))
percLevels4 = [];
ECs = [];
Mins = []
Maxes = []
Saddles = []
step = 0.05
for k = 1:length(myFiles)-475
   k
   baseFileName = myFiles(k).name;
   surf = dlmread(strcat(surfacesDir, "\", baseFileName));
   saddleSurf = dlmread(strcat(saddleDir, "\", baseFileName));
   [perclevel4, EC, stepping, maxcount, mincount, saddlecount] = getECandPercolationThresholdInfo(surf, saddleSurf, step);
   percLevels4 = [percLevels4, perclevel4];
   Mins = [Mins; mincount];
   Maxes = [Maxes; maxcount];
   Saddles = [Saddles; saddlecount];
   %percLevels8 = [percLevels8, perclevel8];
   ECs = [ECs; EC];
end

Ponds = []
Perimeters = []
Areas = []
for k = 1:length(myFiles)-475
   k
   baseFileName = myFiles(k).name;
   surf = dlmread(strcat(surfacesDir, "\", baseFileName));
   saddleSurf = dlmread(strcat(saddleDir, "\", baseFileName));
   [pondcount, Area, Per] = getPerimeterAreaPondCounts(surf, step)
   Ponds = [Ponds; pondcount];
   Perimeters = [Perimeters; Per];
   Areas = [Areas; Area];
end

stepping = -1:step:1

%%
figure
hold on
y = linspace(0,150); x = ones(size(y));
plot(mean(percLevels4)*x, y, "r")

plot(stepping, mean(Ponds), 'o-k', "markersize", 4, 'LineWidth',2)
plot(stepping, mean(Saddles), '-d', "markersize", 4, 'LineWidth', 2)
plot(stepping, mean(Mins), '-vm', "markersize", 4, 'LineWidth', 2)
plot(stepping, mean(Maxes), '-^', "markersize", 4, "color", "[0 0.5 0]", 'LineWidth', 2)
lgnd = legend('Percolation Threshold Level', '# Ponds','# Saddles','# Minima', '# Maxima', 'Location','northwest')
set(lgnd,'color','none');
legend boxoff
%title('Magnitude')
ylabel('Characteristic Count', 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
hold off

figure
hold on
y = linspace(min(min(Areas))-10,100*100,100); x = ones(size(y));
plot(mean(percLevels4)*x, y, "r")
plot(stepping, mean(Perimeters), "-s", "markersize", 5, 'LineWidth', 2)
plot(stepping, mean(Areas), "o-" , "markersize", 5, "color", "[0 0.5 0]", 'LineWidth', 2)
lgnd = legend('Percolation Threshold Level', 'Perimeter', 'Area', 'Location','northwest');
set(lgnd,'color','none');
legend boxoff
%title('Normalized Real Pond Data')
ylabel('Perimeter (m) / Area (m^2)' , 'fontsize',14)
xlabel('Level Set Height', 'fontsize',14)
ylim([0, 100*100*1.1])
hold off


