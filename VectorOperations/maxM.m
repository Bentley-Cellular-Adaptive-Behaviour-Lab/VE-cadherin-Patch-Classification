% function[mi,i,j]=minM(M)
%
% function finds the maximum, mi and row and column indices 
% of the maximum of a matrix M

function[mia,i,j]=maxM(M)
[ms,is]=max(M);
[ma,j]=max(ms);
i=is(j);