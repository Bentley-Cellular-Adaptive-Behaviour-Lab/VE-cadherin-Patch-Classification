function [tout,rout] = Rose_plot(nn,x)
% function [tout,rout] = Rose_plot(varargin)
% 
% this is adapted from rose. 
% it will do a rose plot but you specify the bin-centres (in degrees for
% ease at the moment) and the bin heights
% 
% you can do the same plot via rose
% to see how it works if you are getting the data from dat from AngHist
% would be:
% dat=rand(1,100)*360
% [y,x]=AngHist(dat,[],[],0);
% xe=-175:10:185;
% subplot(1,2,1);
% Rose_plot(y,xe); 
% % this doe sthe same thing but via rose
% subplot(1,2,2); rose(dat*pi/180,[0:10:350]*pi/180); 

% Form radius values for histogram triangle
nn = nn(:); 
[m,n] = size(nn);
mm = 4*m;
r = zeros(mm,n);
r(2:4:mm,:) = nn;
r(3:4:mm,:) = nn;

edges=x*pi/180;
t=r;
t(2:4:mm,:)=edges(1:end-1)';
t(3:4:mm,:)=edges(2:end)';
% edge2=edges(1:end-1);
% for i=1:length(edges)-1
%     ind=4*i-3;
%     t(ind)=0;
%     r(ind)=0;
%     t(ind+1)=edges(i);
%     t(ind+2)=edges(i+1);
%     r(ind+1)=nn(i);
%     r(ind+2)=nn(i);
%     t(ind+3)=0;
%     r(ind+3)=0;
% end

if nargout<2
%   if ~isempty(cax)
%     h = polar(cax,t,r);
%   else
    h = polarplot(t,r);
%   end
  
  % Register handles with m-code generator
%   if ~isempty(h)
%      mcoderegister('Handles',h,'Target',h(1),'Name','rose');
%   end
  
  if nargout==1, tout = h; end
  return
end

if min(size(nn))==1,
  tout = t'; rout = r';
else
  tout = t; rout = r;
end


