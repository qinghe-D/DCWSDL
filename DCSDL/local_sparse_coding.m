function [X, X0] = local_sparse_coding(Y, D, D0, m0, lambda1, lambda2)
    N      = size(Y,2);
    k      = size(D,2);
    k0     = size(D0,2);
    X1init = zeros(k + k0, N);
    D1     = [D D0];
    M0     = repmat(m0, 1, N);
    D1tD1  = D1'*D1;
    D1tY   = D1'*Y;
    %% cost
    function cost = calc_F(X1)
        X = X1(1: k, :);
        X0 = X1(k+1:end,:);
        cost =  0.5*normF2(Y - D1*X1) + ...
                0.5*lambda2*normF2(X0 - M0) + ...
                lambda1*norm1(X1);
    end 
    %% grad
    function g = grad(X1)
        X  = X1(1: k, :);
        X0 = X1(k+1:end,:);
        g  = (D1tD1*X1 - D1tY + lambda2*(D1tD1*X1 - D1'*M0));
    end     
    %% ========= Main FISTA ==============================
    L             = max(eig(D1tD1)) + 2;
    opts.tol      = 1e-8;
    opts.max_iter = 300;
    [X1, ~]       = fista(@grad, X1init, L, lambda1, opts, @calc_F);  
    X             = X1(1: k, :);
    X0            = X1(k+1:end,:);
end 