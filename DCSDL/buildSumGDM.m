function SumM = buildSumGDM(M, ZP, M_range_col, M_range_row)

    % then SumM = = [M1Z11', M2Z22' ,..., McZcc']
    C = numel(M_range_row) - 1;
    SumM = zeros(size(M,1), size(ZP,1));
    for c = 1: C
        range_row = M_range_row(c) + 1: M_range_row(c+1);
        range_col = M_range_col(c) + 1: M_range_col(c+1);
        
        Mc = M(:, range_col);
        ZPcc = ZP(range_row, range_col);
        
        SumM(:,range_row) = Mc * ZPcc';
    end
end