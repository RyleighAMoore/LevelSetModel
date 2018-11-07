function indices = saddle()
indices=[];
M = round(getSurface([0.5,0.4]),2);

[m,n]=size(M);
for i=1:n
    for j=1:m
        a=min(M(:,i));  %minimum element in a column
        b=max(M(j,:));  %maximum element in a row
        if M(j,i)==a && a==b 
            indices=[indices;j i];
        end
    end
end

    
 