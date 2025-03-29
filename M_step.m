function M_step

global Prior Posterior;
global a r g w X;
global K D N BG;

sum1=0;
for i=1:N
    for j=1:K
        sum1=sum1+Posterior(i,j)*log(Prior(j));
        %fprintf('Prior(%d)=%f\n',j,Prior(j));
    end
end

Prior=sum(Posterior,1)'/N;
%fprintf('\tSUM of PRIORS = %g \n',sum(Prior));
%fprintf('\tPrior sum1 = %.15f\n',sum1);

sum2=0;
for i=1:N
    for j=1:K
        sum2=sum2+Posterior(i,j)*log(Prior(j));
    end
end
%fprintf('\tPrior sum2 = %.15f\n\n',sum2);

if (sum2 < sum1)
    %fprintf('THE PRIOR NOT PROPERLY UPDATED.........\n');
end
% Medium-Scale Optimization.
% uses the BFGS Quasi-Newton
options = optimset('LargeScale','off','GradObj','on','GradConstr','off',...
'Display','on','DerivativeCheck','off','MaxFunEvals',30,'MaxIter',100); 
K=K-BG;
p0 = [a(:,1:K);r(:,1:K);g(:,1:K)];  % Starting guess
        
[f G]=LLc(p0);
%fprintf('PRIN: f = %f\n',f);

[p,fval] = fminunc(@LLc,p0,options);

[f G]=LLc(p);
%fprintf('META: f = %f\n\n\n',f);

a(:,1:K)=p(1:D,:); 
r(:,1:K)=p((D+1):2*D,:); 
g(:,1:K)=p((2*D+1):3*D,:);

K=K+BG;
