function[sv]=SmoothVec(x,n,option)
if(length(n)==1)
    [r,c]=size(x);
    if((c==1)&&(r>1)) 
        x=x'; 
    end;
    if(length(x)<n) 
        n=length(x); 
    end;
    h=fspecial('average',[1,n]);
else
    h=fspecial('average',n);
end
if (nargin < 3) 
    sv=imfilter(x,h); 
else
    sv=imfilter(x,h,option);
end;