function cost = DCSDL_fidelity(X, X_range, DP, DP_range, ZP)

    nClasses = numel(X_range) - 1;
    cost = 0;
    for c = 1: nClasses
        Xc = get_block_col(X, c, X_range);
        DPc = get_block_col(DP, c, DP_range);
        ZPc = get_block_row(ZP, c, DP_range);
        ZPcc = get_block_col(ZPc, c, X_range);
        cost = cost + normF2(Xc - DPc *ZPcc);
        for j = 1:nClasses
            if j == c 
                continue;
            else
                DPj = get_block_col(DP, j, DP_range);
                ZPcj = get_block_col(ZPc, j, X_range);
                cost = cost + normF2(DPj*ZPcj);
            end 
        end 
    end 

end 