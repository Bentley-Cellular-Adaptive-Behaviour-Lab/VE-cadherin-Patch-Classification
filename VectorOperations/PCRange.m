% function[v] = PCRange(X,pc)
% function which finds the range between the pcth percentile of X (which
% can be a vector or array) eg PCRange(X,90) returns the range covered by 
% 90% of the data in X, if MatrixOrVector is 1, PCRange returns the range
% in each column of X. Default is MatrixOrVector=0

function[v] = PCRange(X,pc,MatrixOrVector)

b=(100-pc)/2;
if(nargin<3) MatrixOrVector=0; end;
if(MatrixOrVector) v=Range(prctile(X,[b 100-b]),1);
else
    minval=min(min(X));
    if(minval>0) [i,j,vecval]=find(X);
    else 
        [i,j,v] = find(X+minval+1);
        vecval=v-minval-1;
    end
    v=range(prctile(vecval,[b 100-b]));
end
