function [dataset, Y_train, Y_test, label_train, label_test] = train_test_split(...
    dataset, params)
N_train = params.N_train;
myrng();
fprintf('Picking Train and Test set ...');
switch dataset
    case {'Flower17_SPM'}
        load(fullfile('data',strcat(dataset, '.mat')));
        Data.descr = double(Data.descr);
        Data.label = double(Data.label);
        Data.descr = normc(double(Data.descr));
        if params.pca
            [descr_set, ~, ~]  =  Eigenface_f(Data.descr, 300);
            Data.descr = descr_set'*Data.descr;
        end
        [train, test] = getTrainAndTest_random(Data, N_train);
        Y_train = train.descr;
        label_train = train.label;
        Y_test = test.descr;
        label_test = test.label;
end
fprintf('DONE\n');
end
