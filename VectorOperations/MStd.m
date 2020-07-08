% Function which calculates the mean of a matrix M

function[mstd,mavg]=MStd(M)

[X,Y]=size(M);
mavg=MMean(M);
Tot=X*Y;
mstd=sqrt((sum(sum(M.^2)))/Tot-mavg^2);