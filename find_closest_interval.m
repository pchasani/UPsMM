function ind = find_closest_interval(p,  intervals_ab)
% This function finds the closest interval to a given point or an interval.
% It calculates the distance from the point to each interval's boundaries and returns the index of the closest interval.


a = intervals_ab(:,1); % Extract the left endpoints of the intervals
b = intervals_ab(:,2); % Extract the right endpoints of the intervals

% If the input is a single point
if length(p) == 1
    dist_from_a = abs(a - p); % Distance from the point to the left boundary of each interval
    dist_from_b = abs(b - p); % Distance from the point to the right boundary of each interval
    
    % Sort the distances to find the closest boundary
    [sorted_dist_from_a, ind_sorted_dist_from_a] = sort(dist_from_a);
    [sorted_dist_from_b, ind_sorted_dist_from_b] = sort(dist_from_b);
    
    % Find the minimum distance to either boundary
    min_dist_from_a = min(sorted_dist_from_a);
    min_dist_from_b = min(sorted_dist_from_b);
    % Compare the closest boundary distances and choose the closest interval
    if min_dist_from_a <= min_dist_from_b
        ind = ind_sorted_dist_from_a;
    else
        ind = ind_sorted_dist_from_b;
    end
    
    % If the input is an interval (2 elements: left and right boundary)
else
    xL = p(1,1);  % Left boundary of the given interval
    xR = p(1,2);  % Right boundary of the given interval
    
    % Calculate the distance from each interval's left and right boundaries
    dist_from_a = abs(a - xL);
    dist_from_b = abs(b - xR);
    
    while (1)
        % Find the closest left boundary and right boundary
        [min_dist_from_a, ind_min_dist_from_a] = min(dist_from_a);
        [min_dist_from_b, ind_min_dist_from_b] = min(dist_from_b);
        
        
        % If the left boundary is exactly at the point, set its distance to a large value
        if min_dist_from_a == 0
            dist_from_a(ind_min_dist_from_a) = 10^10; % Avoid reusing the same interval
            dist_from_b(ind_min_dist_from_b) = 10^10; % Avoid reusing the same interval
            
        else
            % Compare distances and select the closest boundary (left or right)
            if min_dist_from_a <= min_dist_from_b
                ind = ind_min_dist_from_a; % Closest to the left boundary
            else
                ind = ind_min_dist_from_b; % Closest to the right boundary
            end
            break % Exit loop once the closest interval is found
        end
    end
end