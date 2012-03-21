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
%6.7499