function [accuracy] = predictLabel(Z_train, Z_test, label_train, label_test, opts)

    training_set = Z_train';
    test_set = Z_test';
    training_set_label = label_train';
    test_set_label = label_test';
    
    switch opts.test_mode
        case 0
            %% SVM
            model = fitcecoc(training_set,training_set_label,'Learners','Linear','Coding','onevsall');
            predict_label = predict(model,test_set);
    end

    accuracy=length(find(predict_label==test_set_label))/length(test_set_label)*100;
end

