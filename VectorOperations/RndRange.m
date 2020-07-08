% function[rndnums] = RndRange(sze,r1,r2)
%
% OR function[rndnums] = RndRange(sze,R)
% where r1=R(1) and r2=R(2)
%
% function to generate a matrix of size sze uniformly distributed 
% random numbers in the range [r1, r2)

function[rndnums] = RndRange(sze,r1,r2)
if(nargin<3) 
    r2=r1(2);
    r1=r1(1);
end
rndnums = r1+rand(sze)*(r2-r1);