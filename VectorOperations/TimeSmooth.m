function[sv]=TimeSmooth(x,t,n)
r=size(x,1);
if(r>1) 
    x=x'; 
end;
d=n/2;
sv=zeros(size(t));
for i=1:length(t)
    % Could speed by only using t> < t(i)
    % Should strictly be < for 1st inequality
    is=((t(i)-d)<=t)&(t<=(t(i)+d));
    % Could do weighted smoothing based on times here
    sv(i)=mean(x(is));
end