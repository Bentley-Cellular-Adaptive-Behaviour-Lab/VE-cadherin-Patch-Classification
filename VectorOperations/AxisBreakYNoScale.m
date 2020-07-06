% function AxisBreakY(x,y,BreakStart,BreakEnd,yaxis,BreakWid,DUp,DWid)
%
% function[h1,h2]= AxisBreakY(x,y,BreakStart,BreakEnd,TopProp,BreakWid)
% function returns 2 axes handles so that a figure can be plot with an axis break 
% between BreakStart and BreakEnd of width BreakWid (in normalised figure amount,
% default 0.075). TopProp gives the size of the upper plot in normalised units (default 0.75)
% x and y values are in x and y
%
% See also: AxisBreakXNoScale, AxisBreakY

function[h1,h2]= AxisBreakYNoScale(x,y,BreakStart,BreakEnd,TopProp,BreakWid)

if (nargin<5) TopProp = 0.25; end;
if (nargin<6) BreakWid = 0.075; end;

covrange=BreakStart-BreakEnd+Range(y);
Ht1=(0.8-BreakWid)*(1-TopProp);
h1=subplot('position',[0.175 0.125 0.775 Ht1]);
plot(x,y);
Setbox(h1);
YLim([min(y),BreakStart]);
XLim([min(x),max(x)]);
Ht2=(0.8-BreakWid)*(TopProp);
h2=subplot('position',[0.175 0.125+Ht1+BreakWid 0.775 Ht2]);
plot(x,y);
YLim([BreakEnd,max(y)]);
XLim([min(x),max(x)]);
Setbox;
set(h2,'XTick',[],'XTickLabel',[],'XColor',[1 1 1])