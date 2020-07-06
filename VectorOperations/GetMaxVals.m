% function GetMaxVals(M,n,Ties)which takes a matrix M and returns the top n values 
% of the matrix sorted in descending order together with thier i and j entries.
% If Ties>0, the algorithm also returns values which tie with the n'th highest

function[SortedM]=GetMaxVals(M,n,Ties)

if(nargin<3)
   Ties=0;
end
[Gam,C,Vals]=find(M);
N=length(Vals);
if(n>N)
   n=N;
end
[SVals,Is]=sort(Vals);
SGam=Gam(Is);
SC=C(Is);
LastOne=SVals(N-n+1);
if(Ties==1)
   while((N-n>0)&(SVals(N-n)>=LastOne))
      n=n+1;
   end
end
SortedM=[invert(SVals(N-n+1:N))' invert(SGam(N-n+1:N))' invert(SC(N-n+1:N))']; 
