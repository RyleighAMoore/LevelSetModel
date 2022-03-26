function finalList = FindSaddlePoints(Image)
    %Image = getSurface([0.5 0.2],1)
    %Image=[1 1 3; 4 2 4; 2 1 3]
    %Image=[1 1 3 1;4 2 4 2;2 1 2 1; 2 1 3 2];
    %Image=[1 1 3 1 1;1 4 2 4 2; 1 2 1 2 1; 1 2 1 3 2; 1 2 1 3 2];
    %Image = round(100*getSurface([0.5 0.2],1))
    %Image=[1 1 3 1;4 2 4 2;2 1 2 1; 2 1 3 2];
    
    [rows,cols]=size(Image)
    tl1 = zeros(size(Image,1),size(Image,2));
    for r=1:1:rows
        for c=2:1:cols-1
            if((Image(r,c)<Image(r,c+1)) && (Image(r,c)<Image(r,c-1)))
                tl1(r,c)=1;
            end
        end
    end
    
    tl2 = zeros(size(Image,1),size(Image,2));
    for c=1:1:cols
        for r=2:1:rows-1
            if((Image(r,c)>Image(r+1,c)) && (Image(r,c)>Image(r-1,c)))
                tl2(r,c)=1;
            end
        end
    end        
 tl3 = zeros(size(Image,1),size(Image,2));
    for r=1:1:rows
        for c=2:1:cols-1
            if((Image(r,c)>Image(r,c+1)) && (Image(r,c)>Image(r,c-1)))
                tl3(r,c)=1;
            end
        end
    end
    
  tl4 = zeros(size(Image,1),size(Image,2));
    for c=1:1:cols
        for r=2:1:rows-1
            if((Image(r,c)<Image(r+1,c)) && (Image(r,c)<Image(r-1,c)))
                tl4(r,c)=1;
            end
        end
    end  
    
    one = tl1.*tl2; %multiply elem by elem
    two = tl3.*tl4;
    
    finalList= one + two;
%     temp1=ones(size(finalList,1),size(finalList,2))
%     temp1(finalList==1)= 0; %change ones to 2
%     finalList=temp1;
end
        
        