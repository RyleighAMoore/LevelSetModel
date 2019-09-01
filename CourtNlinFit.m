%xy = dlmread('xy.txt'); 
A = Area 
P = Per 
figure; 
subplot(1,2,2); plot(log(A),log(P),'ko')
%[a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfitCourt(log(A),log(P),[0.5 0.7 0.5 1.5],1,0); 
[a,xx,f,yhat,D,r2] = meltpond_fractalD_nlinfitCourt(log(A),log(P),[0.5 0.7 0.5 1.5],1,0); 
