% function[m]=VecDiv(a,v,rows)
% function to divide an array a by a row vector v. rows is optional and specifies 
% whther to divide each row of a by v (the default: working down the
% columns) or whether to divide each column. Rows = 1 is rows, 2 is columns

function[m]=VecDiv(a,v,rows)
[x,y]=size(a);
if((nargin<3)|(rows~=2)) m=a./(ones(x,1)*v);
else m=a./(v'*ones(1,y));
end