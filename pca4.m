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
%15.6090


