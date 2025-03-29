function Px=mixfun(X, a, r, g, w, Prior)
% computes the pdf
K=size(Prior,1);
[D N]=size(X);

Lx=zeros(N,1);
isum=0;
for i=1:N
    isum=0;
    for k=1:K
        isum=isum+Prior(k)*dsigmoidpdf(X(:,i), a(:,k), r(:,k), g(:,k), w(:,k));
    end
    Px(i)=isum;
end
    



