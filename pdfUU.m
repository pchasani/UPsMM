function [y,x] = pdfUU(x,intervals,p,w,clusters)
% Computes the probability density function (PDF) based on given intervals.
%
% Inputs:
%   - x: A vector of input data points.
%   - intervals: A cell array where each cell contains intervals for a
%   specific cluster (here: 1 cluster).
%   - p: A cell array containing probability values corresponding to the intervals.
%   - w: A weight vector representing the probability mass of each cluster.
%   - clusters: An Nx2 matrix where each row defines the start and end of a cluster (here: 1 cluster).
%
% Outputs:
%   - y: The computed PDF values corresponding to x.
%   - x: The sorted input values.

x=sort(x);

% Initialize the PDF output vector with zeros
y=zeros(length(x),1);

% Iterate through each data point in x
for m=1:length(x)
    flag=0; % Flag to indicate whether x(m) belongs to an interval
    for i=1:size(intervals,1)
        if flag == 1
            break;
        end
        
        % Iterate through the intervals of the current cluster
        for j=1:size(intervals{i},1)
            % Check if x(m) falls within the current interval
            if x(m)>=intervals{i}(j,1) &&  x(m)<=intervals{i}(j,2)
                % Store position of cluster and interval (for debugging or tracking)
                pos(m,:)=[i j];
                flag=1; % Mark that x(m) is found in an interval
                
                % Compute PDF value using the weighted probability density
                y(m)=w(i)*p{i}(j,1)*1/(intervals{i}(j,2)-intervals{i}(j,1));
                break;
            end
        end
    end
    
    % If x(m) does not belong to any interval, assign zero probability
    if flag==0
        y(m)=0;
        pos(m,:)=[0 0]; % Mark as outside any cluster
    end
end

end