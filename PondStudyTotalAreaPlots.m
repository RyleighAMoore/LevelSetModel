%This code is used to study the total area of the ponds as the model
%evolves.
Area = [];
Areaperpond = [];
w=-1:0.1:1;
pondnumbers = [];
Per =[];
scale = 1;
z=getSurface([0.3,0.3],1);

for i=-1:0.1:1
    N = real(z < i);
    [L,n]=bwlabel(N,4);
    pondnumbers = [pondnumbers n];
    s= sum(sum(real(z < i)))/scale; %total water
    Area = [Area s];
    Areaperpond = [Areaperpond s/n];
end
figure;
hold on;
plot(w, Area);
%plot(w, Areaperpond);
%plot(w,pondnumbers);
legend('Area', 'Avg Area', '# ponds')
