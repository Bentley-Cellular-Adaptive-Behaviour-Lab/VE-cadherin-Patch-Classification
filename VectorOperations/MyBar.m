function [xo,yo] = MyBar(BarFactor,LineStyles,varargin)
%BAR Bar graph.
%    BAR(X,Y) draws the columns of the M-by-N matrix Y as M groups of N
%    vertical bars.  The vector X must be monotonically increasing or
%    decreasing.
%
%    BAR(Y) uses the default value of X=1:M.  For vector inputs, BAR(X,Y)
%    or BAR(Y) draws LENGTH(Y) bars.  The colors are set by the colormap.
%
%    BAR(X,Y,WIDTH) or BAR(Y,WIDTH) specifies the width of the bars. Values
%    of WIDTH > 1, produce overlapped bars.  The default value is WIDTH=0.8
%
%    BAR(...,'grouped') produces the default vertical grouped bar chart.
%    BAR(...,'stacked') produces a vertical stacked bar chart.
%    BAR(...,LINESPEC) uses the line color specified (one of 'rgbymckw').
%
%    H = BAR(...) returns a vector of patch handles.
%
%    Use SHADING FACETED to put edges on the bars.  Use SHADING FLAT to
%    turn them off.
%
%    Examples: subplot(3,1,1), bar(rand(10,5),'stacked'), colormap(cool)
%              subplot(3,1,2), bar(0:.25:1,rand(5),1)
%              subplot(3,1,3), bar(rand(2,3),.75,'grouped')
%
%    See also HIST, PLOT, BARH.

%    C.B Moler 2-06-86
%    Modified 24-Dec-88, 2-Jan-92 LS.
%    Modified 8-5-91, 9-22-94 by cmt; 8-9-95 WSun.
%    Copyright (c) 1984-98 by The MathWorks, Inc.
%    $Revision: 5.29 $  $Date: 1998/05/19 19:37:04 $

error(nargchk(1,6,nargin));
if(nargin<6) SetColors=0; end;
if(nargin<5) BarFactor=0; end;

[msg,x,y,xx,yy,linetype,plottype,barwidth,equal] = MyMakebars(varargin{:});
if ~isempty(msg), error(msg); end

% My added bit to control the widths of the bars: needs to be improved 
NumGroups=size(xx,2)
if(NumGroups>1)
	xx(1:5:end-1,1) = xx(1:5:end-1,1)*(1-BarFactor);
	xx(2:5:end-1,1) = xx(2:5:end-1,1)*(1-BarFactor);
	xx(3:5:end-1,1) = xx(3:5:end-1,1)*(1-BarFactor);
   xx(4:5:end-1,2) = xx(4:5:end-1,2)*(1+BarFactor);
   xx(5:5:end-1,2) = xx(5:5:end-1,2)*(1+BarFactor);
	xx(end,:) = xx(end-1,:);
end

if nargout==2,
  warning(sprintf(...
     ['BAR with two output arguments is obsolete.  Use H = BAR(...) \n',...
      '         and get the XData and YData properties instead.']))
  xo = xx; yo = yy; % Do not plot; return result in xo and yo
else % Draw the bars
  cax = newplot;
  next = lower(get(cax,'NextPlot'));
  hold_state = ishold;
  edgec = get(gcf,'defaultaxesxcolor');
  facec = 'flat';
  h = []; 
  cc = ones(size(xx,1),1);
  if ~isempty(linetype), facec = linetype; end
  for i=1:size(xx,2)
    numBars = (size(xx,1)-1)/5;
    f = 1:(numBars*5);
    f(1:5:(numBars*5)) = [];
    f = reshape(f, 4, numBars);
    f = f';

    v = [xx(:,i) yy(:,i)];
	if(isempty(LineStyles))
    	h=[h patch('faces', f, 'vertices', v, 'cdata', i*cc, ...
             'FaceColor',facec,'EdgeColor',edgec)];
    else
     	h=[h patch('faces', f, 'vertices', v, 'cdata', i*cc, ...
             'FaceColor',LineStyles(i),'EdgeColor',edgec)];
    end
  end
  if length(h)==1, set(cax,'clim',[1 2]), end
  if ~equal, 
    hold on,
    plot(x(:,1),zeros(size(x,1),1),'*')
  end
  if ~hold_state, 
    % Set ticks if less than 16 integers
    if all(all(floor(x)==x)) & (size(x,1)<16),  
      set(cax,'xtick',x(:,1))
    end
    hold off, view(2), set(cax,'NextPlot',next);
    set(cax,'Layer','Bottom','box','on')
    % Turn off edges when they start to overwhelm the colors
    if size(xx,2)*numBars > 150, 
       set(h,{'edgecolor'},get(h,{'facecolor'}));
    end
  end
  if nargout==1, xo = h; end
end
