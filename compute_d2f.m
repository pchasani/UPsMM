function d2f = compute_d2f(x, a, r, g, Prior)
% This function computes the second derivative of the distribution function (d2f)
% based on the input parameters: x, a, r, g, and Prior. The calculation uses an
% exponential function for each component of the mixture model.

b=a + r.^2; % Compute the upper bounds of the intervals for each component
lambda = g.^2; % Compute the rate parameter (lambda) for each component
d2f = zeros(length(x),1); % Initialize the second derivative array with zeros

% Loop over each point in x
for i = 1:length(x)
    isum = 0; % Initialize the sum for this point
    isumf = 0; % Initialize the total sum for the second derivative computation
    
    % Loop over each mixture component (length of 'a' corresponds to the number of components)
    for k = 1:length(a)
        % Compute the exponential terms based on the distance from the point x(i)
        y1 = exp(-lambda(k)*(x(i)-a(k)));
        y2 = exp(-lambda(k)*(x(i)-b(k)));
        
        % Compute the second derivative of the mixture component's contribution
        y= lambda(k)/(b(k)-a(k)) * ( y1/((y1+1)^2) - y2/((y2+1)^2) );
        
        % Compute the weighted contribution of the current component based on its prior
        isum =  Prior(k) * y;
        
        % If the sum is NaN (due to numerical issues), set it to 0
        if isnan(isum)
            isum = 0;
        end
        
        % Add the contribution of this component to the total sum for the current point
        isumf = isumf + isum;
    end
    
    % Store the total second derivative value for the current point x(i)
    d2f(i) = isumf;
end

end