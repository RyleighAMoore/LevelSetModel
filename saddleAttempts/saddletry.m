    Image = getSurface([0.5 0.2],1)
    %Image=[1 1 3; 4 2 4; 2 1 3]
    Image=[1 1 3 1;4 2 4 2;2 1 2 1; 2 1 3 2];
    Image=[1 1 3 1 1;1 4 2 4 2; 1 2 1 2 1; 1 2 1 3 2; 1 2 1 3 2];
    Image = round(100*getSurface([0.5 0.2],1))
    Image=[1 1 3 1;4 2 4 2;2 1 2 1; 2 1 3 2];
    
imageLeft = circshift(Image, [0,-1]);
imageRight = circshift(Image, [0,1]);
imageUp = circshift(Image, [1,0]);
imageDown = circshift(Image, [-1,0]);

minusLeft = Image - imageLeft; 
minusRight = Image - imageRight;
minRow = max(0,minusLeft.*minusRight); %all non-zero values are minimums
minRow = minRow ~= 0; %minimums are 1s

minusUp = Image - imageUp;
minusDown = Image - imageDown;
minCol = max(0,minusUp.*minusDown); %all non-zero values are minimums
minCol = minCol ~= 0; %minimums are 1s

maxRow = min(0,minusLeft.*minusRight);
maxRow = maxRow ~=0; %maxes are 1s

maxCol = min(0,minusUp.*minusDown);
maxCol = maxCol ~=0; %maxes are 1s

finalList = minRow.*maxCol + maxRow.*minCol;

    
        
        