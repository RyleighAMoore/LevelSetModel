function [f]=getSurfaceFun(p,flag1)
%function RFS3_2D_ARm(p,flag1)
%  p_1, p_2 ~ 0.4 +- 0.1
% [z,Off,Coef]=RFS3_2D_ARm(p,flag1)
%
%   Creates a Fourier Surface with various properties.
%   Currently generating the surface using anisotropic
%   red noise as the cosine coefficients.
%
% Inputs:
%   p=[p_1,p_2]: Two dimensional vector of red noise constants, real numbers in the range [0,1)
%   flag1 =1 saves levelsets to 'levelset' folder in current path
%         =0 do not save levelsets (default)
%
%   More options are in the preamble of the code.
%
% Outputs:
%   z: Generated surface
%   Off: The matrix of phase angles used
%   Coef: The matrix of coefficients used


%Preamble

syms x y;

n = 20; %Resolution of cosine terms, gives 2n+1 x n+1 terms
r = 300; %Resolution of Surface
l = 100; %Number of levelsets


%Offset (or phase angle) matrix
% rng(1); 
Off=rand(2*n+1,n+1)*2*pi;
%Off=zeros(2*n+1,n+1);

%Red noise amplitude generator 2
s=1/n;
[coefn,coefm]=meshgrid(0:s:1,-1:s:1);

sig2 = 1;
Lh = sqrt(1./((1+p(1)^2-2*p(1)*cos(pi*coefn)).*(1+p(2)^2-2*p(2)*cos(pi*coefm))));
% Lh = Lh.*1./sqrt((1+p(3)^2-2*p(3)*cos(pi*sqrt(coefn.^2 + coefm.^2))).*(1+p(4)^2-2*p(4)*cos(pi*sqrt(coefn.^2 - coefm.^2)))); 
% Lh = Lh.*1./sqrt((1+p(3)^2-2*p(3)*cos(pi*sqrt(coefn.^2 + coefm.^2)))); 
Lh(n+1:2*n+1,1) = 0;
1; 
% %Red noise amplitude generator
% s=1/n;
% theta=110*pi/180;
% % minor=3.5; %minor axis length is 1/minor
% % major=1;
% [coefn,coefm]=meshgrid(0:s:1,-1:s:1);
% % iso=sqrt(minor*(coefn*cos(theta)+coefm*sin(theta)).^2+major*(coefn*sin(theta)-coefm*cos(theta)).^2);
% sig2 = 1;
% % Lh=sqrt(sig2.*(1./abs((1-p(1).*exp(-1i.*coefn*pi)).*(1-p(2).*exp(-1i.*coefm*pi)))));
% %
% % p(3) = p(1)*p(2); p(3) = 0.6; p(3) =0; 
% Lh=sqrt(sig2.*(1./abs(1 - p(1)*exp(-1i*pi*coefn) - p(2)*exp(-1i*pi*coefm) + p(3)*exp(-1i*pi.*(coefn+coefm)))));
% % show(Lh); axis equal;
% Lh(n+1:2*n+1,1) = 0; 
1; 

%%
% Lh=sqrt((1-p^2)./(1-2*p*cos(iso*pi)+p^2));  %+0.05*rand(size(coefn));

% figure(1)
% surf(coefn,coefm,Lh)
% view([65 40])
% axis equal
% axis tight

% %figure(2)
% Ell=iso+0.05;
% Ell(Ell>1.05)=0;
% Ell(Ell>0)=1;
% %surf(x,y,Ell)
%
% %figure(3)
% Coef=Lh.*Ell;
% Min=min(min(Lh));
% Max=max(max(Lh));
% surf(coefn,coefm,Coef)
% view([0,90])
% caxis([Min-0.05 Max])
% axis equal
% axis tight
%
%
% %Standardizing coefficient and offset matrix
%
% for m=(n+1:1:2*n+1)
%     Coef(m,1)=0;
%     Off(m,1)=0;
% end
[Cx,Cy]=meshgrid(0:1:n,-n:1:n);
[xbunch,ybunch]=meshgrid(1/r:1/r:1);


%Generating Surface
Coef = Lh;
F=Coef.*cos(2*pi*(Cx.*x+Cy.*y+Off));
f=sum(sum(F,2),1);

% fxx= diff(f,2,x)
% fyy= diff(f,2,y)
% fyx=diff(diff(f,1,y),1,x)
% fxy=diff(diff(f,1,x),1,y)
% 
% 
% secDTest = @(x,y) fxx*fyy-(fyx*fxy)
% secDTest(0,0)

clear z; 
z = zeros(r,r); 
for i = 1:size(Cx,1)
    for j = 1:size(Cx,2)
        % disp([i j]); 
        z = z + Coef(i,j)*cos(2*pi*(Cx(i,j).*xbunch + Cy(i,j).*ybunch + Off(i,j)));
    end
end

%Normalizing surface
h=z-(max(max(z))+min(min(z)))/2;
maxh=max(max(h));
g=h/(maxh+0.01);

z=g;

%%

1; 
% 

% 3D surface generation

% figure(4)
% hold on
% h=surf(pi*xbunch,pi*ybunch,g);
% set(h,'LineStyle','none')
% axis tight
% view([40,75])
% %saveas(surf(pi*xbunch,pi*ybunch,g),'surface.png','png');
% hold off


%levelset generation
if exist('flag1','var') && flag1==1
    mkdir('levelsets')
    for j=0:1:l
        levelset=ceil(g+1-2/l*j);
        saddles = FindSaddlePoints(z);
        sad3 = cat(3,saddles,zeros(r,r),zeros(r,r));
        %levelset=imfuse(levelset,sad3,'montage');
        
        imshow( levelset ); 
        hold on;
       % set(h, 'Visible', 'off');
        h = imagesc( sad3 ); % show the edge image
        set( h, 'AlphaData', .6); % .6 transparency
        colormap gray
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

        filename=sprintf('levelsets/levelset_%03d.png',j);
        saveas(h,filename)
    end
end

end