topo = dlmread('D:\Rylei\Documents\ResearchKen\SedCityRadarDepths_noheader.csv',',');
topo = topo';


x = (0:size(topo,2)-1)*0.235;
y = (0:size(topo,1)-1)*2;



[xx, yy] = meshgrid(x,y);


xq = (0:1:208);
yq = (0:1:24);

[xq, yq] = meshgrid(xq,yq);


Vq = griddata(xx,yy,topo,xq,yq, 'cubic');

minx= min(min(Vq))
maxx = max(max(Vq))
VqScaled = []
for idx = 1:numel(Vq)
    element = Vq(idx);
    VqScaled(idx) = 2*((element-minx)/(maxx-minx))-1;
end
VqScaled = reshape(VqScaled, size(Vq))

csvwrite('FittedSquareRealcubic.csv',VqScaled)


