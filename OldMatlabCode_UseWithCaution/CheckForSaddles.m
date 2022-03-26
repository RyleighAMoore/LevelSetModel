%z=getSurface([0.3,0.3],0);
firstperclevel = getFirstPercLevel(z,0,0.00001,4,2,20)
Early = (z <= -0.75);
Early2 = (z <= -0.5);
Early3 = (z <= -0.25);
Before = (z <= (firstperclevel-0.1));
AtPerc = (z <= firstperclevel);
After =(z <= firstperclevel+0.1);
After2 =(z <= 0.10);
After3 =(z <= 0.2);
After4 =(z <= 0.3);
%w = After - Before;

