%This code is used to study the total area of the ponds as the model
%evolves.
w=-1:0.1:1;
scale = 1;
%z=getSurface([0.3,0.3],1);
figure;
hold on;
MaxEval = [];
for i=-1:0.1:1
    N = real(z < i);
    Eigen = real(eig(N));
    %Norm = norm(N);
    height = i*ones(size(Eigen));
    MaxEval = [MaxEval max(Eigen)];
    plot(height, Eigen./size(N,1), '.');
end

hold off;

