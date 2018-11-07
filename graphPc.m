function Pc = graphPc(deltaX,p,PAall,NPAall,bwlabelnum,numSurf,decRound)
hold on
xx=[];
yy=[];

for i=0:deltaX:1
    x=sum(round(PAall,2) == i);
    y=sum(round(NPAall,2) == i);
    percentage = x/(x+y);
    pn=plot(i,percentage,'o');
    
    xx=[xx i];
    yy=[yy percentage];
end
[sortedY, sortIndex] = sort(yy)
sortedX = xx(sortIndex)
[row,col] = find(sortedY,1);
Pc=sortedX(col-1);

%f=fit(xx',yy','poly2');
%plot(f);
xlabel('Area Fraction');
ylabel('% Percolation');
title({"Pc=" + Pc + "p=["+p(1)+","+p(2)+"], neighbor #= " + bwlabelnum + ", Surface count= " + numSurf+ "" ; "deltaX = " + deltaX+ ", rounding decimal = " + decRound + " digits"})
saveas(gca,strcat('graphs\Pc',num2str(Pc),'PcGraph_p', num2str(p(1)),'_', num2str(p(2)),'.jpg')) 

hold off

end