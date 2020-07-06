% function[rndnums] = IRndRange(sze,r1,r2)
%
% OR function[rndnums] = IRndRange(sze,R)
% where r1=R(1) and r2=R(2)
%
% function to generate a matrix of size sze uniformly distributed 
% random integers in the range [r1, r2]

function[rndnums] = IRndRange(sze,r1,r2)
if(nargin<3) 
    r2=r1(2);
    r1=r1(1);
end
rndnums = r1+floor(rand(sze)*(r2-r1+1));