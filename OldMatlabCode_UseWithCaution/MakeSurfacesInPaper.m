x = linspace(-1,1,100)
y = linspace(-1,1,100)
matrix =meshgrid(x,y)
saddle = zeros(10,10)
for i=1:1:size(x,2)
    for j=1:1:size(y,2)
        val = x(i)^2-y(j)^2;
        saddle(i,j)=val;
    end
end
max = []
for i=1:1:size(x,2)
    for j=1:1:size(y,2)
        val = -x(i)^2;
        max(i,j)=val;
    end
end

torus = [];
for i=1:1:size(x,2)
    for j=1:1:size(y,2)
        val = sqrt(5-(0.5-sqrt(x(i).^2+y(j).^2)).^2);
        torus(i,j)=val;
    end
end

torus
