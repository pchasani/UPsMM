function [S,p]=fitUU_1d(X)
% Computes the UU-test intervals and corresponding probabilities.
%
% Inputs:
%   X - Input data (1D array)
% Outputs:
%   S - Intervals from the UU-test
%   p - Probabilities for each interval

X=sort(X); Q=length(X);

S=UUtest(X,[]); % Compute UU-test intervals (PL_S approximation)
S=S';
% Construct interval pairs
S(1:length(S)-1,2)=S(2:length(S));
S(length(S),:)=[];

p=zeros(size(S,1),1); % Initialize probabilities

% If only one interval exists, assign full probability and return
if size(S,1) == 1
    p=1;
    return;
end

% Compute probability for each interval
for i=1:size(S,1)-1
    p(i) = length(X(X>=S(i,1) & X<S(i,2)))/Q;
end

% Compute probability for the last interval
p(i+1)=length(X(X>=S(i+1,1) & X<=S(i+1,2)))/Q;

end