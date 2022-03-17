%z=getSurface([0.75,0.9],1);
%z = dlmread('C:\Users\Rylei\Documents\ResearchKen\MATLABCode\LevelSetModel\Surfaces\ry.csv',',');
%saddleMatrix = dlmread('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\ryNEW.csv',',');
%z = dlmread('.\Surfaces\realdataScaled.csv',',');
%saddleMatrix = dlmread('.\Surfaces\realdataScaledSaddles.csv',',');
z = dlmread('.\FittedSquareReallinear.csv',',');
saddleMatrix = dlmread('.\FittedSquareReallinearSaddles.csv',',');
%z = dlmread('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\2010GriddedFirstScaled.csv',',');
%saddleMatrix = dlmread('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\Real2010GriddedCleanedScaledSaddles.csv',',');
%z=z(301:800,1001:1500)
%saddleMatrix=saddleMatrix(301:800,1001:1500)
% z = dlmread('C:\Users\Rylei\Documents\ResearchKen\MATLABCode\LevelSetModel\Surfaces\ry.csv',',');
% saddleMatrix = dlmread('C:\Users\Rylei\Documents\ResearchKen\MATLABCode\LevelSetModel\Surfaces\rySaddles.csv',',');


Area = [];
Per = [];
PerM = [];
AreaB = [];
PerB = [];
SC = [];
J = [];
JB = [];
if(nnz(z==0)>0)
    print('Saddle Missed at exactly height 0')
end
sadNum = 0
SaddleList = []
stepsize =0.001 
percolated = 0
for j=-0.1:stepsize:1
   j
   currponds = z<j;
   [labeledCurrPonds,n] = bwlabel(currponds,4);
%    pondToFollowNumber = labeledCurrPonds(265,85); %ry.csv graph PAPER
%    pondToFollowNumber = labeledCurrPonds(7,79); % Real Data scaled PAPER
   pondToFollowNumber = labeledCurrPonds(5,34); % Real Data Gridded scaled PAPER
   pondToFollowNumber = labeledCurrPonds(15,120); % Real Data Gridded scaled PAPER
   if pondToFollowNumber ~=0
       test = 0
   end
   %pondToFollowNumber = labeledCurrPonds(5,476); % Real Data scaled
   %pondToFollowNumber = labeledCurrPonds(6,297); % Real Data scaled
   
   %pondToFollowNumber = labeledCurrPonds(101,252);

   indpond = (labeledCurrPonds == pondToFollowNumber);
   %%%%%%%%%%%%%%%%%%%%%%%%%% Find Saddles crossed by indpond
   tt = nonzeros((saddleMatrix.*z).*indpond);
   for t = 1: length(tt)
       if (tt(t) >= j-stepsize) && (tt(t) < j) && (percolated ==0) && (n>1)
           SaddleList = [SaddleList tt(t)];
       end
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   firstcol = indpond(:,1); 
   firstrow = indpond(1,:); 
   lastcol = indpond(:,size(indpond,2));
   lastrow = indpond(size(indpond,1),:);
   if(max(firstcol)==0 && max(firstrow)==0 && max(lastcol)==0 && max(lastrow)==0) % Not hitting boundary
       percolated = 0;
       scale_updown = 1;
       scale_leftright = 1;
       A = sum(sum(indpond))*scale_updown*scale_leftright;
       P = sum(sum(bwperim(indpond)));
       AA=indpond;
       perTotal = 0;
       [r, c]= size(AA);
       
       for row=1:1:r
           for col=1:1:c
               if AA(row,col)==1
                   [numZeros, rightleft, updown] = getSurroundingZeros(AA, row, col);
                   perTotal1 = perTotal + numZeros;
                   perTotal = perTotal + rightleft*scale_leftright + updown*scale_updown; %numZeros;
                   assert(perTotal1 == perTotal)
               end
           end
       end
       Area = [Area A];
       Per = [Per perTotal];
       PerM = [PerM];
       J = [J j];
       saddlestemp = ((saddleMatrix.*z).*indpond);
       saddlestemp(saddlestemp == 0) = NaN;
       saddlecount = sum(sum(saddlestemp <= j));
       SC = [SC saddlecount];
   else
       percolated = 1;
       AB = bwarea(indpond);
       PB = sum(sum(bwperim(indpond)));
       AreaB = [AreaB AB];
       PerB = [PerB PB];
       JB = [JB j];
   end
end

%%
figure 
hold on
set(gcf,'Position',[100 100 800 250])
%ylim([0,12])
yticks([0,3,6,9,12,15])

Area = Area
plot(J,Per.^2./(4*pi.*Area), '.k')
%plot(J,(4*pi.*Area)./Per.^2, '.k')
%plot(JB,PerB.^2./(4*pi.*AreaB), '.r')
%plot(J,SC, '*')
%title('Saddle Effects on Isoperimetric Quotient of Melt Pond Growth','fontsize',28)
set(get(gca,'ylabel'),'rotation',0 )
laby = ylabel('$\frac{P^2}{4\pi A}$','Interpreter','latex','fontsize',20)
laby.Position(1) = -.85; 
laby.Position(2) = 4.9; 
laby.Position(2) = 6; 
laby.Position(1) = -1.08; 

xlabel('Level Set Height','fontsize',16,'VerticalAlignment','top','HorizontalAlignment','center');
for j=1:1:size(SaddleList)
    line = vline(SaddleList,'k','')
    plot(line)
end
hold off

%%
% hold on
% loglog(Area*scale_leftright*scale_updown,Per, '.b')
% [m,n] = size(SC)
% for j=1:1:n-1
%     if SC(j) < SC(j+1)
%           j
%           loglog(Area(j), Per(j), '.r')
% %         line = vline(Area(j),'b','')
% %         loglog(line)
%     end
% end
% hold off
% 
% figure
% hold on
% plot(Area,Per.^2./(4*pi.*Area),'.') 
% %title('Area Vs. Isoperimetric Quotient','fontsize',18)
% %set(get(gca,'ylabel'),'rotation',0)
% %ylabel('$\frac{P^2}{4\pi A}   $','Interpreter','latex','fontsize',18)
% %xlabel('Area','fontsize',14)
% 
% hold off
% 
% %minimum = min(min(z));
% %[x,y]=find(z==minimum)