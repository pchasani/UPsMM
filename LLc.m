function [f G]=LLc(p)

global Posterior;
global X K;
global w;


[D N] = size(X);
a=p(1:D,:); r=p((D+1):2*D,:); g=p((2*D+1):3*D,:); 

tmp = 0;
nconst=zeros(1,D);

for k=1:K
    wk = reshape(w(:,k),D,D);
    for d=1:D
        nconst(d)=norm(wk(d,:));
    end
    
    Z=wk*X;
    for i=1:N
        for d=1:D
            sigm1 = 1/(1+exp(-(g(d,k)^2)*(Z(d,i)-a(d,k))));
            sigm2 = 1/(1+exp(-(g(d,k)^2)*(Z(d,i)-a(d,k)-r(d,k)^2)));

            if (sigm1-sigm2 ~= 0)
                log_dsigmpdf = log(nconst(d))+log(sigm1-sigm2)-2*log(r(d,k));
            else
                log_dsigmpdf = -(10^9)-2*log(r(d,k))+log(nconst(d));
            end
            
            tmp = tmp + Posterior(i,k)*log_dsigmpdf;
        end
    end
end
f=-tmp;


Ga=zeros(D,K); Gr=zeros(D,K); Gg=zeros(D,K);
for k=1:K
    wk = reshape(w(:,k),D,D);
    Z=wk*X;
    for i=1:N
        for d=1:D
            t1=(g(d,k)^2)-((g(d,k)^2)/(exp((g(d,k)^2)*(Z(d,i)-a(d,k)))+1));
            t2=(g(d,k)^2)/(exp((g(d,k)^2)*(Z(d,i)-a(d,k)-(r(d,k)^2)))+1);
            Ga(d,k)=Ga(d,k)+Posterior(i,k)*(t1-t2);

            t1=(2*r(d,k)*(g(d,k)^2))/(1-exp(-(g(d,k)*r(d,k))^2));
            t2=-((2*r(d,k)*(g(d,k)^2))/(exp((g(d,k)^2)*(Z(d,i)-a(d,k)-(r(d,k)^2)))+1))-(2/r(d,k));
            Gr(d,k)=Gr(d,k)+Posterior(i,k)*(t1+t2);

            t1=-2*g(d,k)*Z(d,i)+2*g(d,k)*a(d,k)+((2*g(d,k)*(r(d,k)^2))/(1-exp(-(g(d,k)*r(d,k))^2)))+...
            ((2*g(d,k)*(Z(d,i)-a(d,k)))/(exp((g(d,k)^2)*(Z(d,i)-a(d,k)))+1));
            t2=(2*g(d,k)*(Z(d,i)-a(d,k)-(r(d,k)^2)))/(exp((g(d,k)^2)*(Z(d,i)-a(d,k)-(r(d,k)^2)))+1);
            Gg(d,k)=Gg(d,k)+Posterior(i,k)*(t1+t2);
        end
    end
end

G=[-Ga;-Gr;-Gg];

