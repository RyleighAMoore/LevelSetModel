topo = dlmread('C:\Users\Rylei\OneDrive\Documents\RESEARCH\SedCityRadarDepths_noheader.csv',',');
topo = topo';
x = (0:size(topo,2)-1)*0.235;
y = (0:size(topo,1)-1)*2;
imagesc(x,y,topo);
set(gca,'xtick',0:50:200);
set(gca,'ytick',0:5:25);
axis equal;
set(gca,'plotboxAspectRatio',[4 1 1]);
minx= min(min(topo))
maxx = max(max(topo))
topo2 = []
for idx = 1:numel(topo)
    element = topo(idx);
    topo2(idx) = 2*((element-minx)/(maxx-minx))-1;
end
topo2= reshape(topo2, size(topo))

