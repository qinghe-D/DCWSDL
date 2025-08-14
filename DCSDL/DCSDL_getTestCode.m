function [Z_test, ZP_test] = DCSDL_getTestCode(Y, DP, DS, opts)
    lambda2 = opts.lambda2;
    switch opts.testMethod
        case 1
            D = [DP, DS];
            Z_test = pinv((D' * D) + lambda2 * eye(size(D, 2))) * D' * Y;
            ZP_test = Z_test(1:size(Z_test,1)-opts.k0,:);
            if ~opts.testZS
                Z_test = ZP_test;
            end
    end
end



