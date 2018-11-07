function testPlots()
AllPc=[];
stepSize = 0.3;
[one,two] = meshgrid(0:stepSize:0.99,0:stepSize:0.99);
for p1 = 0:stepSize:0.99
    CurrCol=[];
   for p2 = 0:stepSize:0.99
       Pc = MainCode(2,4,1,[p1,p2]);
       delete(findall(0,'Type','figure'));
       CurrCol=[CurrCol Pc]
   end 
   AllPc=[AllPc; CurrCol];
end
AllPc=AllPc';
figure
hold on
surf(one, two, AllPc);
savefig("pcplane.fig")
xlabel('p1');
ylabel('p2');
zlabel('Pc');
hold off
end
