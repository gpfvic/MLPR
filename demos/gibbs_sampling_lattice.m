stateim=(rand(10,10)>0.5);

figure(1)
image(stateim);
colormap([1 0 0;0 0 1]);
%set(gcf,'Renderer','zbuffer');

for perm=1:10000
i=floor(rand*9.9999999);
j=floor(rand*9.9999999);

ip=mod(i+1,10);
im=mod(i-1,10);

jp=mod(j+1,10);
jm=mod(j-1,10);

imsum=stateim(ip+1,j+1)+stateim(im+1,j+1)+stateim(i+1,jm+1)+stateim(i+1,jp+1);
imsum=imsum+stateim(ip+1,jp+1)+stateim(im+1,jp+1)+stateim(ip+1,jm+1)+stateim(ip+1,jm+1);

pplus=exp(imsum);
pminus=exp(8-imsum);

r=rand;

s=(r>(pminus./(pminus+pplus)));

stateim(i+1,j+1)=s;
image(stateim)

pause(0.001);
end