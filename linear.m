clear all;

load imdata.mat;
x=double(x);
y=double(y);
num = size(x,1);
train_data = [ x(:,end), x(:,end-34), x(:,end-35), ones(num,1), y];
[beta sigma] = mvregress(train_data(:,1:4), train_data(:,5));

load imtestdata.mat;
x=double(x);
num = size(x,1);
test_data = [ x(:,end), x(:,end-34), x(:,end-35), ones(num,1) ];
p_y = zeros(num,64);
for i=1:num
    for y=0:63
        p_y(i,y+1) =  exp( -(y - test_data(i,1:4)*beta)^2 / (2*sigma) ) / sqrt(2*pi*sigma) ;
    end
end

csvwrite('linear.csv',p_y);
