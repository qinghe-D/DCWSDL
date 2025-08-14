function [accuracy] = DCSDL_iter_P(X, label_train, Y_test, label_test, opts)

%% Parameter preparation
C = max(label_train);
D1_range     = opts.k1*(0:C);
D2_range     = opts.k2*(0:C);
D3_range     = opts.k3*(0:C);
X_range = label_to_range(label_train);
opts.X_range = X_range; opts.label_test = label_test; opts.label_train = label_train;
ACC_layer3_concat = [];
init = true;
testModel = opts.testModel;
testSVM = 1;    
opts.W = [];
fun = eval(['@' opts.Activate]);
wi = zeros(1,C * X_range(2));
bi = zeros(1,C * X_range(2));
bi = ones(size(bi));
wi = ones(size(wi));
opts.wi = wi;
opts.bi = bi;
opts.X = X;
%% Start main train loop
epoch = 0;
SVMpara = 0;
fprintf('\t train...');
while epoch < opts.max_iter
    tic;
    epoch = epoch + 1;
    opts.k = opts.k1; opts.DP_range = D1_range; opts.Y = Y_test;
    %% layer 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if init
        [DP_1, DS_1, ZP_1, ZS_1] = DCSDL_init(X, X_range, D1_range, opts);
    end
    opts.layer = 1;
    [DP_1, DS_1, ZP_1, ZS_1, opts] = DCSDL_updateDZ(X, X_range, DP_1, D1_range, DS_1, ZP_1, ZS_1, opts);
    [Z1_test, Z1_test_layer1] = DCSDL_getTestCode(Y_test, DP_1, DS_1, opts);
    if opts.active
        if opts.train_omiga
            opts.label_test = label_train;
            [~, ~, X_Similar] = getSimilarity(X, X, DP_1, DS_1, Z1_test, opts);
            opts.label_test = label_test;
            X_Similar_norm = norm_similar(X_Similar) + opts.omiga;
            ZP_1 = X_Similar_norm' .* ZP_1;
        end
        ZP_1 = fun(ZP_1,1); ZS_1 = fun(ZS_1,1);Z1_test = fun(Z1_test,1);
    end
    
    %% layer 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if opts.trainZS
        X_layer2 = [ZP_1; ZS_1];
        Y_layer2 = Z1_test;
    else
        X_layer2 = ZP_1;
        Y_layer2 = Z1_test_layer1;
    end
    
    opts.k = opts.k2;  opts.DP_range = D2_range; opts.Y = Y_layer2;
    if init
        if opts.verbose
            fprintf('\t layer2 Initializing ... \n');
        end
        [DP_2, DS_2, ZP_2, ZS_2] = DCSDL_init(X_layer2, X_range, D2_range, opts);
    end
    
    opts.layer = 2;
    [DP_2, DS_2, ZP_2, ZS_2, opts] = DCSDL_updateDZ(X_layer2, X_range, DP_2, D2_range, DS_2, ZP_2, ZS_2, opts);
    [Z2_test, ~] = DCSDL_getTestCode(Y_layer2, DP_2, DS_2, opts);
    if opts.active
        if opts.train_omiga
            opts.label_test = label_train;
            [~, ~, X_Similar] = getSimilarity(X_layer2, X_layer2, DP_2, DS_2, Z2_test, opts);
            opts.label_test = label_test;
            X_Similar_norm = norm_similar(X_Similar) + opts.omiga;
            ZP_2 = X_Similar_norm' .* ZP_2;
        end
        ZP_2 = fun(ZP_2,1); ZS_2 = fun(ZS_2,1); Z2_test = fun(Z2_test,1);
    end
    
    %% layer 3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if opts.trainZS
        X_layer3 = [ZP_2; ZS_2];
        Y_layer3 = Z2_test;
    else
        X_layer3 = ZP_2;
        Y_layer3 = Z2_test_layer2;
    end
    
    opts.k = opts.k3;   opts.DP_range = D3_range;  opts.Y = Y_layer3;
    if init
        if opts.verbose
            fprintf('\t layer3 Initializing ... \n');
        end
        [DP_3, DS_3, ZP_3, ZS_3] = DCSDL_init(X_layer3, X_range, D3_range, opts);
    end
    opts.layer = 3;
    [DP_3, DS_3, ZP_3, ZS_3, opts] = DCSDL_updateDZ(X_layer3, X_range, DP_3, D3_range, DS_3, ZP_3, ZS_3, opts);
    [Z3_test,~] = DCSDL_getTestCode(Y_layer3, DP_3, DS_3, opts);
    if opts.active
        if opts.train_omiga
            opts.label_test = label_train;
            [~, ~, X_Similar] = getSimilarity(X_layer3, X_layer3, DP_3, DS_3, Z3_test, opts);
            opts.label_test = label_test;
            X_Similar_norm = norm_similar(X_Similar) + opts.omiga; %% 正则化 相似性矩阵
            ZP_3 = X_Similar_norm' .* ZP_3;
        end
        ZP_3 = fun(ZP_3,1); ZS_3 = fun(ZS_3,1); Z3_test = fun(Z3_test,1);
    end
    if opts.SVMtest
        clear SVMpara;
        if opts.testZS
            SVMpara.Z_train = [ZP_1; ZS_1; ZP_2; ZS_2; ZP_3; ZS_3];
        else
            SVMpara.Z_train = [ZP_1; ZP_2; ZP_3];
        end
        SVMpara.Z_test  = [Z1_test; Z2_test; Z3_test];
    end
    opts.testModel = testSVM;
    acc_layer3_conc = DCSDL_test(label_train, label_test, SVMpara, opts);
    opts.testModel = testModel;
    ACC_layer3_concat = [ACC_layer3_concat acc_layer3_conc];
    
    init = false;
end

%% Refine [ZP, ZS] one more time
accuracy = max(ACC_layer3_concat);
end
