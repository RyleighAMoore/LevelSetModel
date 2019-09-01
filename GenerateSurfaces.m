ListPercVals = []
for i= 1:1:50
    i
    z=getSurface([0.5,0.5],0);
    perclevel = getFirstPercLevel(z,0,0.000001,8,0,100);
    filename = sprintf('C:\\Users\\Rylei\\MATLAB\\Projects\\GitLevelSetModel\\PercVals\\05_05\\Surf_%d_Perc_%d.csv', i, perclevel);
    csvwrite(filename, z);
    ListPercVals=[ListPercVals perclevel]
end
csvwrite('C:\\Users\\Rylei\\MATLAB\\Projects\\GitLevelSetModel\\PercVals\\05_05\\PercVals05_05', ListPercVals);