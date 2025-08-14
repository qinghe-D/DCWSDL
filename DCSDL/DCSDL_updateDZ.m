function [DP, DS, ZP, ZS, opts] = DCSDL_updateDZ(X, X_range, DP, DP_range, DS, ZP, ZS, opts)

    switch opts.updateFast
        case 15
            [DP, DS, ZP, ZS, opts] = DCSDL_gradient_updateDZ_Finally(X, X_range, DP, DP_range, DS, ZP, ZS, opts); % Weighted Fisher Shared DL
 end
end  





