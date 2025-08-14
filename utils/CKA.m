function theta = CKA(X, X_range)
    %CKA �˴���ʾ�йش˺�����ժҪ
    %   ������������������
    C = numel(X_range) - 1;
    S = ones(C,C);
    
    for class1 = 1:C
        for class2 = 1:C
            if class1 == class2
                continue;
            else
                X_C1 = X(:, X_range(class1)+1:X_range(class1+1));
                X_C2 = X(:, X_range(class2)+1:X_range(class2+1));
                S(class1,class2) = linear_CKA(X_C1, X_C2);
            end
        end
    end
    M = mean(S, 2);
    theta = mean(M);
end
