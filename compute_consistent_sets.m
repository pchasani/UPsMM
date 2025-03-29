function [C,ind,sz]=compute_consistent_sets(gcm,lcm)
% Input:  gcm and lcm points
% Output: C: consistent sets
%         ind: indexes of points in C (gcm->0, lcm->1)
%         sz: number of consistent sets 

% This method obtains consistent subsets by removing all gcm points that lie after the first lcm point
% and by removing all lcm points that lie before the last gcm point

pos=[];
allsort=[];
allsort=(sort([gcm lcm]))';
gl_ind=ismember(allsort,lcm);

for i=1:length(gl_ind)-1
    if (gl_ind(i)==0 && gl_ind(i+1)==1), pos=[pos; i]; end
end

sz=length(pos);
C=cell(1,length(pos)); ind=cell(1,length(pos));

for i=1:length(pos)    
    for j=1:pos(i)
        if gl_ind(j)==0
            C{1,i}=[C{1,i} allsort(j)];
            ind{1,i}=[ind{1,i} 0];
        end
    end    
    
    for j=pos(i)+1:length(allsort)
        if gl_ind(j)==1
            C{1,i}=[C{1,i} allsort(j)];
            ind{1,i}=[ind{1,i} 1];
        end
    end   
    
end