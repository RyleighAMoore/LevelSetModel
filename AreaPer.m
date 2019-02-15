%This code is used to study the number of ponds and other qualities for
%multiple surfaces.

AreaPond = [];
AreaIce = [];
w=-1:0.01:1;
scale = 1500;
areanumarray = [];
iceareaarray = [];
%z=getSurface([0.3,0.3],0);
perclevel = getFirstPercLevel(z,0,0.000001,4,0,100);
pondnumbers = [];
AreaPond= [];
PerPond= [];
AreaIce = [];
newSum = [0];
newArea = [0];
for i=-1:0.01:1
    N = real(z <= i);
    [L,n]=bwlabel(N,4);
    pondnumbers = [pondnumbers n];
    s = sum(sum(real(z <= i)))/scale;
    AreaPond = [AreaPond s];
    newArea = [newArea s-sum(newArea)]
    P = regionprops(N,'perimeter');
    P = struct2array(P);
    if isempty(P)
       P=0
    end
    s = sum(PerPond);
    PerPond = [PerPond P];
    newSum = [newSum P-sum(newSum)];
end

figure;
hold on
plot(w, PerPond)
y = linspace(0,2,100)
x= ones(size(y))
plot(perclevel*x, y)

csvwrite('surf1.csv',z)