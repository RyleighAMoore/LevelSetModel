    Image = getSurface([0.5 0.2],1)
    %Image=[1 1 3; 4 2 4; 2 1 3]
    Image=0.1*[1 1 3 1;4 2 4 2;2 1 2 1; 2 1 3 2];
    Image=0.1*[1 1 3 1 1;1 4 2 4 2; 1 2 1 2 1; 1 2 1 3 2; 1 2 1 3 2];
tol=0.01
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
s=size(i,1)
for r=1:1:s
    if(Cx(i(r),j(r))<tol && Cx(i(r),j(r))>-tol && Cy(i(r),j(r))<tol && Cy(i(r),j(r))>-tol)
        plot3(i(r),j(r),2, 'k.');
    end
end
hold off;
    