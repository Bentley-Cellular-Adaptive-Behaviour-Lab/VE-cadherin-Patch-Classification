% function[pts,h1,dif,inp]=ClickAndAdjustPts(pts,cst,axL,lw,opt,closed,asone)
%
% this function takes a matrix of 2d points in pts (each row one point)
% it then plots them with colour specified by cst (default red line x)
% and allows the user to adjust them by clicking near one
% the prog then zooms in on that point (width specified by axL, default 50)
% and the user then clicks until done
%
% the other arguments are lw where you speficy line width (default 0.5)
% opt which if this is not -1 (default) specsifies how far to zoom out
% once a point has been adjusted, closed=1/0 which says whether to draw the
% shape closed or not ie connect the last point to the first (default not)
% and asone=1/0 (default 0) which says whether to move the points together
% or not
%
% the prog returns the adjusted points in pts, as well as a handle to the
% last plotted points and dif which is how much the point has moved
%
% It also has an output inp, which could be used to say if
% other keys have been pressed to exit but is currently unused
% 
% axhdls is used to set the axis handle. it defaults to gca if not
% if im is entered (either as an image or as a 2 element [ht wid] vector)
% it constrains the points to be within the image

function[pts,h1,inp]=ClickAndAdjustPts(pts,cst,axL,lw,opt,closed,asone,axhdls,im)
disp('adjust points by clicking in figure window. return in figure window to end')
inp=1;
if((nargin<2)||isempty(cst))
    cst='r-x';
end
if((nargin<3)||isempty(axL))
    axL=50;
end
adp=0.005*axL;
if((nargin<4)||isempty(lw))
    lw=0.5;
end
if((nargin<5)||isempty(opt))
    opt=-1;
end
if((nargin<6)||isempty(closed))
    closed=0;
end
if((nargin<7)||isempty(asone))
    asone=0;
end
if((nargin<8)||isempty(axhdls))
    axhdls=gca;
end
if((nargin<8)||isempty(axhdls))
    axhdls=gca;
end

orighdl=gca;

astrs=['as one';'singly'];
origax=axis;
while 1
    if(nargin>8)
        pts=Constrain2Image(pts,im);
    end
    h1=PlotStuff(pts,cst,lw,closed,axhdls);
    tst='click near point to move; return when done';
    if(opt<0)
        ax=origax;
    else
        % zoom in on points
        a1=min(pts,[],1)-opt;
        a2=max(pts,[],1)+opt;
        ax=[a1(1) a2(1) a1(2) a2(2)];
    end
    
    for i=1:length(axhdls)
        subplot(axhdls(i))
        axis(ax);
    end
    
    ylabel(['enter a to move all the pts ' astrs(asone+1,:)])
    [adj,b,c,d]=GetNearestClickedPt(pts,tst);
    if(adj==0)
        axis(origax)
        break;
    elseif(isequal(b,'a'))
        asone=mod(asone+1,2);
        delete(h1);
    else
        while 1
            delete(h1)
            dif=[c,d]-pts(adj,:);
            if(asone==0)
                % move singly
                pts(adj,:)=[c,d];
            else
                % move as one
                pts=pts+ones(size(pts,1),1)*dif;
            end
            h1=PlotStuff(pts,cst,lw,closed,axhdls);
            a1=pts(adj,:)-axL;
            a2=pts(adj,:)+axL;
            subplot(orighdl)
            axis([a1(1) a2(1) a1(2) a2(2)])
            xlabel('adjust by clicking or cursors; return ok')
            [c,d,b]=ginput(1);
            if(isempty(c))
                delete(h1)
                break;
            elseif(isequal(b,30))
                d=pts(adj,2)-adp;
            elseif(isequal(b,31))
                d=pts(adj,2)+adp;
            elseif(isequal(b,28))
                c=pts(adj,1)-adp;
            elseif(isequal(b,29))
                c=pts(adj,1)+adp;
            end
        end
    end
end

% TODO could dosomethinge with a structure here to make this bit more
% generic and plot different points in different linestyles
function[h1]=PlotStuff(pts,cst,lw,closed,axhdls)
h1=[];
for i=1:length(axhdls)
    subplot(axhdls(i))
    if(closed)
        is=[1:size(pts,1),1];
        h=plot(pts(is,1),pts(is,2),cst,'LineWidth',lw);
    else
        h=plot(pts(:,1),pts(:,2),cst,'LineWidth',lw);
    end
    h1=[h1;h];
end