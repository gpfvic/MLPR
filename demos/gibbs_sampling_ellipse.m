C=[1 0.98; 0.98 1];
Ci=inv(C);
m=[0 0];
clf;

x=[-2 2];

plot_gaussian(3*C,m,2,60);
set(gcf,'Renderer','zbuffer');
pause;
 


for i=1:200,
axis([-3 3 -3 3]);
xold=x;
x(1) = -Ci(1,2)*x(2)/Ci(1,1) + randn./sqrt(Ci(1,1));
plot([xold(1) x(1)],[xold(2) x(2)],'.-');
hold on;
xold=x;
x(2) = -Ci(1,2)*x(1)/Ci(2,2) + randn./sqrt(Ci(2,2));
plot([xold(1) x(1)],[xold(2) x(2)],'.-');
% plot(x(1),x(2),'.');
drawnow;
pause(0.4);
% clf;
end;
     
