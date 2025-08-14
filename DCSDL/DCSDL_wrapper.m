function [result] = DCSDL_wrapper(params)
    opts.Activate = params.Activate;
    opts.k1          = params.k;
    opts.k2          = ceil(params.k/2);
    opts.k3          = ceil(params.k/4);
    opts.k0          = params.k0;
    opts.show_cost   = 0;
    opts.showD       = 0;
    opts.lambda1     = params.alpha;
    opts.lambda2     = params.beta;
    opts.lambda3     = params.gamma;
    opts.max_iter    = 5;
    opts.test_iter   = 0;
    opts             = initOpts(opts);
    opts.verbose     = false;
    opts.initFast    = 1;
    opts.SVMtest     = 1;
    opts.testModel   = 1;
    
    opts.updateFast  = 15;
    opts.testMethod  = 1;
    opts.testZS      = 1;
    opts.trainZS     = 1;
    
    opts.test_mode   = 0 ;
    opts.active      = 1 ;
    opts.omiga       = 0.3;
    opts.train_omiga = 0;
    
    timsOk = 10;
    
    for alphaI = 1:length(params.alpha)
        for betaI = 1:length(params.beta)
            for gammaI = 1:length(params.gamma)
                
                opts.lambda1     = params.alpha(alphaI);
                opts.lambda2     = params.beta(betaI);
                opts.lambda3     = params.gamma(gammaI);
                for times = 1:timsOk
                    fprintf('times:%d \n', times);
                    [~, Y_train, Y_test, label_train, label_test] = train_test_split(params.dataset, params);
                    [accuracy] = DCSDL_iter_P(Y_train, label_train, Y_test, label_test, opts);
                    fprintf('accuracy = %2.4f \n', accuracy);
                end
            end
        end
    end
end
