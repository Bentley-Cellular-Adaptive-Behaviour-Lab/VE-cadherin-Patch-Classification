% function[lhdl] = MyCircle(x,y,Rad,col,NumPts,fillc)
%
% Function draws circles of radius Rad(i) at x(:,i),y(:,i). 
% col is colour, NumPts the number of points to draw the circle
% defaults are blue and 50 and fills it if fillc = 1 (default 0)
%
% if x is a 2D row vector, it uses x as position and other parameters 
% shift across one eg y is rad
%
% function returns ldhl, handles to the lines
function[lhdl] = MyCircle(x,y,Rad,col,NumPts,fillc)
if(isempty(x))
    lhdl=[];
    return;
end
ho=ishold;
if(size(x,2)==2)
    if(nargin<5) 
        fillc=0;
    else
        fillc=NumPts;
    end
    if((nargin<4)||isempty(col)) 
        NumPts=50;
    else
        NumPts=col;
    end;
    if(nargin<3) 
        col = 'b';
    else
        col=Rad;
    end;
    Rad=y;
    y=x(:,2);
    x=x(:,1);
else
    if(nargin<6) 
        fillc=0; 
    end;
    if((nargin<5)||isempty(NumPts)) 
        NumPts=50; 
    end;
    if(nargin<4) 
        col = 'b'; 
    end;
end

Thetas=0:2*pi/NumPts:2*pi;
lhdl=zeros(length(Rad));
if(size(col,1)==1)
    for i=1:length(Rad)
        [Xs,Ys]=pol2cart(Thetas,Rad(i));
        if(fillc) 
            fill(Xs+x(i),Ys+y(i),col);
            hold on;
        end
        if(ischar(col))
            lhdl(i)=plot(Xs+x(i),Ys+y(i),col);
        else
            lhdl(i)=plot(Xs+x(i),Ys+y(i),'Color',col);
        end
        % THIS ERROR LOOKS TO BE A VERSION CHANGE: BELOW FOR NEW VERSIONS
%         lhdl(i)=plot(Xs+x(i),Ys+y(i),col);
        hold on
    end
else
    for i=1:length(Rad)
        [Xs,Ys]=pol2cart(Thetas,Rad(i));
        if(fillc) 
            fill(Xs+x(i),Ys+y(i),col(i,:));
            hold on;
        end
        if(ischar(col(i,:)))
            lhdl(i)=plot(Xs+x(i),Ys+y(i),col(i,:));
        else
            lhdl(i)=plot(Xs+x(i),Ys+y(i),'Color',col(i,:));
        end
        % THIS ERROR LOOKS TO BE A VERSION CHANGE: BELOW FOR NEW VERSIONS
%         lhdl(i)=plot(Xs+x(i),Ys+y(i),col(i,:));
        hold on
    end
end
if(~ho) 
    hold off; 
end;