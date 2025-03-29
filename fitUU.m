function [intervals,p,w,clusters,k]=fitUU(x)
% Fit a UMM to the dataset using UU-test
% Inputs:
%   x - Input data (1D array)
%
% Outputs:
%   intervals - Intervals for each cluster
%   p - Probability of each interval within a cluster
%   w - Weights (proportion) of each cluster
%   clusters - Identified cluster regions
%   k - Number of clusters (1 for unimodal data)

x=sort(x); Q=length(x);  segments=[];

clusters=[min(x) max(x)]; % Default: single cluster (unimodal case)
%clusters = cut1d_2(x,[]); % To do: Implement for multimodal datasets

k=size(clusters,1);

if k==1 % Unimodal case
    w=1;
    [intervals_,p_]=fitUU_1d(x); % Compute UU intervals and probabilities
    intervals=cell(1); p=cell(1);
    intervals{1}=intervals_; p{1}=p_;
    
else   % Multimodal case (to be implemented)
    w=zeros(1,k);
    intervals=cell(k,1);  p=cell(k,1);
    for i=1:k
        dataset=intersect(x(x>=clusters(i,1)),x(x<=clusters(i,2)));
        w(i)=length(dataset)/Q;
        [intervals{i},p{i}]=fitUU_1d(dataset);
    end
end

end