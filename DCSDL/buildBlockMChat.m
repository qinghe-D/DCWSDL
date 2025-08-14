    function MC = buildBlockMChat(X, X_range_row, X_range_col)
        C = numel(X_range_row) - 1;
        X_range_row = size(X,1)*(0:C);
        MC = zeros(X_range_row(1,end),X_range_col(1,end));
        for c = 1: C
            range_row = X_range_row(c) + 1: X_range_row(c+1);
            range_col = X_range_col(c) + 1: X_range_col(c+1);
            Xi = X(:, range_col);
            mc = buildMean(Xi);
            MC(range_row, range_col) = mc;
        end 
    end 