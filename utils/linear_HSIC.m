function HISC = linear_HSIC(X, Y)
    L_X = X' * X;
    L_Y = Y' * Y;
    
    Center_X = Centering(L_X);
    Center_Y = Centering(L_Y);
    HISC = sum(sum(Center_X .* Center_Y));
end

