function DP = DCSDL_update_DP(X, X_range, DP, DP_range, DS, ZP, ZS, opts)
    Zbar = X - DS*ZS;

    Mean_l = buildMean(X); % Mean_l = [m, m,...,m]
    Mean_Ck = buildMeanMC(X,X_range); % Mean_C = [M1,M2,...,MC]

    %% update D_P^l
    FDl = buildDoubleDiagM(ZP * ZP', DP_range, DP_range);

    ZPdiag = buildDiagZPM(ZP, DP_range, X_range);
    EDl = Zbar * (ZP' + ZPdiag');

    GD_pre = Mean_l - Mean_Ck;
    GDl = GD_pre * ZP';

    %% get DP
    DP = (EDl - opts.lambda1 * GDl) * pinv(FDl);
end