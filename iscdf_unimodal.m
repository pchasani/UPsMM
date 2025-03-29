function [h, mpoint, inds] = iscdf_unimodal(d2f, mpoint)
% This function checks whether the given second derivative of a distribution (d2f) is unimodal.
% It returns h = 1 if the distribution is unimodal and h = 0 if it is multimodal.
% mpoint is updated if necessary, and inds contains indices where the sign of d2f is inconsistent with unimodality.
% These points are defined as Multimodality Indicators (MI) in the paper.

inds=[]; % Initialize the indices of MI points

d2f(isinf(d2f)) = 10^6;  % Replace infinite values with a large number to avoid numerical issues

% Find indices where the second derivative is positive (concave) or negative (concave)
pos=find(d2f>0);
neg=find(d2f<0);

% If there are no positive or no negative values, the function is unimodal
if isempty(pos) || isempty(neg)
    h = 1;  % unimodal
    
    % If all positive values appear before all negative values, it is unimodal
elseif max(pos) < min(neg)
    h= 1;  % unimodal
    mpoint = max(pos); % Update the mpoint (mode) point to the last positive index
    
else
    h = 0; false_pos = []; % multimodal
    
    % Fix the mpoint point if needed
    mpoint = fix_mpoint(mpoint, d2f);
    
    % Identify false negative points (negative values before the mpoint point)
    false_neg = find(d2f(1:mpoint)<0);
    
    % Identify false positive points (positive values after the mpoint point)
    for i = mpoint + 1 : length(d2f)
        if d2f(i) >= 0
            false_pos = [false_pos; i];
        end
    end
    % Combine false negative and false positive indices
    inds=[false_neg; false_pos];
end

end
