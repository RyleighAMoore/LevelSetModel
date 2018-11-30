%This code is used to study the total area of the ponds as the model
%evolves.
Area = [];
Areaperpond = [];
w=-1:0.01:1;
pondnumbers = [];
Per =[];
scale = 1;
%z=getSurface([0.3,0.3],1);
AreaFrac = [];
for i=-1:0.01:1
    N = real(z < i);
    [L,n]=bwlabel(N,4);
    pondnumbers = [pondnumbers n];
    s= sum(sum(real(z < i)))/scale; %total water
    Area = [Area s];
    Areaperpond = [Areaperpond s/n];
    AF = s/(size(N,1)*size(N,2));
    AreaFrac = [AreaFrac AF];
end
figure;
hold on;
plot(w, Area/(500*500));
%plot(w, Areaperpond);
%plot(w,pondnumbers);
legend('Area', 'Avg Area', '# ponds')
scale = 1;
%z=getSurface([0.3,0.3],1);

MaxEval = [];
for i=-1:0.1:1
    N = real(z < i);
    Eigen = real(eig(N));
    %Norm = norm(N);
    height = i*ones(size(Eigen));
    MaxEval = [MaxEval max(Eigen)];
    plot(height, Eigen./size(N,1), '.');
end
xlabel('levelset height')
ylabel('Normalized Eigenvalues and Areas')
hold off;

figure;
hold on;
plot(w, AreaFrac);