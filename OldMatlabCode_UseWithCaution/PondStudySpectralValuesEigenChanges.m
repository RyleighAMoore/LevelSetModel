%This code is used to study the total area of the ponds as the model
%evolves.
w=-1:0.01:1;
scale = 250000;
Area = [];
Diff = [];
Diffcluster = [];
cluster = [];
z=getSurface([0.3,0.3],0);
firstperclevel = getFirstPercLevel(z,0,0.001,4,2,10)
step =0.01;
EigenSpaceAverage = [];
for i=-1:step:1
    N = double(z < i);
    NNext = double(z < i+step);
    Eigen = abs(eig(N));
    EigenNext = abs(eig(NNext));
    EigenSpaceAverage = [EigenSpaceAverage sum(Eigen-EigenNext)/size(Eigen,1)]; 
end
hold on
plot(w,EigenSpaceAverage)
plot([firstperclevel, firstperclevel], [-0.1,0.1]);
xlabel('Levelset Height')
ylabel('Average Eigenvalue Change from height h to delta h')
hold off


