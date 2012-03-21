clear all;
load imdata.mat;
x=double(x);
y=double(y);

mu = mean(x,1);
%compute covariance matrix
C = cov(x);
%compute eigenvectors and eigenvalues
[E, lambda] = eig(C);
lambda = diag(lambda);
%order lambda and E
[lambda, permutation] = sort(lambda, 'descend');
E = E(:, permutation);

%stores the projection
pca10d = zeros(100000, 10);


%sotres the projected images
x_pca10d = zeros(size(x));
for i=1:100000
    x_pca10d(i,:) = mu;
    for j=1:10
        x_pca10d(i,:) = x_pca10d(i,:) + (x(i,:)-mu)*E(:, j)*E(:,j)';
    end
end

num = size(x_pca10d,1);
data = [ x_pca10d(:,end), x_pca10d(:,end-34), x_pca10d(:,end-35), ones(num,1), y];

[beta sigma] = mvregress(data(:,1:4), data(:,5));


%test
load imtestdata.mat;
x = double(x);
num = size(x,1);
test_data = [x(:,end),x(:,end-34),x(:,end-35),ones(num,1)];


p_y = zeros(num,64);
for i=1:num
    for y=0:63
        p_y(i,y+1) =  -log( exp( -(y - test_data(i,1:4)*beta)^2 / (2*sigma) ) / sqrt(2*pi*sigma) );
    end
end

csvwrite('pca.csv',p_y);






