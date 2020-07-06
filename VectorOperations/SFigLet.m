% function(h)=SFigLet(Lett,Fsize)
% funciton to put letter on figure
function[h]=SFigLet(Lett,Fsize)

if (nargin<2) FSize=14; end;
Y=get(gca,'YLim');
y=Y(2);
X=get(gca,'XLim');
x=min(X)-0.18*Range(X);
text(x,y,Lett,'FontSize',FSize);
