function [DP, DS, ZP, ZS] = DCSDL_gradient_updateDZ(X, X_range, DP, DP_range, DS, ZP, ZS, opts)

    %% ========= Update DP ==============================
    if opts.verbose
        fprintf('\t updating DP...');
    end
    DP = DCSDL_update_DP(X, X_range, DP, DP_range, DS, ZP, ZS, opts);

    %% [ZP, ZS] = [ZP; ZS]
    Xbar = X-DS*ZS;
    Mean_l = repmat(mean([X, opts.Y], 2), 1, size(X, 2));
    MCmean = buildMeanMC(X,X_range); % MCmean = [M1,M2,...,MC]
    
%     Mean_l = repmat(mean([X, opts.Y], 2), 1, size(X, 2));
%     Mean_Ck = buildMeanMC(X,X_range); % Mean_C = [M1,M2,...,MC]
    
    %% update Z_P^l
    if opts.verbose
        fprintf('updating ZP ...');
    end
    DTD = DP'*DP;
    DTZl_1 = DP'*Xbar;
    % 构建矩阵 F_Z^l
    FZl = buildDoubleDiagM(DTD, DP_range, DP_range);

    % 构建矩阵 E_Z^l
    EZl = buildDoubleDiagM(DTZl_1, DP_range, X_range);

    % 构建矩阵 G_Z^l
    GZl = DP' * (Mean_l - MCmean);
    
    ZP = pinv(FZl + opts.lambda2 * eye(size(FZl,1))) * (EZl - opts.lambda1 * GZl);
    
    
    Vl = X - DP * ZP;
    ZPhat = buildDiagZPM(ZP, DP_range, X_range);
    Ul = X - DP * ZPhat;
    
    %% update D_S^l
    if opts.verbose
        fprintf('updating DS...');
    end
    DS = ((Vl + Ul + opts.lambda1 * Mean_l) * ZS') * pinv((2 + opts.lambda1) * (ZS * ZS'));
    
    %     EDS_fast = (Vl + Ul + opts.lambda1 * Mean_l) * ZS';
    %     FDS_fast = (2 + opts.lambda1) * (ZS * ZS');
    %     DS = min_DS_rank_dict(DS, EDS_fast, FDS_fast, opts.lambda3, opts);

    %% update Z_S^l
    if opts.verbose
        fprintf('updating ZS ...');
    end

    ZS = pinv((2 + opts.lambda1) * (DS' * DS) + opts.lambda2 * eye(size(DS,2))) * (DS' * (Vl + Ul + opts.lambda1 * Mean_l));
end





