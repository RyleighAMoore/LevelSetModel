zsad = csvread('foo.csv')
count= [0];
w = -1:0.01:1;
for i=-1:0.01:1
    saddleHeights = zsad.*z;
    v = (saddleHeights <= i & saddleHeights ~=0);
    sum1 = nnz(v);
    count = [count sum1];
end
figure;
hold on
y = linspace(0,1,100)
x= ones(size(y))
plot(perclevel*x, y)
plot(w,count(2:end)/nnz(zsad), '.')
plot(w,AreaPond/max(AreaPond), '.')
plot(w, perTotal/max(perTotal), '.')
legend('PercThresh', 'saddles', 'Area', 'Perimeter')
xlabel('Level Set height')
ylabel('Scaled # saddle points below surface/ Scaled perimeter/ Sclaed Area')



