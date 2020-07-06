% function[ms,is]=GetOpts(x)
% function which locates all the optima of a vector x 

function[ms,is]=GetOpts(x)
d=diff(x);
pos2neg=[d 0].*[0 d];
is=find(pos2neg<0);
ms=x(is);