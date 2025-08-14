function Y_Similar_norm = norm_similar(Y_Similar)
    %% 取出最大值
    col_max = max(Y_Similar, [], 1);
    col_max_Y = repmat(col_max, size(Y_Similar,1), 1);

    %% 取反
    Y_Similar_devide = Y_Similar./col_max_Y;
    col_max_devide = max(Y_Similar_devide, [], 1);
    col_max_Y_devide = repmat(col_max_devide, size(Y_Similar,1), 1);
    Y_Similar_norm = col_max_Y_devide - Y_Similar_devide;
    
    %% 归一化
    col_max_norm = max(Y_Similar_norm, [], 1);
    col_max_Y_norm = repmat(col_max_norm, size(Y_Similar_norm,1), 1);
    Y_Similar_norm = Y_Similar_norm./col_max_Y_norm;
end

