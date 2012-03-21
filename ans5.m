clear all;
load imdata.mat;
x=double(x);
y=double(y);
train_data = [x(:,end) x(:,end-34) x(:,end-35) y];

%train
cat_x3 = zeros(64,1);% x3 categories number
cat_y = zeros(64,1);% y categories number
py = zeros(64,1);  % (y, x2, x1)
p3 = zeros(64,1) + 0.01; % x3
p1_3 = zeros(64,64) + 0.01;
p2_3 = zeros(64,64) + 0.01; % avoid zero probability problem
p1_y = zeros(64,64) + 0.01;
p2_y = zeros(64,64) + 0.01;

for i=1:100000
    x3 = train_data(i,1) + 1;
    x2 = train_data(i,2) + 1;
    x1 = train_data(i,3) + 1;
    y  = train_data(i,4) + 1;
    
    cat_y(y) = cat_y(y) + 1;
    cat_x3(x3) = cat_x3(x3) + 1;
    p2_3(x2,x3) = p2_3(x2,x3) + 1;
    p1_3(x1,x3) = p1_3(x1,x3) + 1;
    p1_y(x1,y) = p1_y(x1,y) + 1;
    p2_y(x2,y) = p2_y(x2,y) + 1;
    
end

for i=1:64
    p2_3(:,i) = p2_3(:,i) / cat_x3(i); %probability x2 given x3
    p1_3(:,i) = p1_3(:,i) / cat_x3(i);
    p3(i)     = cat_x3(i) / 100000; % probablity x3
    py(i)     = cat_y(i) / 100000;  % probability y
    p1_y(:,i) = p1_y(:,i)/ cat_y(i);  % probability x1 given y
    p2_y(:,i) = p2_y(:,i)/ cat_y(i);
end

%test
load imtestdata.mat;
x=double(x);
test_data = [x(:,end) x(:,end-34) x(:,end-35)];
pt = zeros(40000,64);
for i=1:40000
    x3 = test_data(i,1) + 1;
    x2 = test_data(i,2) + 1;
    x1 = test_data(i,3) + 1;
    denominator = 0;
    for j=1:64
        pt(i,j) = p1_y(x1,j) * p2_y(x2,j) * py(j);
        denominator = denominator + p1_3(x1,j)*p2_3(x2,j)*p3(j);
    end

    for j=1:64
        pt(i,j) = -log(pt(i,j) / denominator);
    end

end

csvwrite('belief.csv',pt);