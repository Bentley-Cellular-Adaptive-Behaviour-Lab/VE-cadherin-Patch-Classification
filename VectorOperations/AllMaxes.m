% function[ms]=AllMaxes(x,h)
% function which locates all the minima of a vector x and may do something
% with h if I get round to it

function[ms,is]=AllMaxes(x)
d=diff(x);
d2=del2(x);
pos2neg=[d 0].*[0 d];
allis=find(pos2neg<0);
mins=find(d2<0);
is=intersect(mins,allis);
ms=x(is);