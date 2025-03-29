function [y,x]=cdfUU(x,intervals,p,w,clusters)
% Computes the cumulative distribution function (CDF) based on given intervals.
%
% Inputs:
%   - x: A vector of input data points.
%   - intervals: A cell array where each cell contains intervals for a specific cluster (here: 1 cluster).
%   - p: A cell array containing probability values corresponding to the intervals.
%   - w: A weight vector representing the probability mass of each cluster.
%   - clusters: An Nx2 matrix where each row defines the start and end of a
%   cluster (here: 1 cluster).
%
% Outputs:
%   - y: The computed CDF values corresponding to x.
%   - x: The sorted input values.

x=sort(x);

% Iterate through each data point in x
for j=1:length(x)
    % Iterate through each cluster
    for i=1:size(clusters,1)
        % If x(j) is smaller than the first cluster boundary, set CDF to 0
        if x(j)<clusters(1,1)
            y(j)=0;
            break;
            
            % If x(j) falls within the range of the current cluster
        elseif x(j)>=clusters(i,1) && x(j)<=clusters(i,2)
            % Iterate through the intervals of the current cluster
            for n=1:size(intervals{i},1)
                % If x(j) is before the first interval, assign cumulative weight of previous clusters
                if x(j)<intervals{i}(n,1)
                    y(j)=sum(w(1:i-1));
                    break;
                    
                    % If x(j) falls within the current interval, compute the CDF value
                elseif x(j)>=intervals{i}(n,1) && x(j)<=intervals{i}(n,2)
                    % Compute cumulative probability using weighted sum and linear interpolation
                    y(j)=sum(w(1:i-1)) + w(i)*[sum(p{i}(1:n-1))+ p{i}(n)*((x(j)-intervals{i}(n,1))/(intervals{i}(n,2)-intervals{i}(n,1)))];
                    break;
                    
                    % If x(j) is beyond the last interval of the current cluster, assign full cluster weight
                elseif x(j)>intervals{i}(size(intervals{i},1),2)
                    y(j)=sum(w(1:i-1)) + w(i);  break;
                end
            end
            break;
            % If x(j) is larger than the last cluster boundary, set CDF to 1
        elseif x(j)>clusters(size(clusters,1),2)
            y(j)=1; break;
        end
    end
    
    % If x(j) does not belong to any cluster, assign the previous y value to maintain continuity
    if length(y)==j-1
        y(j)=y(j-1);
    end
end
end