clear all;
load imdata.mat;
x = double(x);
y = double(y);

%2-a
%compute the mean image dispatch
mu = mean(x,1);
%compute covariance matrix
C = cov(x);
%compute eigenvectors and eigenvalues
[E, lambda] = eig(C);
lambda = diag(lambda);
%order lambda and E
[lambda, permutation] = sort(lambda, 'descend');
E = E(:, permutation);


imagesc(reshape([mean(x,1) zeros(1,18)],35,30)');
figure;
imagesc(reshape([E(:,1)' zeros(1,18)],35,30)');
figure;
imagesc(reshape([E(:,2)' zeros(1,18)],35,30)');
figure;
imagesc(reshape([E(:,3)' zeros(1,18)],35,30)');



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

