function merge_and_delete(i_merge, closest, intervals_ab)
% This function merges two overlapping intervals and removes the redundant one.
% The merged interval takes the union of both intervals' ranges.

% Global variables affecting merging behavior
global a  r  g;
global w;
global Prior;
global K;

% Compute the updated interval boundaries
b = a + r.^2;
sorted = sort([intervals_ab(i_merge,:), intervals_ab(closest,:)]);

% Determine which row to change and which to delete
if closest < i_merge
    row_to_change = closest;
    row_to_delete = i_merge;
else
    row_to_change = i_merge;
    row_to_delete = closest;
end

% Update the interval boundaries
intervals_ab(row_to_change,1) = sorted(1);
intervals_ab(row_to_change,2) = sorted(4);

a(row_to_change) = sorted(1);
b(row_to_change) = sorted(4);
r(row_to_change) = sqrt(b(row_to_change) - a(row_to_change));
Prior(row_to_change) = Prior(row_to_change) + Prior(row_to_delete);

% Remove the redundant interval
a(row_to_delete) = []; b(row_to_delete) = []; r(row_to_delete) = []; w(row_to_delete) = [];
g(row_to_delete) = []; Prior(row_to_delete) = [];

intervals_ab(row_to_delete,:) = [];
K = K - 1; % Decrease the number of components by 1

end