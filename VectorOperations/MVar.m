% Function which calculates the mean of a matrix M

function[mvar,mavg]=MVar(M)

[X,Y]=size(M);
mavg=MMean(M);
Tot=X*Y;
mvar=(sum(sum(M.^2)))/Tot-mavg^2;