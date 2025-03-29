%% Demo

X = normrnd(0, 1, 1, 400); % for gaussian distribution
% X = gen_triang_data(0,1,2,500); % for triangular distribution
% X = gen_triang_data(0,1,6,500); % for asymmetric triangular distribution

% for a mixture of gaussian & uniform
% X1 = normrnd(0, 1, 1, 400);
% X2 = unifrnd(2.5,4,1,50);
% X = [X1 X2];

% fit a UPsMM model on a unimodal dataset X
[a, r, g, w, Prior, step] = UPsMM(X);

% Compare 3 models: UMM, UPsMM and Gaussian
% [LUMM, LUPsMM, LG, initial_K, final_K, step] = fit_models(X);