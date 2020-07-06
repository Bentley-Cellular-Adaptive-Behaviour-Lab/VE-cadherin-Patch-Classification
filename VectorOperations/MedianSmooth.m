function[sv]=MedianSmooth(x,n,option)
[r,c]=size(x);
if(r>1) x=x'; end;
if(length(x)<n) n=length(x); end;
if (nargin < 3) sv=medfilt2(x,[1,n]); 
else sv=medfilt2(x,[1,n],option);
end;