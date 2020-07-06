% function[c,rad] = FitCircle(im,sp,axw)
% 
% Function to interactively fit a circle to some part of image im
% Returns centre and radius in c and rad. 
%
% Optional arguments are sp=[c rad] and are initial guess of circle
% and axw which is initial axis range 
%
% USAGE: [c,rad] = FitCircle(im)
%        [c,rad] = FitCircle(im,[100,120,400])
%        [c,rad] = FitCircle(im,[100,120,400],[101,500,1,400])
%
% TODO (if needed): 1) change sp initialisation to take c or rad only. 
%                   2) allow altering of axis width by clicking
%                   3) change axw so its a width not a range

function[c,rad] = FitCircle(im,sp,axw)
[h,w]=size(im);
imagesc(im);
if(nargin==3) axis(axw); end;
axis equal;
hold on;
colormap gray
if(nargin<2) [c,rad,t]=GetStartPoint; 
else 
    c=sp(1:2);
    rad=sp(3);
    t=pi/2;
end
[x,y]=pol2cart(t,rad);

axl=2;
ad=0.5;
while 1
    [x,y]=pol2cart(t,rad);
    e1=c+[x,y];
    e2=c-[x,y];
    pts=[e1;c;e2];
    h=MyCircle(c,rad,'r');
    h2=plot(pts(1),pts(2),'r.');
    title('Click near each pt to move; return to end; right click to zoom');
    xlabel('or: g/h = left/right; i,j = up/down; a,s =bigger/ smaller'); 
    [i,b,p,q]=GetNearestClickedPt(pts);
    if(isempty(b)) break;
    elseif(b==3)
        title('click distance of zoom;')
        xlabel('return to zoom out')
        [p2,q2,b]=ginput(1);
        if(isempty(b)) 
            x1=c-axl*rad;
            x2=c+axl*rad;
        else
            p1=[p,q];
            d=max(CartDist(p1,[p2,q2]),10);
            x1=p1-d;x2=p1+d;
        end
        AxX=round([x1(1) x2(1) x1(2) x2(2)]);
        axis(AxX);
%     elseif(isequal(char(b),'g')) c(1)=0.99*c(1);
%     elseif(isequal(char(b),'h')) c(1)=1.01*c(1);
%     elseif(isequal(char(b),'i')) c(2)=0.99*c(2);
%     elseif(isequal(char(b),'j')) c(2)=1.01*c(2);
%     elseif(isequal(char(b),'a')) rad=0.99*rad;
%     elseif(isequal(char(b),'s')) rad=1.01*rad;
    elseif(isequal(char(b),'g')) c(1)=c(1)-ad;
    elseif(isequal(char(b),'h')) c(1)=ad+c(1);
    elseif(isequal(char(b),'i')) c(2)=-ad+c(2);
    elseif(isequal(char(b),'j')) c(2)=ad+c(2);
    elseif(isequal(char(b),'a')) rad=-ad+rad;
    elseif(isequal(char(b),'s')) rad=ad+rad;
    else
        pts(i,:)=[p,q];
        rad=CartDist(c,[p,q]);
    end
    delete([h;h2]);
end
h=MyCircle(c,rad,'b');
h2=plot(c(1),c(2),'b.');
hold off;

function[c,rad,t]=GetStartPoint
title('Click centre then a point on the radius')
[x,y]=ginput(2);
c=[x(1),y(1)];
rad=CartDist(c,[x(2),y(2)]);
t=cart2pol(x(2)-x(1),y(2)-y(1));