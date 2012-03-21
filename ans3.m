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