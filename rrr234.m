%This code is used to study the total area of the ponds as the model
%evolves.
w=-1:0.01:1;
scale = 250000;
Area = [];
Diff = [];
Diffcluster = [];
cluster = [];
z=getSurface([0.3,0.3],1);
figure;
hold on;
for i=-1:0.01:1
    N = double(z < i);
    Eigen = abs(eig(N));
    height = i*ones(size(Eigen));
    plot(height, Eigen./size(N,1), '.');
    %plot(height, std(Eigen./size(N,1)), '*')
    s= sum(sum(N)); %total water
    Area = [Area s/scale];
    maxpond = max(getIndivPondSizes(z,height,4))/scale;
    cluster =[cluster maxpond];
    if any(Eigen) == 0 
        maxVal = 0;
    else
        maxVal = max(Eigen)/size(N,1);
    end
    diff = (maxVal-(s/scale));
    diffcluster = (maxVal-maxpond);
    Diff = [Diff diff];
    Diffcluster = [Diffcluster diffcluster];
end
plot(w, Area);
plot(w, cluster);
hold off;
figure
DiffPos = (Diff > 0).*Diff;
DiffNeg = (Diff <= 0).*Diff;
DiffPosC = (Diffcluster > 0).*Diffcluster;
DiffNegC = (Diffcluster <= 0).*Diffcluster;
hold on
plot(w, DiffPos, '.k');
plot(w, DiffNeg, '.r');
ho
plot(w, DiffPosC, '.k');
plot(w, DiffNegC, '.r');
hold off

