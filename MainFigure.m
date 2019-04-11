%Toal area, perimeter, pond count, saddles figure
surfname = 'surf1' % Change this for the new surface
step = 0.01;
w=-1:step:1;
areanumarray = [];
z = dlmread(strcat('C:\Users\Dane\Desktop\Golden Group Research\LevelSetModel\Surfaces\',surfname, '.csv'),',');
%z= topo2
perclevel = getFirstPercLevel(z,0,0.000001,8,0,100);
pondcount = [];
Area= [];
Per= [];
PerRegionProps=[]
maxes = []
mins = []
for i=-1:step:1  
    i
    N = real(z <= i);
    s = sum(sum(N));
    Area = [Area s];
    [L,n]=bwlabel(N,8);
    pondcount = [pondcount n];
    A=N;
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
    Per = [Per perTotal];
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

zsad = dlmread(strcat('C:\Users\Dane\Desktop\Golden Group Research\LevelSetModel\Surfaces\',surfname,'saddles.csv'),',');
zsad = reshape(zsad, size(z))
saddles= [];
w = -1:step:1;
maxlocs = islocalmax(z,1).*islocalmax(z,2);
maxvals = z.*maxlocs;
minlocs = islocalmin(z,1).*islocalmin(z,2);
minvals = z.*minlocs;
saddleHeights = zsad.*z;
maxcount = [];
mincount = [];
for i=-1:step:1
    v = (saddleHeights <= i & saddleHeights ~=0);
    sum1 = nnz(v);
    saddles = [saddles sum1];
    
    v = (maxvals <= i & maxvals ~=0);
    sum1 = nnz(v);
    maxcount = [maxcount sum1];
    
    v = (minvals <= i & minvals ~=0);
    sum1 = nnz(v);
    mincount = [mincount sum1];
    
end
%%
figure; 
hold on
plot(w, mincount/max(mincount))
plot(w,maxcount/max(maxcount))
plot(w,saddles/max(saddles))
y = linspace(0,max(maxcount),100)
x = ones(size(y))
plot(perclevel*x, y)
legend('mins','maxes','saddles', 'percthresh')
hold off
%%
figure; 
hold on
plot(w, mincount)
plot(w,maxcount)
plot(w,saddles)
y = linspace(0,max(maxcount),100)
x = ones(size(y))
plot(perclevel*x, y)
legend('mins','maxes','saddles', 'percthresh')
hold off



%%
figure
hold on
plot(w, Per/max(Per), '.')
plot(w, Area/max(Area), '.')
plot(w, pondcount/max(pondcount), '.')
plot(w, saddles/max(saddles), '.')
y = linspace(0,1,100)
x= ones(size(y))
plot(perclevel*x, max(maxcount))
plot(w, mincount/max(mincount))
plot(w,maxcount/max(maxcount))
legend('Per', 'Area', 'pondcount','Saddles', 'Perc Thresh','mins', 'maxes')
hold off


%csvwrite('surf1.csv',z)
%csvwrite('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\surf1.csv',z)