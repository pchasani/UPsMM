function myPlot(X,Prior,Posterior,K,a,r,g,w,mode)

[D N]=size(X);

if  D > 2
   return;
end

if D==1
     hold off;
     figure(mode+1);
     plot(X,zeros(N,1),'k+');
     hold on;
     dom=max(X)-min(X);
     Y = linspace(min(X)-0.15*dom, max(X)+0.15*dom, 500);
     Fx=mixfun(Y, a, r, g, w, Prior);
     plot(Y,Fx,'k-','LineWidth',1.5);
     drawnow;
     return;
end

[MAX I]=max(Posterior');
colors=['r.';'g.';'m.';'b.';'c.';'y.';'k.'];

figure(mode);
if (mode == 1)
    plot(X(1,:),X(2,:),'r.','LineWidth',1.5);
    hold on;
else
    for i=1:K
        v=X(:,find(I==i));
        if (~isempty(v))
            plot(v(1,:),v(2,:),colors(mod(i-1,7)+1,:),'LineWidth',1.5);
            hold on;
        end
    end
end



for i=1:K
    hold on;
    Wk = reshape(w(:,i),D,D);
    rrectangle(Wk,a(:,i),r(:,i));
end

Xmin=min(X(1,:)); Xmax=max(X(1,:));
Ymin=min(X(2,:)); Ymax=max(X(2,:));

xt = (max(X(1,:)) - min(X(1,:))) / 10;
yt = (max(X(2,:)) - min(X(2,:))) / 10;
axis equal;
axis([Xmin-xt Xmax+xt  Ymin-yt Ymax+yt]);
drawnow;
hold off;

if (mode == 2)
    figure(3);
    [Px,Py] = meshgrid(Xmin-xt:0.2:Xmax+xt, Ymin-yt:0.2:Ymax+yt);
    [dimX dimY] = size(Px);
    Z=zeros(dimX,dimY);

    for c=1:K
        for i=1:dimX
            for j=1:dimY
                x=[Px(i,j);Py(i,j)];
                Z(i,j) = dsigmoidpdf(x, a(:,c), r(:,c), g(:,c), w(:,c));
            end
        end
        surf(Px,Py,Z,'EdgeColor','black')
        camlight left; lighting phong
        hold on;
    end
% 
%     if (D==1)
%         for k=1:K
%             fun=@(y) (1/(1+exp(-g(k)*(y-a(k)))))-(1/(1+exp(-g(k)*(y-a(k)-r(k)))));
%             fplot(fun,[Xmin-xt Xmax+xt]);
%             hold on;
%         end
%     end
end