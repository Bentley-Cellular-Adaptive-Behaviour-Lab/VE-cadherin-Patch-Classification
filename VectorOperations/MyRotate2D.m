% function[newx]=MyRotate2D(x,thet,Pos)
% function to rotate all points in x=(x,y) ie columns clockwise thru thet
% radians about the (optional) centre Pos (default = (0,0))

function[newx]=MyRotate2D(x,thet,Pos)
if(isempty(thet)||isequal(thet,0)||isnan(thet))
    newx=x;
    return;
end
if(nargin<3) 
    Pos = [0,0]; 
end;
c=cos(thet);
s=sin(thet);
M=[c s;-s c];
P=repmat(Pos,size(x,1),1);
newx=(x-P)*M' + P;