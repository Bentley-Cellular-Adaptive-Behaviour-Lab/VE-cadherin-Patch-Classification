% function[D]=Density2DAng(x,y,xs,ys)
% 
% returns an n x n matrix of densities of 2D angular data (in degrees)
% but centred on 0 OR 180 ie wraps at +/-180 or +/-360
%
% xs and ys are the edges of bins. Best to use eg -185:10:185 (as needs to
% go round all data) which will return data centred on -180:10:180
%
% if xs is undefined or empty, it uses -185:10:185
% if xs is a 2D vector, it uses the 2nd element as the spacing and the 
% 1st element to say if it starts at 0 or -180 eg:
%
% [0 10] returns data centred at 0:10:350
% [1 20] returns data centred at -160:20:180
% this bits not massively fully tested
%
% if ys is not entered it uses the xs value, if a 2D vector is as above

function[D,xs,ys,xps,yps]=Density2DAng(x,y,xs,ys)
% Get x and y between 0 and 180
x=mod(x,360);
x(x>=180)=x(x>=180)-360;
y=mod(y,360);
y(y>=180)=y(y>=180)-360;

% parse inputs

if((nargin<3)||isempty(xs)) 
    xs=[1 10]; 
end;

if(length(xs)==2)
    thd=xs(2);
    if(xs(1)==0) 
        xs=0:thd:360+thd-thd/2;
    else
        xs=-180:thd:180+thd-thd/2;
    end
end
if(nargin<4) 
    ys=xs; 
elseif(length(ys)==2)
    thd=ys(2);
    if(ys(1)==0) 
        ys=0:thd:360+thd-thd/2;
    else
        ys=-180:thd:180+thd-thd/2;
    end
end

if(xs(1)<-180)
    is=find(x<xs(2));
    x(is)=x(is)+360;
    xs=xs(2:end);
end
if(ys(1)<-180)
    is=find(y<ys(2));
    y(is)=y(is)+360;
    ys=ys(2:end);
end
if(xs(end)>360)
    is=find(x>xs(end-1));
    x(is)=x(is)-360;
    xs=xs(1:end-1);
end
if(ys(end)>360)
    is=find(y>ys(end-1));
    y(is)=y(is)-360;
    ys=ys(1:end-1);
end
% is=find(x>=360);
% x(is)=x(is)-360;
% is=find(y>=360);
% y(is)=y(is)-360;

m=length(ys)-1;
D=zeros(m,length(xs));
for i=1:m
    is=find((y>=ys(i))&(y<ys(i+1)));
    if(~isempty(is)) 
        D(i,:)=histc(x(is),xs); 
    end;
end
D=D(:,1:end-1);
xps=0.5*(xs(1:end-1)+xs(2:end));
yps=0.5*(ys(1:end-1)+ys(2:end));
% if(isequal(xs([1 end]),[-180 180]))
%     D(:,end)=D(:,end)+D(:,1);
%     D=D(:,[2 end]);
% elseif(isequal(xs([1 end]),[0 360]))
%     D(:,1)=D(:,end)+D(:,1);
%     D=D(:,[1 end-1]);
% end