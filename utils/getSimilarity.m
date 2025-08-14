function [classy, accuracy, Y_Similar] = getSimilarity(X, Y, DP, DS, ZS_test, opts)
    X_range = opts.X_range;
    DP_range = opts.DP_range;
    C = numel(X_range) - 1;
    Y_Similar = zeros(size(Y,2), C * opts.k);
    if ~exist('opts.similar')
        opts.similar = 1; 
    end
    switch opts.similar
        case 0 %% ���� test sample �� ÿ���� train sample ��� CKA ������
            for yi = 1:size(Y,2) %% ÿ��test sample
                for class1 = 1:C
                    Yi = repmat(Y(:,yi), 1, X_range(2));
                    Xc = X(:, X_range(class1)+1 : X_range(class1+1));
                    Y_Similar(yi, class1) = linear_CKA(Yi, Xc); % CKA(Yi, Xc);
                end
            end
            [classy, classyIndex] = max(Y_Similar, [], 2);
%             accuracy=length(find(classyIndex'==opts.label_test))/length(opts.label_test)*100;
        case  1 %% ���� test samples �� ÿ���� train samples ��ֵ ��� Euclidean ����
            MCmean = zeros(size(X,1), C);
            varX = zeros(1, C);
            for c = 1: C
                Xi = X(:, X_range(c)+1:X_range(c+1));
                MCmean(:,c) = mean(Xi, 2);
            end
            for yi = 1:size(Y,2) %% ÿ��test sample
                Y_sum = sum((MCmean - Y(:,yi)*ones(1, C)).^2); %pi = ||xi-dk||2
                rho = corr(X, Y);
                rho2 = corr2(X, Y);
                rhoDP = corr(DP, Y);
                Y_yi = extend_vector(Y_sum, opts.k);
                Y_Similar(yi,:) = Y_yi;
%                 Y_Similar(yi,:) = sum((MCmean - Y(:,yi)*ones(1, C)).^2); %pi = ||xi-dk||2
            end
            [classy, classyIndex] = min(Y_Similar, [], 2);
            accuracy=length(find(classyIndex'==opts.label_test))/length(opts.label_test)*100;
            
        case 2 %% ���� test samples �� ÿ���� dictionary ��� CKA ������
            for yi = 1:size(Y,2) %% ÿ��test sample
                for class1 = 1:C
                    Yi = repmat(Y(:,yi), 1, DP_range(2));
                    DPc = DP(:, DP_range(class1)+1 : DP_range(class1+1));
                    Y_Similar(yi, class1) = linear_CKA(Yi, DPc); % CKA(Yi, Xc);
                end
            end
            [classy, classyIndex] = max(Y_Similar, [], 2);
%             accuracy=length(find(classyIndex'==opts.label_test))/length(opts.label_test)*100;
            
        case 3 %% ���� test samples �� ÿ���� dictionary ��ֵ ��� Euclidean ����
            MCmean = zeros(size(DP,1), C);
            for c = 1: C
                DPi = DP(:, DP_range(c)+1:DP_range(c+1));
                MCmean(:,c) = mean(DPi, 2);
            end

            for yi = 1:size(Y,2) %% ÿ��test sample
                Y_Similar(yi,:) = sum((MCmean - Y(:,yi)*ones(1, C)).^2); %pi = ||xi-dk||2
            end
            [classy, classyIndex] = min(Y_Similar, [], 2);
%             accuracy=length(find(classyIndex'==opts.label_test))/length(opts.label_test)*100;
        case 4 %% ���� test samples - DS * ZS �� ÿ���� dictionary ��� CKA ������
            Y = Y - DS * ZS_test;
            for yi = 1:size(Y,2) %% ÿ��test sample
                for class1 = 1:C
                    Yi = repmat(Y(:,yi), 1, DP_range(2));
                    DPc = DP(:, DP_range(class1)+1 : DP_range(class1+1));
                    Y_Similar(yi, class1) = linear_CKA(Yi, DPc); % CKA(Yi, Xc);
                end
            end
            [classy, classyIndex] = max(Y_Similar, [], 2);
%             accuracy=length(find(classyIndex'==opts.label_test))/length(opts.label_test)*100;
            
        case 5 %% ���� test samples - DS * ZS  �� ÿ���� dictionary ��ֵ ��� Euclidean ����
            Y = Y - DS * ZS_test;
            MCmean = zeros(size(DP,1), C);
            for c = 1: C
                DPi = DP(:, DP_range(c)+1:DP_range(c+1));
                MCmean(:,c) = mean(DPi, 2);
            end

            for yi = 1:size(Y,2) %% ÿ��test sample
                Y_Similar(yi,:) = sum((MCmean - Y(:,yi)*ones(1, C)).^2); %pi = ||xi-dk||2
            end
            [classy, classyIndex] = min(Y_Similar, [], 2);
%             accuracy=length(find(classyIndex'==opts.label_test))/length(opts.label_test)*100;
    end
end


function s = extend_vector(Y_sum, k)
    C = size(Y_sum,2);
    s = zeros(1, C * k);
    for col = 1:C % ��vector��ÿһ����չk��
        s(1, (col-1)*k+1 : col * k) = Y_sum(1, col)*ones(1, k);
    end
end