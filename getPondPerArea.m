function [allArea, allPer, AreaList, PerList, AreaListB, PerListB] = getPondPerArea(z)
scale = 1;
perclevel = getFirstPercLevel(z,0,0.001,4,0,10);
sizeofarray = 2000;
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
count =1;
biggestn = 0;
for j=-1:0.1:1
    j
    ponds = (z <= j);
    [L,n] = bwlabel(ponds, 4);
    if n> biggestn
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

end