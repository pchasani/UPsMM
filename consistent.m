function [C,ind,sz]=consistent(gcm,lcm)
% Input: gcm and lcm sets
% Output:
%        C: consistent set (if exists)
%       ind: 0 for gcm, 1 for lcm points 
%       sz: number of consistent sets in C

% This method checks if GL set is consistent.
% If GL set is not consistent, it calls compute_consistent_sets method to
% obtain consistent subsets of GL.

C=cell(1,2); ind=cell(1,2); sz=1;

% Consistent set C=lcm if gcm=null
if isempty(gcm) 
    C{1,1}=lcm; ind{1,1}=zeros(1,length(lcm))+1;

% Consistent set C=gcm if lcm=null
elseif isempty(lcm) % C=gcm if lcm=null
    C{1,1}=gcm; ind{1,1}=zeros(1,length(gcm));

% Consistent set C=GL is itself consistent, maxG < minL
elseif max(gcm)<min(lcm) 
    C{1,1}=[gcm lcm]; ind{1,1}=[zeros(1,length(gcm)) zeros(1,length(lcm))+1];

% No consistent set is detected. Compute_consistent_sets method determines consistent subsets of GL
else
    [C,ind,sz]=compute_consistent_sets(gcm,lcm);
end