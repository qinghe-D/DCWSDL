function ZPSum = buildZPTSum(ZP,ZP_range)
    C = numel(ZP_range) - 1;
    ZPSum = zeros(ZP_range(2), size(ZP,1));
    for c = 1: C
        ZPc = ZP(:, ZP_range(c)+1:ZP_range(c+1));
        ZPSum = ZPSum + ZPc';
    end
end