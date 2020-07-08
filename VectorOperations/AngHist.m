% plots an angular histogram
% 
% typical use for 360 degrees is:
% AngHist(t)  % if you want to plot and 
% AngHist(t,[],[],0) if you don't

function[y,x]=AngHist(t,c,NoWrap,plotting)
if((nargin<2)||isempty(c)) 
    c=0:10:360; 
else
    c=0:c:360;
end

if(nargin<4) 
    plotting=1; 
end;
[y,x]=hist(mod(t,360),c);

binw=diff(c);
halfgap1=binw(1)/2;
halfgap2=binw(end)/2;
edge1=c(1)-halfgap1;
edge2=c(end)+halfgap2;
if((edge1<0)&&(edge2>360))
    y(1)=y(1)+y(end);
    y=y(1:end-1);    
    x=x(1:end-1);
    binw=binw(1:end-1);
    binw(end)=c(1)+halfgap1+360-c(end)+halfgap2;
end
if(range(binw)>1e-6)
    disp('warning: bins are unequal widths')
end
if((nargin<3)||isempty(NoWrap)||(~NoWrap))
    es=find(x>180);
    x(es)=x(es)-360;
    [x,is]=sort(x);
    y=y(is);
end
if(plotting)
    bar(x,y);
    axis tight
end