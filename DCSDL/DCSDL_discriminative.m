function cost = DCSDL_discriminative(X, X_range, DP, DP_range, ZP)

    nClasses = numel(X_range) - 1;
    cost = 0;
    MCmean = buildMeanMC(X,X_range); % MCmean = [M1,M2,...,MC]
    
    for c = 1: nClasses
        Zc = get_block_col(ZP, c, X_range);
        Mc = MCmean(:, X_range(c)+1:X_range(c+1));
        cost = cost + normF2(DP * Zc - Mc);
    end

end