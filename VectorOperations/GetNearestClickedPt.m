% function[i_m,b,p,q,mini_d,axpick,pickHdl] = GetNearestClickedPt(pts,tst,hdls)
% 
% function returns the index i_m of the point in pts which is the nearest
% clicked one. i_m=0 if you press return
% 
% b is the returned button from ginput, (p,q) is coordinate
% of the point clicked, mini_d is the distance to the pt, axpick is the
% number of the clicked axis (for subplot) and pickHdl is the handle
% I don't think i ever use axpick but presumably it seemed useful...
% 
% the latter two are only returned if hdls, a vector of axis handles
% is input as an input
% 
% tst is title. Default is 'Click near a point to select. Return to end'.
% if tst=0 the title is unchanged
%
% USAGE:
% GetNestAndLMDataSide.m	415	
%     [adj,b,c,d]=GetNearestClickedPt(LM,tst);
%     LM(adj,:)=[c,d];
% ClickAndAdjustPts:
%     [adj,b,c,d]=GetNearestClickedPt(pts,tst);
%     pts(adj,:)=[c,d];
%
% PickPointsInSubplots.m	17	
%      [i_m,b,~,~,~,axP]=GetNearestClickedPt(pts,0,hdls);

function[i_m,b,p,q,mini_d,axpick,pickHdl] = GetNearestClickedPt(pts,tst,hdls)
if((nargin<2)||(isempty(tst))) 
    title('Click near a point to select. Return to end')
elseif(~isequal(tst,0))
    title(tst);
end
[p,q,b]=ginput(1);
pickHdl=gca;
if(nargin>2)
    axpick=find(pickHdl==hdls);
    pts=pts(axpick).pts;
else
    axpick=NaN;
end
if(isempty(b))
    i_m=0;
    mini_d=NaN;
    return;
else
    vs=pts-ones(size(pts,1),1)*[p,q];
    ds=sum(vs.^2,2);
    [mini_d,i_m]=min(ds);
end

