% function[ds]=SpherDist(x,y)
% function returns the distance between the points in x and y
% where each row of x and y is a vector in spherical polars (th,phi,r)
% if x is 1 point only, returns the distance from 

function[ds]=SpherDist(x,y)
if(size(x,1)==1) x=ones(size(y,1),1)*x; end
t1=x(:,1);
p1=x(:,2);
r1=x(:,3);
t2=y(:,1);
p2=y(:,2);
r2=y(:,3);
ds=sqrt(r1.^2+r2.^2-2*r1.*r2.*(cos(p1).*cos(p2).*cos(t1-t2)+sin(p1).*sin(p2)));
