function p=dsigmoidpdf(x, a, r, g, w) 
global D;
%  g(g>10) = 10;  g(g<-10) = -10;
Wk=reshape(w,D,D);
z=Wk*x;

p=1;
for d=1:D
   sigm1 = 1/(1+exp(-(g(d)^2)*(z(d)-a(d))));
   sigm2 = 1/(1+exp(-(g(d)^2)*(z(d)-a(d)-r(d)^2)));
   pdf=(norm(Wk(d,:))*(sigm1-sigm2)/(r(d)^2));
 
   p=p*pdf;
end
if p < 0 
    fprintf('ERROR incorrect pdf \n\n');
end