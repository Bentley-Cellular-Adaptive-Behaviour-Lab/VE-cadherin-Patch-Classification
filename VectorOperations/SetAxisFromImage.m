function[AxX]=SetAxisFromImage(im,w1,w2)
h=size(im,1);
wi=size(im,2);

if(nargin<2)
    w1=round(0.1*wi);
    w2=round(0.1*h);
elseif(nargin==2)
    w2=w1;
end

vx=find(sum(im));
if(sum(vx)==0)
    AxX=[0 wi 0 h];
    return;
end
vy=find(sum(im,2));
a=max([min(vx)-w1, min(vy)-w2],[0 0]);
b=min([max(vx)+w1, max(vy)+w2],[wi h]);
AxX=[a(1) b(1) a(2) b(2)];
axis(AxX)