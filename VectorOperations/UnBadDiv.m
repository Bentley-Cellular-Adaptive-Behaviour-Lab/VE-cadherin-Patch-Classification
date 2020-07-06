% function[x]=UnBadDiv(y,d)
% function which returns y./d but with zeroes where there are zeroes or 
% bad points in d 

function[x]=UnBadDiv(y,d)

l=(y./d);
l(find(isnan(l)))=0;
x=isfinite(l).*l;