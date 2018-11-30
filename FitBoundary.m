z=getSurface([0.3,0.3],1);
[allArea, allPer, AreaList, PerList, AreaListB, PerListB] = getPondPerArea(z);
%[a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfit(log(allArea),log(allPer),[3 -2*pi 3, 3, 3],1,1)
mdl = @(a,x) log(cosh(a(2)+a(1)+x))/(4*a(1)) + 3*x/4+a(3);
[a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfit(log(allArea)/1000,log(allPer)/1000,[3 -2*pi 3, 3, 3],1,0)
%     x: vector of log(area)
%     y: vector of log(perimeter)
%     a0 = [a1 a2 a3] vector of initial guesses at parameters
%          [3 -2*pi 1] is reasonable for Hohenegger et al. (2012)
%     flag: 1 makes plot, 0 does not plot