Image = getSurface([0.5 0.2],1)
    %Image=[1 1 3; 4 2 4; 2 1 3]
    Image=0.1*[1 1 3 1;4 2 4 2;2 1 2 1; 2 1 3 2];
    Image=0.1*[1 1 3 1 1;1 4 2 4 2; 1 2 1 2 1; 1 2 1 3 2; 1 2 1 3 2];

% Evaluate gradient and hessian
[Cx, Cy] = gradient(Image);
[Cxx, Cxy] = gradient(Cx);
[Cyx, Cyy] = gradient(Cy);
D = Cxx.*Cyy - Cxy^2;

% Discard all the points on the boundary
[i,j]=find(D(2:end-1, 2:end-1) < 0);
i = i + 1; j = j + 1;

% Plot the surface and the saddle points
figure;
hold on;
surf(Image);
shading interp
plot3(i,j,repmat(4,[length(i),1]), 'k*');
hold off;