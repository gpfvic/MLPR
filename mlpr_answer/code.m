clear all;
load imdata.mat;
x = double(x);
y = double(y);

%2-a
mu = mean(x,1);
C = cov(x);
[E, lambda] = eig(C);
lambda = diag(lambda);
[lambda, permutation] = sort(lambda, 'descend');
E = E(:, permutation);

figure; image(reshape([mean(x,1) zeros(1,18)],35,30)');
figure; image(reshape([E(:,1)' zeros(1,18)],35,30)');
figure; image(reshape([E(:,2)' zeros(1,18)],35,30)');
figure; image(reshape([E(:,3)' zeros(1,18)],35,30)');
 
figure; imagesc(reshape([mean(x,1) zeros(1,18)],35,30)');
figure; imagesc(reshape([E(:,1)' zeros(1,18)],35,30)');
figure; imagesc(reshape([E(:,2)' zeros(1,18)],35,30)');
figure; imagesc(reshape([E(:,3)' zeros(1,18)],35,30)');


%2-b

%stores the projection
pca3d = zeros(100000, 3);
for i=1:100000
    %create the projection
    for j=1:3
        pca3d(i, j) = (x(i,:) -mu) * E(:, j);
    end
end
%sotres the projected images
x_pca3d = zeros(size(x));

for i=1:100000
    x_pca3d(i,:) = mu + pca3d(i,1)*E(:,1)' + pca3d(i,2)*E(:,2)' + pca3d(i,3)*E(:,3)';
end

MSE = zeros(100000,1);
for i=1:100000
    MSE(i) = sum( (x(i,:)-x_pca3d(i,:) ).^2);
end

%find the image worst represented by the 3d principal subspace
[c index] = max(MSE);
%index = 34729
image(reshape([x(index,:) zeros(1,18)],35,30)');
figure;
image(reshape([x_pca3d(index,:) zeros(1,18)],35,30)');



%2-c
figure;hist(y,64);



%2-d
diff = zeros(size(y));
diff = y - x(:,end);
hist(diff,-64:64);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%3-b-i

clear all;
load imdata.mat;

x=double(x);
y=double(y);

data = [x(:,end) x(:,end-34) x(:,end-35) y];

L=0;
for i=1:4
    if i<4
        train_data = data([1:25000*(i-1),(25000*i+1):end],:);
        test_data = data(25000*(i-1)+1 : 25000*i, :);
    elseif i==4
        train_data = data(1:75000,:);
        test_data = data(75001:end,:);
    end
    %train
    [py p1 p2 p3]  = naivebayes(train_data);
    %test  
    for i=1:25000
       x1 = test_data(i,1) + 1; 
       x2 = test_data(i,2) + 1; 
       x3 = test_data(i,3) + 1; 
       sum = 0;
       for j=1:64
           pt(i,j) =   py(j) * p1(x1,j) * p2(x2,j) * p3(x3,j)  ;
           sum = sum + pt(i,j);
       end
       pt(i,:) = pt(i,:) / sum;
    end

    for i=1:25000
        y = test_data(i,4) + 1;
        L = L -log( pt(i,y) );
    end
end

perplexity = exp(L/100000);


% naive bayes function

 function [py p1 p2 p3] = naivebayes(data)

    num = size(data,1);    
    cat_y = zeros(64,1);% y categories number
    py = zeros(64,1);
    p1 = zeros(64,64);
    p2 = zeros(64,64);
    p3 = zeros(64,64);
    for i=1:num
        x1 = data(i,1) + 1;
        x2 = data(i,2) + 1;
        x3 = data(i,3) + 1;
        y  = data(i,4) + 1;
        
        cat_y(y) = cat_y(y) + 1;
        p1(x1,y) = p1(x1,y) + 1;
        p2(x2,y) = p2(x2,y) + 1;
        p3(x3,y) = p3(x3,y) + 1;
    end
    for i=1:64
        p1(:,i) = (p1(:,i)+1) / (cat_y(i)+64); %dirichilet distribution
        p2(:,i) = (p2(:,i)+1) / (cat_y(i)+64); %dirichilet distribution
        p3(:,i) = (p3(:,i)+1) / (cat_y(i)+64); %dirichilet distribution
        py(i)   = cat_y(i)   / num;
    end
 end
 
 
 
 %3-b-ii
 
bar(pt(1,:));   % pt, is the prediction table containing probabilities
bar(pt(7799,:));
bar(pt(11111,:));
bar(pt(22222,:));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 %4-a linear regression
 
clear all;
load imdata.mat;
x=double(x);
y=double(y);

num = size(x,1);
data = [ x(:,end), x(:,end-34), x(:,end-35), ones(num,1), y];
L=0;
for i=1:4
    if i<4
        train_data = data([1:25000*(i-1),(25000*i+1):end],:);
        test_data = data(25000*(i-1)+1 : 25000*i, :);
    elseif i==4
        train_data = data(1:75000,:);
        test_data = data(75001:end,:);
    end
    
    [beta sigma] = mvregress(train_data(:,1:4), train_data(:,5));
                 
    p_y = zeros(25000,64);
    for i=1:25000
        for y=0:63
            p_y(i,y+1) =  exp( -(y - test_data(i,1:4)*beta)^2 / (2*sigma) ) / sqrt(2*pi*sigma) ;
        end
    end

    for i=1:25000
        y = test_data(i,5);
        L = L - log(p_y(i,y+1));
    end
end
perplexity = exp(L/100000);


% 4-b PCA on LR

clear all;
load imdata.mat;
x=double(x);
y=double(y);

L = 0;
for i=1:4
    if i<4
        train_data = x([1:25000*(i-1),(25000*i+1):end],:);
        train_y = y([1:25000*(i-1),(25000*i+1):end]);
        test_data = x(25000*(i-1)+1 : 25000*i, :);
        test_y = y(25000*(i-1)+1 : 25000*i);
    elseif i==4
        train_data = x(1:75000,:);
        train_y = y(1:75000);
        test_data = x(75001:end,:);
        test_y = y(75001:end);
    end
    
    mu = mean(train_data,1);
    C = cov(train_data);
    [E, lambda] = eig(C);
    lambda = diag(lambda);
    [lambda, permutation] = sort(lambda, 'descend');
    E = E(:, permutation);
    train_pca10d = ones(75000, 11);
    for i=1:75000
        for j=1:10
            train_pca10d(i,j) = (train_data(i,:)-mu) * E(:,j);
        end
    end
    [beta sigma] = mvregress(train_pca10d, train_y);
    
    test_pca10d = ones(25000,11);
    for i=1:25000
        for j=1:10
            test_pca10d(i,j) = (test_data(i,:)-mu) * E(:,j);
        end
    end

    p_y = zeros(25000,64);
    for i=1:25000
        sum = 0;
        for yi=0:63
            p_y(i,yi+1) =  exp( -(yi - test_pca10d(i,:)*beta)^2 / (2*sigma) ) / sqrt(2*pi*sigma) ;
            sum = sum + p_y(i,yi+1);
        end
    end

    for i=1:25000
        yi = test_y(i);
        L = L - log(p_y(i,yi+1));
    end
end
perplexity = exp(L/100000);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%5 bayesian belief network

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
