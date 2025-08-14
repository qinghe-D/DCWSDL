function [DP, DS, ZP, ZS] = DCSDL_init(X, X_range, DP_range, opts)
    switch opts.initFast
        case 1
            [DP, DS, ZP, ZS] = DCSDL_norm_fast_init(X, X_range, DP_range, opts);
    end
    
end

