function acc = DCSDL_test(label_train, label_test, SVMpara, opts)
    switch opts.testModel
        case 1  % SVM classifier
            Z_train = SVMpara.Z_train; %train sample coding coefficient
            Z_test  = SVMpara.Z_test;  %test sample coding coefficient
            acc = predictLabel(Z_train, Z_test, label_train, label_test, opts);
    end
end

