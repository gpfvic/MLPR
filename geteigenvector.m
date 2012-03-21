function [ mu, E, lambda, p ] = geteigenvector( x )
%PCA Summary of this function goes here
%   Detailed explanation goes here
    
    %compute the mean image dispatch
    mu = mean(x);
    %compute covariance matrix
    C = cov(x);
    %compute eigenvectors and eigenvalues
    [E, lambda] = eig(C);
    lambda = diag(lambda);
    %order lambda and E
    [lambda, permutation] = sort(lambda, 'descend');
    E = E(:, permutation);
    
    %cumulative variance explained
    p = cumsum(lambda) / sum(lambda);
    
    


end

