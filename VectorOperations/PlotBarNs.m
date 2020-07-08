function[hdls]=PlotBarNs(n,xp,gap,nrow,fsize,axhdl)
if((nargin<6)||isempty(axhdl))
    axhdl=gca;
end
if((nargin<3)||isempty(gap))
    gap=0.05;
end
if((nargin<5)||isempty(fsize))
    fsize=10;
end

if((nargin<4)||isempty(nrow))
%     set(axhdl,'Units','characters')
%     P=get(axhdl,'Position');
%     twidth=0.75;
%     max
    nrow=ceil(length(n)/10);
end

axes(axhdl);
yl=ylim;
yr=diff(yl);
hdls=[];
for i=1:nrow
    is=i:nrow:length(n);
    yh=yl(2)-i*gap*yr;
%     for j=is
%     h=text(xp(j),yh,int2str(n(j)),'FontSize',fsize,...
%         'HorizontalAlignment','center');
%     hdls=[hdls; h];
%     end
    h=text(xp(is),yh*ones(size(is)),int2str(n(is)'),'FontSize',fsize,...
        'HorizontalAlignment','center');
    hdls=[hdls; h];
end