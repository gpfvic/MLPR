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