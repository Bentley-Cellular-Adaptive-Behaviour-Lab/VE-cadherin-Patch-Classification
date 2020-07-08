% function[h1]=PlotObject(Object,col,lw)
%
% function to plot an Object from GetNestetc. Gets called from
% PlotNestLMObjects
%
% could add to the closed field to do something with plotting a marker
% could also do something here fir the circle if you want to plot the
% centre
function[hall,swid]=PlotObject(Object,col,lw,axhdls)
hall=[];
swid=[];
pts=Object.pts;
NumPts=size(pts,1);
if(isempty(pts)||(sum(~isnan(pts(:)))==0))
    return;
end

if((nargin<3)||isempty(lw))
    if(~isfield(Object,'LineWidth'))
        lw=0.5;
    else
        lw=Object.LineWidth;
    end
end
if(~isfield(Object,'closed'))
    Object.closed=1;
end

if((nargin<2)||isempty(col))
    if(~isfield(Object,'col'))
        col='r';
    else
        col=Object.col;
    end
end
if(ismember(ObjectType(Object),[1,2]))
    while(size(col,1)<NumPts)
        col=[col;col];
    end
end

if(nargin<4)
    axhdls=gca;
end

for i=1:length(axhdls)
    subplot(axhdls(i))   
    isho=ishold;
    if(ObjectType(Object)==1) % is a circle
        h1=[];
        for j=1:NumPts
            h1=[h1,MyCircle(pts(j,:),Object.wid(j)*0.5,col(j,1))];
            if(~ishold)
                hold on;
            end
        end
        set(h1,'LineWidth',lw);
        if(Object.closed)
            for j=1:NumPts
                h1=[h1,plot(pts(j,1),pts(j,2),col(j,:))];
            end
        end
    elseif(ObjectType(Object)==2)
        [h1,swid]=PlotStripe(pts,Object.Cyl_Wid,Object.Cyl_pts,col);
    elseif(Object.closed==1)
        is=[1:NumPts,1];
        h1=plot(pts(is,1),pts(is,2),col,'LineWidth',lw);
    else
        if(size(pts,1)>1)
            h1=plot(pts(:,1),pts(:,2),col,'LineWidth',lw);
        else
            h1=plot(pts(:,1),pts(:,2),col,'MarkerSize',13);
        end
    end
    if(isfield(Object,'MarkerSize'))
        set(h1,'MarkerSize',Object.MarkerSize);
    end
    hall=[hall;h1'];
    if(isho)
        hold on;
    else
        hold off;
    end
end
