function Output = Active_Function(Input, config)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
active_function = config.active_function;
active_function_alpha = config.active_function_alpha;
switch(active_function)
    case 'sigmoid'
        Output = 1 ./ (1 + exp(-Input));
    case 'tanh'
        Output = 2 ./ (1 + exp(-2 * Input)) - 1;
    case 'ReLU'
        Output = zeros(size(Input));
        Output(Input > 0) = Input(Input > 0);
        Output(Input <= 0) = 0;
    case 'ELU'
        Output = zeros(size(Input));
        Output(Input > 0) = Input(Input > 0);
        Output(Input <= 0) = active_function_alpha * (exp(Input(Input <= 0)) - 1);
    case 'PReLU'
        Output = zeros(size(Input));
        Output(Input > 0) = Input(Input > 0);
        Output(Input <= 0) = active_function_alpha *(Input(Input <= 0));
    case 'softplus'
        Output = log(1 + exp(Input));
    case 'softsign'
        Output = Input ./(abs(Input) + 1);
    case 'liner' 
        Output = Input;
end
end