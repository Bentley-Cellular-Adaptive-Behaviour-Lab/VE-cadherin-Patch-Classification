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

function[Object,h1,inp]=ClickAndAdjustObject(Object,cst,axL,lw,opt,asone,axhdls,im)
disp('adjust points by clicking in figure window. return in figure window to end')
inp=1;
if((nargin<3)||isempty(axL))
    axL=50;
end
if((nargin<4)||isempty(lw))
    lw=0.5;
end
if((nargin<5)||isempty(opt))
    opt=-1;
end
if((nargin<6)||isempty(asone))
    asone=0;
end
if((nargin<7)||isempty(axhdls))
    axhdls=gca;
end

orighdl=gca;
adp=0.005*axL;
if(ObjectType(Object)==1)
    isCircle=1;
    for i=1:length(Object.wid)
        if(isnan(Object.wid(i)))
            title('FIRST CLICK EDGE TO SET WIDTH','FontSize',14,'Color','r');
            [x,y]=ginput(1);
            Object.wid(i)=2*CartDist([x,y],Object.pts(i,:));
        end
    end

    if(opt>0)
        nopt=opt+max([Object.wid])/2;
    end
    naxL=axL+max([Object.wid])/2;
else
    nopt=opt;
    naxL=axL;
    isCircle=0;
end
adw=0.005*naxL;

astrs=['as one';'singly'];
origax=axis;
nObj=size(Object.pts,1);
while 1
    if(nargin>7)
        Object.pts=Constrain2Image(Object.pts,im);
    end
    h1=PlotObject(Object,cst,lw,axhdls);
    if(opt<0)
        ax=origax;
    else
        % zoom in on points
        a1=min(Object.pts,[],1)-nopt;
        a2=max(Object.pts,[],1)+nopt;
        ax=[a1(1) a2(1) a1(2) a2(2)];
    end
    
    for i=1:length(axhdls)
        subplot(axhdls(i))
        axis(ax);
    end
    if(isCircle)
        tst='click near centre of circle to adjust; return when done';
        xlabel('[ or ] decrease/increase width. r=set width')
    else
        tst='click near point to move; return when done';
    end
    ylabel(['enter a to move all the pts ' astrs(asone+1,:)])
    [adj,b,c,d]=GetNearestClickedPt(Object.pts,tst);
    if(adj==0)
        axis(origax)
        break;
    elseif(isequal(b,'a'))
        asone=mod(asone+1,2);
        delete(h1);
    elseif((isCircle)&&ismember(b,[91,93,114]))
        if(isequal(b,114))
            w=ForceNumericInput(['width = ' num2str(Object.wid(adj)) ...
                '; enter new value: '],1,1);
        elseif(isequal(b,91))
            w=Object.wid(adj)-adw;
        elseif(isequal(b,93))
            w=Object.wid(adj)+adw;
        end
        Object.wid=ones(size(Object.wid))*w;
        if(opt>0)
            nopt=opt+max([Object.wid])/2;
        end
        naxL=axL+max([Object.wid])/2;
        delete(h1);
    else
        while 1
            delete(h1)
            dif=[c,d]-Object.pts(adj,:);
            if(asone==0)
                % move singly
                Object.pts(adj,:)=[c,d];
            else
                % move as one
                Object.pts=Object.pts+ones(size(Object.pts,1),1)*dif;
            end
            
            subplot(orighdl)
            h1=PlotObject(Object,cst,lw,axhdls);
            a1=Object.pts(adj,:)-naxL;
            a2=Object.pts(adj,:)+naxL;
            axis([a1(1) a2(1) a1(2) a2(2)])
            xlabel('adjust by clicking or cursors; return ok')
            [c,d,b]=ginput(1);
            if(isempty(c))
                delete(h1)
                break;
            elseif(isequal(b,30))
                d=Object.pts(adj,2)-adp;
                c=Object.pts(adj,1);
            elseif(isequal(b,31))
                d=Object.pts(adj,2)+adp;
                c=Object.pts(adj,1);
            elseif(isequal(b,28))
                c=Object.pts(adj,1)-adp;
                d=Object.pts(adj,2);
            elseif(isequal(b,29))
                c=Object.pts(adj,1)+adp;
                d=Object.pts(adj,2);
            end
        end
    end
end

% % TODO could dosomethinge with a structure here to make this bit more
% % generic and plot different points in different linestyles
% function[h1]=PlotStuff(pts,cst,lw,closed,axhdls)
% h1=[];
% for i=1:length(axhdls)
%     subplot(axhdls(i))
%     if(closed)
%         is=[1:size(pts,1),1];
%         h=plot(pts(is,1),pts(is,2),cst,'LineWidth',lw);
%     else
%         h=plot(pts(:,1),pts(:,2),cst,'LineWidth',lw);
%     end
%     h1=[h1;h];
% end