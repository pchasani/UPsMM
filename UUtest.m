%------------
% Author: Paraskevi Chasani
% "The UU-test for statistical modeling of unimodal data" by Paraskevi Chasani and
% Aristidis Likas
% 2021-22
%------------
% Input: X: 1-d continuous dataset
% Output: S: subset of X, such that the cdf PL_S(X) is unimodal and
% sufficient. S is null in case of multimodality.

function [S,notUU] = UUtest(X, Fcdf)
X=sort(X); 
% success = true in case of unimodality
SG=[]; SL=[]; success=true;
PI=[min(X) max(X)];
S=[]; 
[SG_,PI_,SL_,success,notUU]=UU(SG,PI,SL,X, Fcdf);
S=unique(sort([SG_ PI_ SL_]));      
if success
    notUU=[];
else
    notUU = unique(notUU,'rows');
end
