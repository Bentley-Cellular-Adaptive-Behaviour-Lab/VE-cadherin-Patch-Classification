% function[mi,i,j]=minM(M)
%
% function finds the minimum, mi and row and column indices 
% of the minimum of a matrix M

function[mi,i,j]=minM(M)
[ms,is]=min(M);
[mi,j]=min(ms);
i=is(j);