% function[r]=Range(x,matornot)
% returns the range of the data in the vector or matrix x
% if matornot = 1
function[r]=Range(x,matornot)

if(nargin<2) matornot=0; end;

if(matornot) r=max(x)-min(x);
else r=max(max(x))-min(min(x));
end