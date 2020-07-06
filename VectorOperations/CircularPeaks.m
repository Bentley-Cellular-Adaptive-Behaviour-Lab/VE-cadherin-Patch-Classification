function[mb,mx,ma]=CircularPeaks(b,xs);
a=[b(end) b b(1)];
[ma,mi,mav]=findextrema_diff(a);
if(isempty(ma)) mb=[];mx=[];ma=[];
else
    ma=ma-1;
    [mb,is]=sort(mav,'descend');
    ma=ma(is);
    mx=0.5*(xs(max(1,floor(ma)))+xs(ceil(ma)));
end