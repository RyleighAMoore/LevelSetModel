surfname = 'realdataScaled' % Change this for the new surface
z = dlmread(strcat('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\',surfname, '.csv'),',');
zsad = dlmread(strcat('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\',surfname,'saddles.csv'),',');
zsad = reshape(zsad, size(z))
saddles= [];
step = 0.1;
w = -1:step:1;
maxlocs = islocalmax(z,1).*islocalmax(z,2);
maxvals = z.*maxlocs;
minlocs = islocalmin(z,1).*islocalmin(z,2);
minvals = z.*minlocs;
saddleHeights = zsad.*z;
maxcount = [];
mincount = [];

a= minlocs.*z
a= a(a~=0) %get all the non zero values
a=sort(a)

b= zsad.*z
b= b(b~=0) %get all the non zero values
b=sort(b)

c= maxlocs.*z
c= c(c~=0) %get all the non zero values
c=sort(c)


areaval =[]
Perval = []
for i=-1:step:1
    curr = (z<=i);
    val = curr(5,280);
    if val ~=0
        t = nnz(curr==val)
    else
        t=0
    end
    areaval = [areaval t];
    
    A=(curr==val);
    perTotal = 0;
    [r, c]= size(A);
    for row=1:1:r
        for col=1:1:c
            if A(row,col)==1
                numZeros = getSurroundingZeros(A, row, col);
                perTotal = perTotal + numZeros;
            end
        end
    end
    Perval = [Perval perTotal];
    PerCount = 0;
    for j=1:1:n
        indpond = (L == j);
        P = regionprops(N,'perimeter');
        P = struct2array(P);
        if isempty(P)
            P=0;
        end
        PerCount = PerCount+P;
    end
    PerRegionProps = [PerRegionProps PerCount]
end
    
%%
figure;
hold on;
for i=1:length(b)
   y = linspace(0,300,100)
   x= ones(size(y))
   plot(b(i)*x, y, 'g')
   plot(b(i)*x, y, 'g')
end

for i=1:length(a)
   y = linspace(0,300,100)
   x= ones(size(y))
   plot(a(i)*x, y, 'r')
   plot(a(i)*x, y, 'r')
end

for i=1:length(c)
   y = linspace(0,300,100)
   x= ones(size(y))
   plot(c(i)*x, y, 'b')
   plot(c(i)*x, y, 'b')
end
plot(w, Perval.^2./(4*pi*areaval))

% plot(w,areaval)
% plot(w,Perval)

hold off;