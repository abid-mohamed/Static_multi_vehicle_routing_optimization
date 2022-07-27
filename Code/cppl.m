%% cherche le client le plus loint ou le plus proche à la n ème position.
% cppl(0,list,dc0,-1) : cherche les client les plus loint du vh qui se
%                      trouve au client 0.
% cppl(24,list,dc0,1) : cherche les client les plus proche du vh qui se
%                      trouve au client 24.

function x=cppl(cust0,list0,dc0,n)
list=list0;
% k=find(list==cust0);
% list(k,:)=[];
[nl,nc]=size(list);
for i=1:nl
    list(i,2)=dc0(cust0+1,list(i,1)+1);
end
x = sortrows(list,sign(n)*2);