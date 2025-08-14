function HISC = Centering(K)
    n = size(K, 1);
    unit = ones(n, n);
    I = eye(n);
    H = I - unit / n;

    HISC = (H * K) * H;
end