function [h,p,kstat,cv]=ks(x)
% Kolmogorov-Smirvov test for checking data uniformity

if length(x)>1
    dist = makedist('uniform','Lower',min(x),'Upper',max(x));
    [h,p,kstat,cv] = kstest(x,'CDF',dist,'Alpha',0.01);
    h=1-h;
else
    h=1;
end

end