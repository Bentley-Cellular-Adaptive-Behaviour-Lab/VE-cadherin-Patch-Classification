% function[ms,is]=GetOpts(x)
% function which locates all the optima of a vector x 

function[ms,is,depths,x]=GetOpts(x,h)

[ms,is,depths]=GetOs(x);
if(nargin>1)
    small=find(abs(depths)<h);
    while(~isempty(small))
        [f,ind]=min(abs(depths(small)))
        x(is(ind))=mean([x(is(ind)-1) x(is(ind)+1)]);
        [ms,is,depths]=GetOs(x);
        small=find(abs(depths)<h);
    end
end

function[ms,is,depths]=GetOs(x)
d=diff(x);
pos2neg=[d 0].*[0 d];
is=find(pos2neg<0);
ms=x(is);
newm=[x(1) ms x(end)];
fs=diff(newm);
for i=1:length(is)
    [d,j]=min(abs(fs(i:i+1)));
    depths(i)=fs(i+j-1);
end