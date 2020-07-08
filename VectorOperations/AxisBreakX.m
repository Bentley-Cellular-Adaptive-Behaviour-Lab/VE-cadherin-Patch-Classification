% function AxisBreakX(x,y,BreakStart,BreakEnd,yaxis,BreakWid,DUp,DWid)
%
% function to put in an axis break between BreakStart and BreakEnd
% x and y in x and y, yaxis if break is up yaxis (default off)
% BreakWid and DUp, DWid to control width of gap and dimensions 
% of dashes in fraction of the axis lims (before break for broken axis
% set to default of 0.075, 0.05 and 0.01

function[h1,h2]= AxisBreakX(x,y,BreakStart,BreakEnd,BreakWid)

if (nargin<5) BreakWid = 0.05; end;

PLen=0.8;
covrange=BreakStart-BreakEnd+Range(x);
Ht1=PLen*(BreakStart-min(x))/covrange;
h1=subplot('position',[0.13 0.11 Ht1 0.775]);
plot(x,y);
Setbox(h1);
SetYLim(gca,min(y),max(y));
SetXLim(gca,min(x),BreakStart);
Ht2=PLen*(max(x)-BreakEnd)/covrange;
h2=subplot('position',[0.13+Ht1+BreakWid 0.110 Ht2 .775]);
plot(x,y);
SetYLim(gca,min(y),max(y));
SetXLim(gca,BreakEnd,max(x));
Setbox;
set(h2,'YTick',[],'YTickLabel',[],'YColor',[1 1 1])