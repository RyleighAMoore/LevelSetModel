%This code is used to study the individual ponds as the model evoles.

z=getSurface([0.3,0.3],1);
scale = 1;
perclevel = getFirstPercLevel(z,0,0.001,4,0,10);
%[L,n] = bwlabel(ponds);
sizeofarray =2000;
Area = zeros(1,sizeofarray);
Per = zeros(1,sizeofarray);
AreaArr=zeros(sizeofarray);
PerArr=zeros(sizeofarray);
w= -1:0.01:1;
count =1;
biggestn = 0;
for j=-1:0.01:1
    j
    ponds = (z <= j);
    [L,n] = bwlabel(ponds, 4);
    if n> biggestn
        biggestn = n;
    end
    Area = zeros(1,sizeofarray);
    Per = zeros(1,sizeofarray);
    for i=1:1:n
        indpond = (L == i);
        A = regionprops(indpond,'area');
        A = struct2array(A)/scale;
        Area(i) = A;
        P = regionprops(indpond,'perimeter');
        P = struct2array(P)/scale;
        Per(i) = P;
    end
AreaArr(count,:)= Area;
PerArr(count,:)= Per;
count = count+1;
end
 %FD = 2.*(log(Per)./log(Area));

 figure;
 hold on;
 for y=0:1:10000
    plot(perclevel,y,'.k')
end
for ii = 1:size(w,2)
    ii
    for jj = 1:size(AreaArr,2)
        if AreaArr(ii,jj)~=0
            plot(w(ii),AreaArr(ii,jj),'.');
        end
    end
end
hold off;

figure;
for ii = 1:size(PerArr,2)
    loglog(AreaArr(ii,:),PerArr(ii,:), '.');
    hold on;
end
hold off;

