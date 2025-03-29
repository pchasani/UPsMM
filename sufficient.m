function   [P_,success, notUU]=sufficient(P,X)
% Input:  P: convex or concave sets
%         X: 1-d dataset
% Output: P_: sufficient set of points
%         success: true if P_ is sufficent, otherwise false 
%         notUU:

% This method determines sufficient subsets of convex and concave sets

notUU=[];
success=true;
xx=intersect(X(X>=P(1)),X(X<=P(length(P))));
if ks(xx)==1
    P_=[P(1) P(length(P))];
    return
end
P_=P(1);
while max(P_)~=max(P)
    eR=P(min(find(P>max(P_))));
    xx=intersect(X(X>=max(P_)),X(X<=eR));
    if ks(xx)==1
        P_=[P_ eR];
    else
        [PF,success] = Forward_search(P,max(P_),X);
        if success==true
            P_=[P_ PF];
        else
            [PB,success] = Backward_search(P_,eR,X);
            if success==false
                notUU=[notUU; [max(P_) eR]];
                P_=[P_ eR];
            else
                P_=PB;
            end
        end
    end
end
if ~isempty(notUU)
    P_=[]; success=false;
end