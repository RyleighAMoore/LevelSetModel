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
AreaArrB=zeros(sizeofarray);
PerArrB=zeros(sizeofarray);
AreaList=[];
PerList=[];
AreaListB=[];
PerListB=[];
w= -1:0.1:1;
count =5;
biggestn = 0;
perTotal= [];
for j=-1:0.01:1
    perTotal = [perTotal sum(Per)]
    j
    ponds = (z <= j);
    [L,n] = bwlabel(ponds, 4);
    if n > biggestn
        biggestn = n;
    end
    Area = zeros(1,sizeofarray);
    Per = zeros(1,sizeofarray);
    AreaB = zeros(1,sizeofarray);
    PerB = zeros(1,sizeofarray);
    for i=1:1:n
        indpond = (L == i);
        firstcol = indpond(:,1); 
        firstrow = indpond(1,:); 
        lastcol = indpond(:,size(indpond,2));
        lastrow = indpond(size(indpond,1),:);
        A = regionprops(indpond,'area');
        A = struct2array(A)/scale;
        P = regionprops(indpond,'perimeter');
        P = struct2array(P)/scale;
        Per(i) = P;
        if(max(firstcol)==0 && max(firstrow)==0 && max(lastcol)==0&& max(lastrow)==0)
            Area(i) = A;
            Per(i) = P;
            AreaList = [AreaList A];
            PerList = [PerList P];
        else 
            AreaB(i) = A;
            PerB(i)=P;
            AreaListB = [AreaListB A];
            PerListB = [PerListB P];
        end
        
    end
AreaArr(count,:)= Area;
PerArr(count,:)= Per;
AreaArrB(count,:)= AreaB;
PerArrB(count,:)= PerB;

count = count+1;
end

allArea =  [AreaList AreaListB]';
allPer =  [PerList PerListB]';
AreaList = AreaList';
PerList = PerList';
AreaListB = AreaListB';
PerListB = PerListB';

 %FD = 2.*(log(Per)./log(Area));

 figure;
 hold on;
 for y=0:1:10000
    plot(perclevel,y,'.k')
end
for ii = 1:size(w,2)
    for jj = 1:size(AreaArr,2)
        if (AreaArr(ii,jj)~=0) || (AreaArrB(ii,jj)~=0)
            plot(w(ii),AreaArr(ii,jj),'.k');
            plot(w(ii),AreaArrB(ii,jj),'.k');
        end
    end
end
hold off;

figure;
for ii = 1:size(PerArr,2)
    loglog(AreaArr(ii,:),PerArr(ii,:), '.k');
    loglog(AreaArrB(ii,:),PerArrB(ii,:), '.r');
    hold on;
end
hold off;

