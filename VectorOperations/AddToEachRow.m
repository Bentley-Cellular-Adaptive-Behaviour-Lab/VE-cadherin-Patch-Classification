% function[newM]=AddToEachRow(M,v)
% 
% Function which adds the vector v to each row of the matrix M and returns
% it in newM. Is just simple matrix maths but I keep forgetting it
% if done with super big M, might be quicker with repmat
function[newM]=AddToEachRow(M,v)
[x,y]=size(M);
newM=M+ones(x,1)*v;
