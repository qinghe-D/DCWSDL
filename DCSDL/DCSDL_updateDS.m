function DS = DCSDL_updateDS(X, X_range, DP, DP_range, DS, ZP, ZS, opts)

    Vl = X - DP * ZP;
    ZPhat = buildDiagZPM(ZP, DP_range, X_range);
    Ul = X - DP * ZPhat;
    MShat = buildMean(X); % MS = [m, m,...,m]
    
    Ql = ZS * ZS';
    Sl = (Vl + Ul + opts.lambda1 * MShat) * ZS';
    
    DS = min_DS_rank_dict(DS, Sl, Ql, opts.lambda3, opts);
end