function CKA = linear_CKA(X, Y)
    hisc = linear_HSIC(X, Y);
    hisc_X = linear_HSIC(X, X);
    hisc_Y = linear_HSIC(Y, Y);
    CKA = hisc / sqrt(hisc_X * hisc_Y);
end