function DrawAxes(gca,x,y,Col)

if(nargin<4) Col='k-'; end
if(nargin<3) y=0; end
if(nargin<2) x=0; end

X=get(gca,'XLim');
Y=get(gca,'YLim');

hold on;
plot(X,[y y],Col,[x x],Y,Col);
hold off