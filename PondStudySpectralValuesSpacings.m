%This code is used to study the total area of the ponds as the model
%evolves.
w=-1:0.01:1;
scale = 250000;
Area = [];
Diff = [];
Diffcluster = [];
cluster = [];
%z=getSurface([0.3,0.3],0);
firstperclevel = getFirstPercLevel(z,0,0.001,4,2,10)
step =0.01;
hold on
for i=0:step:1
    i
    N = double(z < i);
    Eigen = abs(eig(N));
    s= sum(sum(N)); %total water
    Area = [Area s/scale];
    diff = [];
    for j=1:1:size(Eigen,1)-1
        d = Eigen(j)-Eigen(j+1);
        diff = [diff d];
    end
    height = i*ones(size(diff,2));
    plot(i, sum(diff),'.k')
end
hold off


