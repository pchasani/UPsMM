function merge_overlap_intervals(i_merge,b,intervals_ab)
% This function merges overlapping intervals based on a given index i_merge.
% If an interval overlaps with the selected one, they are merged and the redundant interval is deleted.

% Global variables affecting merging behavior
global a  r  g;
global w;
global Prior;
global K;

% Get the left and right bounds of the interval to merge
xL = intervals_ab(i_merge,1);
xR = intervals_ab(i_merge,2);

% Check for overlap with other intervals
for i = 1:K
    if i ~= i_merge
        xL_test = intervals_ab(i,1);
        xR_test = intervals_ab(i,2);
        % If there is no overlap, continue to the next interval
        if xL >= xR_test || xR <= xL_test
            continue;
        end
        % Merge the overlapping intervals and delete the redundant one
        merge_and_delete(i_merge, i, intervals_ab);
        break
    end
end

end