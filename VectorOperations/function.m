% function which takes a matrix of column vectors M and returns them normalised
% ie so that they have unit length
% function(NormM)=Normalise(M)

function(NormM)=Normalise(M)

Totals = sqrt(sum(M.^2));
NormM=M./(ones(size(M,1),1)*Totals);