function cost = DCSDL_SSRC_discriminative(DP, DP_range, Mean_U)

    nClasses = numel(DP_range) - 1;
    cost = 0;
    for c = 1: nClasses
        DPc = get_block_col(DP, c, DP_range);
        Mean_Uc = Mean_U(:, DP_range(c)+1:DP_range(c+1));

        cost = cost + normF2(DPc - Mean_Uc); 
        for j = 1:nClasses
            if j == c 
                continue;
            else
                DPj = get_block_col(DP, j, DP_range);
                cost = cost - normF2(DPj - Mean_Uc); %% 字典类间鉴别最大化 “-”
            end
        end 
    end
end