function[st,es,ls]=GetConsecutivePoints(x,gap)
if(nargin<2) gap=1; end;
d=diff(x);
bps=find(d>gap);

if(isempty(bps)) 
    st=1;
    es=length(x);
    ls=es;
else
    st=[1 bps+1];
    es=[bps length(x)];
    ls=es-st+1;
end