function [output] = ReluInverse(input, alpha)
alpha = 1;
output=zeros(size(input,1),size(input,2));
for i=1:size(input,1)
    for j=1:size(input,2)
        if input(i,j)>0
            output(i,j)=alpha * input(i,j);
        else 
            output(i,j)=0;
        end 
    end
end

