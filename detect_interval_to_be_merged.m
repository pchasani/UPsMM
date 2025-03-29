function ind_to_be_merged = detect_interval_to_be_merged(points_of_false_sign, intervals_ab)
% points_of_false_sign -> MI (Multimodality Indicators defined in the paper)

% This function identifies which interval should be merged based on MI points.
% It finds the interval that is most frequently the closest to false-sign (MI) points.

closest_intervals = zeros(1,length(points_of_false_sign));  % Initialize array for closest intervals

% Find the closest interval for each MI point
for q = 1 : length(points_of_false_sign)
    inds = find_closest_interval(points_of_false_sign(q), intervals_ab);
    closest_intervals(q) = inds(1);
end

% Identify unique closest intervals
uniq_closest_intervals = unique(closest_intervals);
count_of_closest_intervals = zeros(1, length(uniq_closest_intervals));  % Initialize counter array

% Count occurrences of each closest interval
for q = 1 : length(uniq_closest_intervals)
    count_of_closest_intervals(q) = sum(closest_intervals == uniq_closest_intervals(q));
end

% Select the most frequently occurring closest interval
[~,ind_most_common_interval] = max(count_of_closest_intervals);
ind_to_be_merged = uniq_closest_intervals(ind_most_common_interval);

end