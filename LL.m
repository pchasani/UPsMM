function v=LL(X, a, r, g, w, BG)
% This function computes the log-likelihood of a dataset X based on a mixture model.
% It uses the parameters a, r, g, w, and Prior to calculate the likelihood, adjusting for the number of components (K - BG).

global Prior;
global K;

N=size(X,2); % Get the number of data points in X (columns of X)
Pr=Prior(1:K-BG)/sum(Prior(1:K-BG)); % Normalize Prior to sum to 1 for K-BG components

tsum=0; % Initialize the total sum for log-likelihood computation

% Loop over each data point in X
for i=1:N
    isum=0; % Initialize the sum for this data point
    
    % Loop over each component of the mixture model (K - BG components)
    for j=1:K-BG
        % Compute the probability density for the current component using the sigmoid PDF function
        isum=isum+Pr(j)*dsigmoidpdf(X(:,i),a(:,j),r(:,j),g(:,j),w(:,j));
    end
    % Add the log of the sum to the total sum for log-likelihood
    tsum=tsum + log(isum);
end

% Return the negative log-likelihood value
v=-tsum;

