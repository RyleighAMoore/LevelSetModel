E = []

for j=1:1:10
    j
    z=getSurface([0.3,0.3],0);
    N = double(z < 0);
    sing = real(sqrt(real(eig(N'*N))));
    E(j,:) = sing;
end
Ymax=max(max(E));
[X,Y] = UnfoldingPositive(E,10,15,40);
histogram(Y,'Normalization','probability')