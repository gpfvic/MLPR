echo on

load train200.txt
load test10000.txt
size(train200)
std(train200)
pause
net=gp(10,'sqexp');
options=foptions;
options(1)=1;

net.min_noise=1e-3;
net.noise=10;
net=netopt(net,options,train200(:,1:10),train200(:,11),'scg');
pause
net=gpinit(net,train200(:,1:10),train200(:,11));
[y,sigsq]=gpfwd(net,test10000(:,1:10));
pause;

plot(test10000(:,11),'r.');
hold on
plot(test10000(:,11)-y,'b.');
plot(3*sqrt(sigsq),'g.');
hold off