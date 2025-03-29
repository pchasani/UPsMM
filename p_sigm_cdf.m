function y = p_sigm_cdf(x,a,b,lambda )
%  lambda(lambda>100) = 100;
y1=log(1+exp(-lambda*(x-a)));
y2=log(1+exp(-lambda*(x-b)));

y=(y1-y2)/(lambda*(b-a))+1;

end

