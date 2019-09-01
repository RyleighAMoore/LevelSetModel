x = linspace(-1,1,10)
y = linspace(-1,1,10)
saddle = zeros(10,10);
for i=1:1:size(x,2)
    for j=1:1:size(y,2)
        val = 20*(x(i)^2-y(j)^2);
        saddle(i,j)=val;
    end
end
