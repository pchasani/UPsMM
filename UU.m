function [SG_,PI_,SL_,success,notUU]=UU(SG,PI,SL,X,FCDF)
% Input:  SG = convex part, PI = intermediate part, SL = concave part, 
%         X = 1-d dataset
% Output: updated versions of SG, PI, SL if success (unimodality) = true

SG_=SG; SL_=SL; notUU=[];
PG=[];PL=[];
xx=intersect(X(X>=PI(1)),X(X<=PI(2)));

if ~isempty(FCDF) 
    ind_l = find(X==PI(1));
    ind_r = find(X==PI(2));
    Fcdf = FCDF(ind_l:ind_r);
    
else
    Fcdf = FCDF;
end

if ks(xx)==1 %uniform
    SG_=SG; PI_=PI; SL_=SL;
    success=true;
    return
end

% Compute gcm/lcm points 
[gcm,lcm,~,~,~]=compute_gcmlcm2(xx,Fcdf);

% Check if GL is consistent and obtain consistent subsets
[C,ind,sz]=consistent(gcm,lcm);

for i=1:sz
    pos=min(find(ind{1,i}==1));
    if ~isempty(pos)&&  pos~=1
        c=pos-1;
        PG=C{1,i}(1:c);
        PI_=[C{1,i}(c) C{1,i}(c+1)];
        PL=C{1,i}(c+1:length(C{1,i}));
        % Determine sufficient subsets of the convex part
        [PG_,success,notUU_]=sufficient(PG,X);
        if success==false
            notUU=[notUU; [notUU_ zeros(size(notUU_,1),1)]];
            continue
        end
        % Determine sufficient subsets of the concave part
        [PL_,success,notUU_]=sufficient(PL,X);
        if success==false
            notUU=[notUU; [notUU_ zeros(size(notUU_,1),1)+1]];
            continue
        end
        SG_=[SG_ PG_];
        SL_=[SL_ PL_];
    elseif pos==1
        PI_=[];
        PL=C{1,i};
        [PL_,success,notUU_]=sufficient(PL,X);
        if success==false
            notUU=[notUU; [notUU_ zeros(size(notUU_,1),1)+1]];
            continue
        end
        SL_=[SL_ PL_];
    else
        PI_=[];
        PG=C{1,i};
        [PG_,success,notUU_]=sufficient(PG,X);
        if success==false
            notUU=[notUU; [notUU_ zeros(size(notUU_,1),1)]];
            continue
        end
        SG_=[SG_ PG_];
    end
    if success==true
        if ~isempty(PI_)
            [SG_,PI_,SL_,success,notUU_]=UU(SG_,PI_,SL_,X,FCDF);
            if success==false
                notUU=[notUU; notUU_];
                continue;
            end
        end
        return
    end
end
if success==false
    PI_=[]; SG_=[]; SL_=[];
end

