function [a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfit(x,y,a0,flag,subsamp)
% [a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfit(x,y,a0,flag,subsamp)
%
%   Assumes user has statistics toolbox available 
%
%   Fits a function f to area-perimeter data using parameters a1,a2,a3
%
%           log(cosh(a2 + a1 x))     3x
%   f(x) =  --------------------  + ---- + a3
%               4 a1                  4
%
%  Inputs:
%     x: vector of log(area)
%     y: vector of log(perimeter)
%     a0 = [a1 a2 a3] vector of initial guesses at parameters
%          [3 -2*pi 1] is reasonable for Hohenegger et al. (2012)
%     flag: 1 makes plot, 0 does not plot
%
%  Outputs:
%     a = [a1 a2 a3] are optimzed model parameters
%     f is the model evaluated at evenly spaced values xx (for plotting)
%     yhat is the model evaluated at the input x values 
%     D is the fractal dimension evaluated
%       at xx (i.e., twice the derivative of f)
%     res is the vector of residuals (y-f)
%     r2 is the fraction of variance accounted for by model 
%
%   Court Strong; last modified 25 April 2013
%   http://www.inscc.utah.edu/~strong/
%   court.strong@utah.edu
%% subsample data
np = 1000; 
if subsamp
    dat = NaN(np,2);
    sls = linspace(min(x),max(x),np);
    for i = 1:length(sls)
        sl = sls(i);
        lk = abs(x-sl);
        d = find(lk==min(lk)); d = d(1);
        % xk(i) = x(d);
        % yk(i) = y(d);
        dat(i,:) = [x(d) y(d)];
    end
else
    dat = [x(:) y(:)];
end
x = dat(:,1);
y = dat(:,2);

x = x(:);
y = y(:);
a0(end+1) = 0.3; 
% find parameters that minimize the model-data misfit
mdl = @(a,x)(0.25/a(1)*log(cosh(a(1)*x+a(2)))+0.75*x + a(3)); 
% mdl = @(a,x)(0.5* (a(1)/a(2) * log(cosh(a(2)*x + a(3))) + a(4)*x) + a(5)); 
mdl =   @(a,x)(0.5* (a(1)/a(2) * log(cosh(a(2)*(x - a(3)))) + a(4)*x) + a(5)); % brady 28 Aug 2014 
%mdl = @(a,x) log(cosh(a(2)+a(1)+x))/(4*a(1)) + 3*x/4+a(3);
[a,res] = nlinfit(x,y,mdl,a0);
%[a,res] = nlinfit(x,y,mdl,a0,statset('display','off','funvalcheck','off','maxiter',500));

if a(1)<0
    a(1) = -a(1); 
    a(2) = -a(2); 
end

% if user calls for more than the parameters 
if nargout>1
  xmin = min(x);
  xmax = max(x);
  dx = xmax - xmin;
  x1 = xmin-0.05*dx;
  x2 = xmax+0.05*dx;

  xx = linspace(x1,x2,300);
  f = mdl(a,xx);
  D = f_slope(a,xx); 
  yhat = mdl(a,x); 
end;

r2 = corr(y,yhat).^2; 

% plot if flag is true
if flag 
  clf; subplot(2,1,1); plot(x,y,'b.','markersize',3);
  hold on; plot(xx,f,'r-','linewidth',1.5);
  set(gca,'xlim',[x1 x2],'plotboxaspectratio',[1.5 1 1]);
  xlabel('log A'); ylabel('log P');
  subplot(2,1,2);
  plot(xx,f_slope(a,xx),'linewidth',1.5);
  xlabel('log A'); ylabel('D');
  set(gca,'xlim',[0 4],'ylim',[1 2],'plotboxaspectratio',[1.5 1 1]);
end;

function D = f_slope(a,x)
% fractal dimension is twice the derivative of f:
%   D = 2*f' =  0.5*tahn(a1*x + b) + 1.5
% D = 0.5*tanh(a(1).*x + a(2)) + 1.5;
% D = a(1)*tanh(a(2)*x + a(3)) + a(4);
D =  a(1)*tanh(a(2)*(x - a(3))) + a(4); % brady 28 Aug 2014 
