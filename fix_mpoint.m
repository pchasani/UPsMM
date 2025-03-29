function mpoint = fix_mpoint(mpoint, d2f)
% Adjusts the given point `mpoint` to ensure it aligns with a region
% where the second derivative `d2f` is positive.
%
% INPUTS:
%   - mpoint: Initial point to be adjusted.
%   - d2f:    A vector representing the second derivative of a function.
%
% OUTPUT:
%   - mpoint: Adjusted point where d2f(mpoint) > 0.

% Check if the second derivative is positive at the given point
if d2f(mpoint) > 0
    % Search forward to find the last consecutive index where d2f remains positive
    for i = mpoint +1 : length(d2f)
        if d2f(i) > 0
            mpoint = i; % Update mpoint to the new valid index
        else
            break; % Stop if d2f becomes non-positive
        end
    end
    
% Search backward to find the first index where d2f becomes positive
else
    for i = mpoint -1 : -1 : 1
        if d2f(i) > 0
            mpoint = i; % Update mpoint to the new valid index
            break; % Stop after finding the first valid index
        end
    end
end