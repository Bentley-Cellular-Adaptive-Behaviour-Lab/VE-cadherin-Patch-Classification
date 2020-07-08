% function[NM] = RemoveRow(M,i,vs)
% function which removes rows i from matrix M
%
% if vs is defined, it will delete these rows from M

function[NM] = RemoveRow(M,i,vs)
if(nargin==3) i=MatchRows(M,vs); end;
is = setdiff([1:size(M,1)],i);
NM = M(is,:);