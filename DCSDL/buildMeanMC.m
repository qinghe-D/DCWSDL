function M = buildMeanMC(X,X_range)
    C = numel(X_range) - 1;
    M = zeros(size(X));
    for c = 1: C
        Xi = X(:, X_range(c)+1:X_range(c+1));
        Nc = size(Xi, 2);
        MeanXi = mean(Xi, 2);
        M(:,X_range(c)+1:X_range(c+1)) = repmat(MeanXi, 1, Nc);
    end
end