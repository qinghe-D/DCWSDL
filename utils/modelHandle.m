function result = modelHandle(model, paramsLsdl, params, train, test)
% different parameters for a model to get the best accuracy
% input:
%          params.{Lambda, Gamma, Beta}
%          model: DLSDL

acc = [];
i   = 1;
fun = eval(['@' model]);
switch model
    case { 'DLSDL', 'DLSDL_epoch','ClassDis_DDL', 'L2_DDL', 'ResDDL', 'DLSDL_BP','DLSDL_GPU','DDL_MY'}
        for lam1 = params.Lambda1
            for lam2 = params.Lambda2
                %                 for lam3 = params.Lambda{3}
                paramsLsdl.lambda_dl1 = 0;
                paramsLsdl.lambda_dl2 = lam2{1};
                paramsLsdl.lambda_dl3 = lam2{1};
                result(i).acc = fun(paramsLsdl, train, test);
                result(i).lam1 = lam1{1};
                result(i).lam2 = lam2{1};
                result(i).lam3 = lam2{1};
                i = i + 1;
                %                 end
            end
        end
        
    case {'LSDL', 'FDDL_H', 'LC_KSVD', 'D_KSVD'}
        %训练样本数， 总类别数， 降维度， 字典原子数 ,...
        result(i).acc = fun(paramsLsdl, params, train, test);
    case {'SRC'}
        addpath Model/SRC-YALEB
        %         result(i).acc = computaccuracy(train.descr, paramsLsdl.total_class, train.label,test.descr,test.label) * 100;
        result(i).acc = Fir_presentation(test.descr', train.descr', paramsLsdl.total_class, paramsLsdl.tr_num, test.label', 0.1);
    case {'SAE_H', 'SAE_L', 'DBN_H', 'DDL'}
        result(i).acc = fun(paramsLsdl, train, test);
end
