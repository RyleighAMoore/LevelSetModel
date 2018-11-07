
syms x y
f=((x^2-1)+(y^2-4)+(x^2-1)*(y^2-4))/(x^2+y^2+1)^2
f=getSurfaceFun([0.2,0.5],1)

fx=diff(f,x)
fy=diff(f,y)
[xcr,ycr]=solve(fx,fy); [xcr,ycr]
fxx=diff(fx,x)
fxy=diff(fx,y)
fyy=diff(fy,y)
%hessdetf=fxx*fyy-fxy^2
gradf = jacobian(f, [x, y])
hessmatf = jacobian(gradf, [x, y])

xcr = xcr(1:3); ycr = ycr(1:3);
for k = 1:3
    [xcr(k), ycr(k), subs(hessdetf, [x,y], [xcr(k), ycr(k)]), ...
       subs(fxx, [x,y], [xcr(k), ycr(k)])]
end