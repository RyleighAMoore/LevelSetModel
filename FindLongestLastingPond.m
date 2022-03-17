%z=getSurface([0.75,0.9],1);
%z = dlmread('C:\Users\Rylei\Documents\ResearchKen\MATLABCode\LevelSetModel\Surfaces\ry.csv',',');
%saddleMatrix = dlmread('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\ryNEW.csv',',');
z = dlmread('.\FittedSquareReallinear.csv',',');
saddleMatrix = dlmread('.\FittedSquareReallinearSaddles.csv',',');
%z = dlmread('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\2010GriddedFirstScaled.csv',',');
%saddleMatrix = dlmread('C:\Users\Rylei\MATLAB\Projects\GitLevelSetModel\Surfaces\Real2010GriddedCleanedScaledSaddles.csv',',');
%z=z(301:800,1001:1500)
%saddleMatrix=saddleMatrix(301:800,1001:1500)
%z = dlmread('C:\Users\Rylei\Documents\ResearchKen\MATLABCode\LevelSetModel\Surfaces\ry.csv',',');
%saddleMatrix = dlmread('C:\Users\Rylei\Documents\ResearchKen\MATLABCode\LevelSetModel\Surfaces\rySaddles.csv',',');


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
stepsize = 0.01
percolated = 0
count = zeros(size(z));
for one= 1:1:size(z,1)
    one
    for two = 1:1:size(z,2)
        for j=-1:stepsize:1
           currponds = z<j;
           [labeledCurrPonds,n] = bwlabel(currponds,4);
           pondToFollowNumber = labeledCurrPonds(one,two); 

           indpond = (labeledCurrPonds == pondToFollowNumber);
           
           firstcol = indpond(:,1); 
           firstrow = indpond(1,:); 
           lastcol = indpond(:,size(indpond,2));
           lastrow = indpond(size(indpond,1),:);
           if(max(firstcol)==0 && max(firstrow)==0 && max(lastcol)==0 && max(lastrow)==0) % Not hitting boundary
                count(one, two) = count(one, two)+1;
           end
        end
    end
end