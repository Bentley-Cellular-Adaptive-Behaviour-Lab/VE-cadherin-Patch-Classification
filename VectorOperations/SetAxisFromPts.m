function[ax]=SetAxisFromPts(pts,zoo)
if(nargin<2)
    zoo=0;
end
% zoom in on points
a1=min(pts,[],1)-zoo;
a2=max(pts,[],1)+zoo;
ax=[a1(1) a2(1) a1(2) a2(2)];
