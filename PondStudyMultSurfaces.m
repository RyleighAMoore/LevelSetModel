%This code is used to study the number of ponds and other qualities for
%multiple surfaces.

AreaPond = [];
AreaIce = [];
w=-1:0.01:1;
scale = 1500;
pondnumbers = [];
num=1;
pondnumbersarray=[];
areanumarray = [];
iceareaarray = [];
firstperclevels = [];
firstperclevelsarray = [];
NumPondswhenperc = [];
for count = 1:1:num
    %z=getSurface([0.1+count*0.1,0.1+count*0.1],0);
    %z=getSurface([0.3,0.3],0);
    pondnumbers = [];
    AreaPond= [];
    PerPond= [];
    AreaIce = [];
    level = getFirstPercLevel(z,0,0.001,4,0,10);
    firstperclevels = [firstperclevels level];
    wfind=(round(w,2)==round(level,2)); %index 
    in = find(wfind,1);
    for i=-1:0.01:1
        N = real(z <= i);
        [L,n]=bwlabel(N,4);
        pondnumbers = [pondnumbers n];
        s = sum(sum(real(z <= i)))/scale;
        AreaPond = [AreaPond s];
        pondnumbersarray=[];
        P = regionprops(N,'perimeter');
        P = struct2array(P)/scale;
        if isempty(P)
            P=0
        end
            PerPond = [PerPond P]
        
    end
    NumPondswhenperc = [NumPondswhenperc pondnumbers(in)];
    pondnumbersarray(count,:) = pondnumbers;
    index = round(level,2);
    areanumarray(count,:) = AreaPond;
end
figure;
hold on;
for ii = 1:num
plot(w,pondnumbersarray(ii,:));
end
legend('1', '2', '3','4','5','6','7','8')
hold off

figure;
hold on;
for ii = 1:num
plot(w,areanumarray(ii,:));
plot(w,(size(z,1)*size(z,2)/scale)-areanumarray(ii,:));
end
legend('1', '2', '3','4','5','6','7','8')
hold off
%plot(firstperclevels, '*');

%plot(firstperclevels,NumPondswhenperc, '.')


