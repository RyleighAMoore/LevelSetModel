clear; close all; 
xy = dlmread('C:\Users\Rylei\Desktop\nlinfitcode\Boundary.txt');
A = xy(:,1); 
P = xy(:,2); 
figure; 
subplot(1,2,2); plot(log(A),log(P),'ko')
[a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfitCourt(log(A),log(P),[0.5 0.7 7 1.5],1,0); 
