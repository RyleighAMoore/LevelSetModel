function graphHistogram(areaFracs, deltaX,p,bwlabelnum,numSurf,decRound)
hold on
figure
numBins = 1/deltaX;
for i=round(min(areaFracs)-deltaX,4):deltaX:round(max(areaFracs)+deltaX,4)
    x=sum(areaFracs == i);
    plotname= histogram(areaFracs,numBins);
end
xlabel('Area Fraction');
ylabel('Percolation Count');
title({"p=["+p(1)+","+p(2)+"], neighbor #= " + bwlabelnum + ", Surface count= " + numSurf+ "" ; "deltaX = " + deltaX+ ", rounding decimal = " + decRound + " digits"});
hold off
saveas(gca,strcat('graphs\Histogram_p', num2str(p(1)),'_', num2str(p(2)),'.jpg')) 

end