w=-1:0.1:1;

figure 
hold on;
for ii = 1:size(w,2)
    for jj = 1:size(AreaArr,2)
        if (AreaArr(ii,jj)~=0) || (AreaArrB(ii,jj)~=0)
            plot(w(ii),AreaArr(ii,jj)/(500*500),'*k');
            plot(w(ii),AreaArrB(ii,jj)/(500*500),'*k');
        end
    end
end

%This code is used to study the total area of the ponds as the model
%evolves.
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