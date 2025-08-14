    function RM = buildDiagM(M, M_range_row, M_range_col)
        C = numel(M_range_row) - 1;
        M_range_row = size(M,1)*(0:C);
        RM = zeros(M_range_row(1,end),M_range_col(1,end));
        for c = 1: C
            range_row = M_range_row(c) + 1: M_range_row(c+1);
            range_col = M_range_col(c) + 1: M_range_col(c+1);
            RM(range_row, range_col) = M(:, range_col);
        end 
    end 