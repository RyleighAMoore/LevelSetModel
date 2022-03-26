figure
hold on
[M,N] = size(indpond);
indpondzeros = zeros(M, N);
indAll = [];
indAll(:,:,3) = indpond;
indAll(:,:,2) = indpondzeros;
indAll(:,:,1) = indpondzeros+ saddleMatrix;

t = indAll(200:400,30:166,:)
imshow(t)
hold off