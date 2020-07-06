function[Vels,Speeds,Cent_Os]=VelocityAndSpeed(x,t)
v1=MyGradient(x(:,1),t);
v2=MyGradient(x(:,2),t);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

% this is the same as the non-local MyGradient but i put it here also 
% to avoid issues later
%
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

