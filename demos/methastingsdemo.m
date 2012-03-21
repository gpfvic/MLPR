siglist=[4 1 0.1 100];

for runnumber=1:4
siglist(runnumber)
pause
close all

% This demo shows how the Metropolis-Hastings algorithm can be used to
% sample from a mixture of 2 Gaussians if we can sample from a Gaussian proposal. 


% DEFINITIONS:
% ===========

N = 6000;                        % Number of iterations (samples).
sigma = 2;                       % Standard deviation of the target components.
x = zeros(N,1);                  % Markov chain (unknowns).
sigma_prop = siglist(runnumber);                 % Standard deviation of the Gaussian proposal.
N_bins = 50;                     % Number of bins in the histogram.


figure(1)
x_t = linspace(-10,20,1000);
y_t = 0.3*exp(-.5 * x_t.^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*(x_t-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
yprop=exp(-.5 * x_t.^2 / sigma_prop^2)/(sqrt(2*pi)*sigma_prop)
plot(x_t,y_t,'k','linewidth',2)
hold on
plot(x_t,yprop,'r','linewidth',2)

%axis([-10 20 0 .15])
%text(14,.1,'i=100');


% INITIALISE THE CHAIN:
% =====================

x(1,1) = 60;


% ITERATE THE CHAIN:
% =================

for i=2:N
  % METROPOLIS:
  % ==========
  u = rand(1,1);
  z = sigma_prop * randn(1,1);
  alpha1 = 0.3*exp(-.5 * (x(i-1)+z).^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*((x(i-1)+z)-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
  alpha2 = 0.3*exp(-.5 * (x(i-1)).^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*((x(i-1))-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
  alpha = alpha1/alpha2;
  if(u<alpha)
    x(i) = x(i-1) + z;
    accrej(i)=1;
  else
    x(i) = x(i-1);
    accrej(i)=0;
  end
end

figure(2)
ss=find(accrej==0);
plot(x,'b.');
hold on
plot(ss,x(ss),'r.');
hold off
figure(3)
ss=find(accrej==0);
plot(x(1:400),'b-');

figure(4)
ss=find(accrej==0);
plot(x(5500:6000),'b-');



% PLOT THE HISTOGRAMS:
% ===================

x=x(1001:end);
N=N-1000;

i1=100;
i2=500;
i3=1000;
i4=N;
i=-10;
j=20;
I = j-i;

figure(5)
clf;
subplot(2,2,1)
x_t = linspace(-10,20,1000);
y_t = 0.3*exp(-.5 * x_t.^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*(x_t-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
[b,a] = hist(x(1:i1), N_bins);
measure = a(2)-a(1); % bin width.
area = sum(b*measure);
bar(a,b/(area),'y')
hold on;
plot(x_t,y_t,'k','linewidth',2)
axis([-10 20 0 .15])
text(14,.1,'i=100');

subplot(2,2,2)
x_t = linspace(-10,20,1000);
y_t = 0.3*exp(-.5 * x_t.^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*(x_t-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
[b,a] = hist(x(1:i2), N_bins);
measure = a(2)-a(1); % bin width.
area = sum(b*measure);
bar(a,b/(area),'y')
hold on;
plot(x_t,y_t,'k','linewidth',2)
axis([-10 20 0 .15])
text(14,.1,'i=500');

subplot(2,2,3)
x_t = linspace(-10,20,1000);
y_t = 0.3*exp(-.5 * x_t.^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*(x_t-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
[b,a] = hist(x(1:i3), N_bins);
measure = a(2)-a(1); % bin width.
area = sum(b*measure);
bar(a,b/(area),'y')
hold on;
plot(x_t,y_t,'k','linewidth',2)
axis([-10 20 0 .15])
text(14,.1,'i=1000');

subplot(2,2,4)
x_t = linspace(-10,20,1000);
y_t = 0.3*exp(-.5 * x_t.^2 / sigma^2)/(sqrt(2*pi)*sigma) + 0.7*exp(-.5*(x_t-10).^2/sigma^2)/(sqrt(2*pi)*sigma);
[b,a] = hist(x(1:i4), N_bins);
measure = a(2)-a(1); % bin width.
area = sum(b*measure);
bar(a,b/(area),'y')
hold on;
plot(x_t,y_t,'k','linewidth',2)
axis([-10 20 0 .15])
text(14,.1,'i=5000');





end
