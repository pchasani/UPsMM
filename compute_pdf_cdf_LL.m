function [LUMM, LUPsMM, LG] = compute_pdf_cdf_LL(X, model_1, model_2, model_3)
% Computes the PDF, CDF, and log-likelihood for three models:
%   - Uniform Mixture Model (UMM)
%   - Unimodal Pi-sigmoid Mixture Model (UPsMM)
%   - Gaussian model
%
% Inputs:
%   - X: Data points where PDFs and CDFs are evaluated.
%   - model_1: Cell array containing parameters of the UMM model.
%   - model_2: Cell array containing parameters of the UPsMM model.
%   - model_3: Cell array containing the Gaussian model.
%
% Outputs:
%   - LUMM: Log-likelihood of the UMM model.
%   - LUPsMM: Log-likelihood of the UPsMM model.
%   - LG: Log-likelihood of the Gaussian model.


%% Extract parameters from UMM
intervals = model_1{1} ; % Intervals of PL_S approximation
p = model_1{2} ; % Probability values per interval
ww = model_1{3} ; % Cluster weights
clusters = model_1{4} ; % Cluster boundaries

%% Extract parameters from UPsMM
a = model_2{1}; % Lower bounds of the segments
r = model_2{2}; % Segment widths
g = model_2{3}; % Shape parameters for the segments
w = model_2{4}; % Weights of each segment
Prior = model_2{5}; % Prior probabilities for the mixture components

%% Extract Gaussian model
gaussian = model_3{1}; % Gaussian distribution object


%% Compute PDF and CDF for UMM
[pUMM,~]=pdfUU(X,intervals,p,ww,clusters); % Compute UMM PDF
[yUMM,~]=cdfUU(X,intervals,p,ww,clusters); % Compute UMM CDF
pUMM(pUMM==0) = 10^(-6); % Avoid log(0) issues by replacing zero values

%% Compute PDF and CDF for UPsMM
pUPsMM=mixfun(X, a, r, g, w, Prior); % Compute UPsMM PDF
b=a + r.^2; % Upper bounds of the intervals
lambda = g.^2; % Shape parameters
yUPsMM = p_sigm_cdfUU(X,a,b,lambda,Prior); % Compute UPsMM CDF
pUPsMM(pUPsMM==0) = 10^(-6); % Avoid log(0) issues

%% Compute PDF and CDF for Gaussian model
pG = pdf(gaussian,X'); % Compute Gaussian PDF
yG = cdf(gaussian,X'); % Compute Gaussian CDF


%% Compute Log-Likelihoods for each model
LUMM =  sum(log(pUMM)); % Log-likelihood for UMM
LUPsMM =  sum(log(pUPsMM)); % Log-likelihood for UPsMM
LG =  sum(log(pG)); % Log-likelihood for Gaussian model

%% Determine the best model based on log-likelihood
All_LL = [LUMM, LUPsMM, LG]; % Store log-likelihoods in an array
Names_of_models = {'LUMM', 'LUPsMM', 'LG'}; % Model names
[maxLL, maxLL_ind] = max(All_LL); % Find the model with the highest log-likelihood

% Display results (commented out for now)
%fprintf('\n LUMM = %.4f | LUPsMM = %.4f | LG = %.4f   \n', LUMM, LUPsMM, LG);
%fprintf('\n The best model is: **%s** with LogLikelihood: %.4f \n', Names_of_models{maxLL_ind}, maxLL);

%% Plot PDF and CDF comparisons for the three models
Plot_pdf_ecdf(X, pUMM, pUPsMM, pG, 'pdf'); % Plot PDF comparisons
Plot_pdf_ecdf(X, yUMM, yUPsMM, yG, 'cdf'); % Plot CDF comparisons

end
