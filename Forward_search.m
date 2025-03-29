function [PF_,success] = Forward_search(PF,eL,X)
% This method searches forward for uniform sets
% If X(s_i, s_(i+1)) is not uniform, it tests the X(s_i, s_j) , j > i for uniformity .
PF_=PF(PF<=eL);success=false;
eR_ind=find(PF==eL)+2;
while eR_ind<=length(PF)
    eR=PF(eR_ind);
    xx=intersect(X(X>=eL),X(X<=eR));
    if ks(xx)==1
        PF_=eR;
        success=true;
        return   
    end
    eR_ind=eR_ind+1;    
end
if success==false
    PF_=[];
end
end