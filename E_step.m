function E_step

global Prior Posterior;
global a r g w X;
global K  N; 
global NOISE_THRESHOLD step ex;


for i=1:N
    denominator=0;
    totalp = 0;
    for k=1:K
        p_i_j=dsigmoidpdf(X(:,i), a(:,k), r(:,k), g(:,k), w(:,k));
        denominator=denominator+Prior(k)*p_i_j;
        totalp=totalp+p_i_j;
    end

    for j=1:K
        numerator=Prior(j)*dsigmoidpdf(X(:,i), a(:,j), r(:,j), g(:,j),w(:,j));
        if totalp > NOISE_THRESHOLD 
            Posterior(i,j) = numerator/denominator;
        else
%            fprintf('\tpoint %d excluded...\n',i);
            Posterior(i,1:K)=-1;
            break;
        end
    end
end

%NOISE_THRESHOLD=10^(-ex/(1-exp(-0.3*step+eps)))

Noise=find(sum(Posterior,2)<0);

Posterior(Noise,:)=[];
X(:,Noise)=[];

N=N-length(Noise);

%fprintf('\tN = %g\n',sum(sum(Posterior)));

