clc;
clear;

addpath(genpath('utils'));
addpath(genpath('utils_active'));
addpath('DCSDL');
addpath('ODL');

dataset = 'Flower17_SPM'; 
params.k = 20; params.k0 = 10; params.N_train = 20; params.pca = 0;
params.alpha = 0.01; params.beta  = 0.3; params.gamma = 5;

params.dataset = dataset;
params.Activate = 'ReluInverse';

fprintf('Start time¡ª¡ª');
t = getTimeStr();
[result] = DCSDL_wrapper(params);

