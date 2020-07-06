% function[a] = Matrix2Array(m)
% function which turns a 2d matrix into a 1d array (funtion uses find: not
% sure if there's a quicker way as yet

function[a] = Matrix2Array(m)
mini=min(min(m));
[i,j,v]=find(m+mini+1);
a=[v-mini-1]';