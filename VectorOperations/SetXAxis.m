%function SetXAxis(AxHdl,x1,x2,X,Y,Pc)
% function which sets xaxis to x1 x2 and yaxis to the equivalent values of y 
% plus Pc % (as a decimal) for the top value

function SetXAxis(AxHdl,x1,x2,X,Y,Pc)

if(nargin<6) Pc=0.1; end;
y1=Y(find(X==x1));
y2=(1+Pc)*Y(find(X==x2));
set(AxHdl,'XLim',[x1 x2]);
set(AxHdl,'YLim',[y1 y2]);

