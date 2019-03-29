x = linspace(-1,1,1000);
mu = -0.32
sigma = .20
figure;
hold on;
%plot(w,pondnumbersarray./max(pondnumbersarray));
plot(w,pondnumbersarray./(0.01*sum(pondnumbersarray)));
plot(x, 1./(sqrt(2*pi)*sigma)*exp(-(1/2)*((x-mu)./sigma).^2))
%plot(x, 1-(3*tanh(-1.3*x-0.35)).^2)
legend('Ponds','Gaussian','d/dx tanh')
hold off;
