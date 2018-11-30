figure
for i=1:1:1
    z=getSurface([rand(),rand()],0);
    [AreaArr, PerArr, AreaArrB, PerArrB]= test(z);
    for ii = 1:size(PerArr,2)
        %loglog(AreaArr(ii,:),PerArr(ii,:), '.k');
        %hold on;
        loglog(AreaArrB(ii,:),PerArrB(ii,:), '.r');
        hold on;
    end
end
hold off;