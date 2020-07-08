% function[h1,h2]= AxisBreakY(x,y,BreakStart,BreakEnd,BreakWid)
% function returns 2 axes handles so that a figure can be plot with an axis break 
% between BreakStart and BreakEnd of width BreakWid (in normalised figure amount,
% default 0.075). x and y values are in x and y
%
% See also: AxisBreakX, AxisBreakYNoScale

function[h1,h2]= AxisBreakY(x,y,BreakStart,BreakEnd,BreakWid)

if (nargin<5) BreakWid = 0.075; end;

PLen=0.8;
covrange=BreakStart-BreakEnd+Range(y);
Ht1=(PLen-BreakWid)*(BreakStart-min(y))/covrange;
h1=subplot('position',[0.175 0.125 0.775 Ht1]);
plot(x,y);
Setbox(h1);
YLim([min(y),BreakStart]);
XLim([min(x),max(x)]);
Ht2=(PLen-BreakWid)*(max(y)-BreakEnd)/covrange;
h2=subplot('position',[0.175 0.125+Ht1+BreakWid 0.775 Ht2]);
plot(x,y);
YLim([BreakEnd,max(y)]);
XLim([min(x),max(x)]);
Setbox;
set(h2,'XTick',[],'XTickLabel',[],'XColor',[1 1 1])

% function dummy
% % draw the breaks 
% xbit = DWid*Range(firstxbit);
% ybit = DUp*Range(y);
% line([BreakStart-xbit BreakStart+xbit],[y(1)-ybit y(1)+ybit]);
% line([BreakEnd-xbit BreakEnd+xbit]- BreakEndVal,[y(1)-ybit y(1)+ybit]);
% hold off;
% YL=get(gca,'YLim');
% set(gca,'YLim',[y(1) YL(2)])