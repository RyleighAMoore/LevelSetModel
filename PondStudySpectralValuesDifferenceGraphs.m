%This code is used to study the total area of the ponds as the model
%evolves.
w=-1:0.01:1;
scale = 250000;
Area = [];
Diff = [];
Diffcluster = [];
%cluster = [];
z=getSurface([0.3,0.3],0);
firstperclevel = getFirstPercLevel(z,0,0.001,4,2,10);
figure;
hold on;
for i=-1:0.01:1
    N = double(z < i);
    %Eigen = abs(eig(N));
    Eigen = real(sqrt(eig(ctranspose(N)*N)));
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
plot([firstperclevel, firstperclevel], [0,1]);
xlabel('Levelset Height')
ylabel('Singular Values / Area')
legend('Singular Values', 'blue line - Total Area', 'red line - Largest Cluster Area' )
hold off;

DiffPos = (Diff > 0).*Diff;
DiffPos(DiffPos == 0) = NaN;
DiffNeg = (Diff <= 0).*Diff;
DiffNeg(DiffNeg == 0) = NaN;

DiffPosC = (Diffcluster > 0).*Diffcluster;
DiffPosC(DiffPosC == 0) = NaN;
DiffNegC = (Diffcluster <= 0).*Diffcluster;
DiffNegC(DiffNegC == 0) = NaN;

figure
hold on
plot(w, DiffPos, '.k');
plot(w, DiffNeg, '.r');
plot([firstperclevel, firstperclevel], [-0.01,0.01]);
hold off

figure
hold on
plot(w, DiffPosC, '.k');
plot(w, DiffNegC, '.r');
plot([firstperclevel, firstperclevel], [0,0.5]);
xlabel('Levelset Height')
ylabel('Max Eigenvalue - Max Pond Area')
hold off

