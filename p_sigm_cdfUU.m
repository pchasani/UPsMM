function y = p_sigm_cdfUU(x,a,b,lambda,Prior)
lambda(lambda>100) = 100;
y=zeros(length(x),1);
for i=1:length(x)
    isum=0; isumf = 0;
    for j=1:length(a)
        isum = Prior(j)*p_sigm_cdf(x(i),a(j),b(j),lambda(j)); 
%           isum=isum+Prior(j)*p_sigm_cdf(x(i),a(j),b(j),lambda(j));  
        if sign(isum) .* isinf(isum) < 0
            isum =  10^(-3);
        elseif sign(isum) .* isinf(isum) > 0 || isnan(isum)        
            isum = 10^(-3);
        end
         isumf = isumf + isum;
    end
     y(i) = isumf;
% y(i) = isum;
end

