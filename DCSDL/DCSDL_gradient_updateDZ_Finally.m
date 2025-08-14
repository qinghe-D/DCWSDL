function [DP, DS, ZP, ZS, opts] = DCSDL_gradient_updateDZ_Finally(X, X_range, DP, DP_range, DS, ZP, ZS, opts)
    MP = repmat(mean(ZP, 2), 1, size(ZP, 2));
    MS = repmat(mean(ZS, 2), 1, size(ZS, 2));
    MP_Ck = buildMeanMC(ZP,X_range); % Mean_C = [M1,M2,...,MC]

    C = numel(X_range)-1;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ========= Update DP ==============================
    if opts.verbose
        fprintf('\t updating DP...');
    end
    opts.tol = 1e-8;
    Zbar = X - DS*ZS;

    % update D_P^l
    FDl = buildDoubleDiagM(ZP * ZP', DP_range, DP_range); % all right
    

    ZPdiag = buildDiagZPM(ZP, DP_range, X_range); % ZPhat = diag([Z11',Z22',...,Zcc'])
    EDl = Zbar * (ZP' + ZPdiag'); % all right
    
    FDP_fast = FDl;
    EDP_fast = EDl;
    
    [DP, ~] = ODL_updateD(DP, EDP_fast, FDP_fast, opts);
    DP = EDP_fast * pinv(FDP_fast);
    
    % update Z_P^l
    if opts.verbose
        fprintf('updating ZP ...');
    end
    
    Xbar = X - DS*ZS;
    DTD = DP'*DP;
    DTZl_1 = DP'*Xbar;

    FZl = buildDoubleDiagM(DTD, DP_range, DP_range);

    EZl = buildDoubleDiagM(DTZl_1, DP_range, X_range);
    
    [wi, bi, opts] = getWcolumnByColumn(X, X_range, ZP, MP_Ck, MP, opts);
    ZP = zeros(size(DP, 2), size(X, 2));
    
    n = size(X, 2);
    for c = 1:C
        ZP(:, X_range(c)+1:X_range(c+1)) = pinv(FZl + (opts.lambda1*wi(c) + opts.lambda1 + opts.lambda2) * eye(size(FZl,1)))... 
            *(EZl(:, X_range(c)+1:X_range(c+1)) + opts.lambda1*(wi(c)*MP_Ck(:,X_range(c)+1:X_range(c+1))...
            +bi(c)*(MP_Ck(:,X_range(c)+1:X_range(c+1)) - MP(X_range(c)+1:X_range(c+1))...
            - 1/n * (MP_Ck(:,X_range(c)+1:X_range(c+1)) - MP(X_range(c)+1:X_range(c+1))) * ones(X_range(2),X_range(2)) ) )); 
    end
    
    Vl = X - DP * ZP;
    ZPhat = buildDiagZPM(ZP, DP_range, X_range);
    Ul = X - DP * ZPhat;
    
    % update D_S^l
    if opts.verbose
        fprintf('updating DS ');
    end
    EDS_fast = .5*(Vl + Ul) * ZS';
    FDS_fast = ZS * ZS';
    
    DS = min_DS_rank_dict(DS, EDS_fast, FDS_fast, opts.lambda3, opts);
    
    % update Z_S^l
    if opts.verbose
        fprintf('updating ZS ...\n');
    end
    
    ZS = pinv( 2 * (DS' * DS) + (2*opts.lambda1 + opts.lambda2) * eye(size(DS,2)) ) * ((DS' * (Vl + Ul) + opts.lambda1 * MS));
end


function [wi, bi, opts] = getWcolumnByColumn(~, X_range, ZP, MP_Ck, MP, opts)
    X = opts.X;
    C = numel(X_range)-1;
    wi = zeros(1,C * X_range(2));
    bi = zeros(1,C * X_range(2));
    
    U = repmat(mean(X, 2), 1, size(X, 2));
    Uc = buildMeanMC(X,X_range);
    W = zeros(6,C);
    for c = 1:C
        wic = norm(X(:,X_range(c)+1:X_range(c+1)) - Uc(:, X_range(c)+1:X_range(c+1)), 2).^2;
        bic = norm(Uc(:, X_range(c)+1:X_range(c+1)) - U(:, X_range(c)+1:X_range(c+1)), 2).^2;
        ebi = bic;
        ewi = exp(-(5 / wic));
        W(1, c) = wic;
        W(2, c) = ewi;
        W(3, c) = bic;
        W(4, c) = ebi;
        W(5, c) = norm(ZP(:,X_range(c)+1:X_range(c+1)) - MP_Ck(:, X_range(c)+1:X_range(c+1)), 2);
        W(6, c) = norm(MP_Ck(:, X_range(c)+1:X_range(c+1)) - MP(:, X_range(c)+1:X_range(c+1)), 2);
        wi(X_range(c)+1:X_range(c+1)) = ewi;
        bi(X_range(c)+1:X_range(c+1)) = ebi;
    end
    
   opts.wi = wi;
   opts.bi = bi;
end




