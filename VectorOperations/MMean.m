% Function which calculates the mean of a matrix M

function[MAvg]=MMean(M)

[X,Y]=size(M);
Tot=X*Y;
MAvg=(sum(sum(M)))/Tot;