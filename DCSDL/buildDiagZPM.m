    function RM = buildDiagZPM(M, M_range_row, M_range_col)
        C = numel(M_range_row) - 1;
        RM = zeros(size(M));
        for c = 1: C
            range_row = M_range_row(c) + 1: M_range_row(c+1);
            range_col = M_range_col(c) + 1: M_range_col(c+1);
            RM(range_row, range_col) = M(range_row, range_col);
        end 
    end 