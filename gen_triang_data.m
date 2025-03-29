function xpdf = gen_triang_data(low, peak, upper, size)
% Generates random samples from a triangular distribution.

pd = makedist('Triangular', 'a', low, 'b', peak, 'c', upper); % Define the distribution
xpdf = random(pd, 1, size); % Generate random samples

% figure; hist(xpdf, 50); % Uncomment to visualize the histogram
end