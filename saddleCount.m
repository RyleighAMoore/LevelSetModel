






zsad = csvread('foo.csv')
% minx= min(min(topo))
% maxx = max(max(topo))
% toposcale=ones(size(topo))
% for idx = 1:numel(topo)
%     element = topo(idx);
%     topo2(idx) = 2*((element-minx)/(maxx-minx))-1;
% end
% topo2= reshape(topo2, size(topo))
%perclevel = getFirstPercLevel(topo2,0,0.000001,4,0,100);
count= [0];
w = -1:0.01:1;
for i=-1:0.01:1
    saddleHeights = zsad.*topo2;
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



