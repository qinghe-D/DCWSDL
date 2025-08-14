function [DP, DS, ZP, ZS] = DCSDL_norm_fast_init(X, X_range, DP_range, opts)
    nClasses = numel(X_range) - 1;
    DP        = zeros(size(X, 1), DP_range(end));

    %% ========= DP ZP ==============================
    for c = 1: nClasses
        Xc = get_block_col(X, c, X_range);
        DPc = PickDfromY(Xc, [0,size(Xc,2)], DP_range(c+1) - DP_range(c));
        %% ========= D ==============================
        col_range = DP_range(c) + 1 : DP_range(c+1);
        DP(:, col_range) = DPc;
    end
    
    ZP = pinv(DP'*DP + opts.lambda2*eye(size(DP,2)))*DP'*X; %self

    
    %% ========= Init DS, ZS ==============================
    Xbar = X - DP * ZP;
    DS = PickDfromY(Xbar, [0, size(Xbar,2)], opts.k0);
    
    ZS = pinv(DS'*DS + opts.lambda2*eye(size(DS,2)))*DS'*Xbar; %self
    
    DS = min_rank_dict(DS, Xbar*ZS', ZS*ZS', 2*opts.lambda3, opts);
end

