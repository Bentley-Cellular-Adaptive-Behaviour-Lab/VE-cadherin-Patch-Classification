%  function[g]=MyGradient(y,x,ang)
%
% function which calculates gradient of y at points x
% Basically, calls gradient but divides by appropriate spacing
% 
% if ang = 1 (default 0) does angular differences

function[g]=MyGradient(y,x,ang)
if(isempty(y)) 
    g=[]; 
    return;
elseif(length(y)==1)
    g=0;
    return;
end;

if(size(x,1)~=1) x=x'; end; 
if(size(y,1)~=1) y=y'; end; 

d=diff(x);
sp=[d(1) 0.5*(d(2:end)+d(1:end-1)) d(end)];

if((nargin<3)||(ang==0)) 
    g=gradient(y)./sp;
else 
    g=gradient(AngleWithoutFlip(y)./sp);
end
