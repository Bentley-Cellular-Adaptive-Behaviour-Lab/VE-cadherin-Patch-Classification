% function[m,v] = AngularStats(a)
%
% returns mean m and variance v of a set of angles in radians
% uses v = 1 - r where r is the mean of vectors represented by a

function[m,v] = AngularStats(a)
mx=mean(cos(a));
my=mean(sin(a));
[m,r]=cart2pol(mx,my);
v=2*(1-r);