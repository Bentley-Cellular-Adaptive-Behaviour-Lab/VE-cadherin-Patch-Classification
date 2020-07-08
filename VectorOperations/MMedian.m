% Function which calculates the median of a matrix M

function[MMed]=MMedian(M)

[X,Y]=size(M);
V=[];
for i=1:X
   V=[V M(i,:)];
end

MMed=median(V);