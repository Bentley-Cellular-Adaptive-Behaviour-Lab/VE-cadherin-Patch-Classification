% function[ds,vs]=CartDist(x,y)
% function returns the cartesian distance between the points in x and y
% where either each row of x and y is a vector
% or y is a single vector
%
% if only x is entered, returnd the length of each row of x

function[ds,vs]=CartDist(x,y)
if(nargin==1) 
    vs=x;
else
    if(isequal(size(x),size(y))) 
        vs=x-y;
    else
        vs=x - ones(size(x,1),1)*y;
    end
end
ds=sqrt(sum(vs.^2,2));
