% function OrderPointsXY(pts,XY,direction)
%
% this function orders a set of points so that they are ordered accrdoing
% to either their x or their y value (or z!) as specified by XY 
% (XY=1: x; XY=2: y; XY=3: z etc...)
%
% pts should be a matrix with each row as a point
%
% direction specifies whether order is increasing or decreasing.
% if driection is >0 then left to right, or low to high
% if driection is <=0 then the other 
% the default is >0
%
% it's useful when you a user clicks on points around an object as they can
% click in any order but then this always does the ordering
% should probably be a method in ca class of 'click on object'
% 
% NB haven't done the startVal but yet!!!

function[spts] = OrderPointsXY(pts,XY,direction)
% check if there's enough points to make sense
NumPts=size(pts,1);
if(NumPts<2)
    spts=pts;
    return;
end
% set defaults
if(nargin<3)
    direction=1;
end

% sort them as increasing or decreasing based on direction
if(direction>0)   
    [~,is]=sort(pts(:,XY),'ascend');
else
    [~,is]=sort(pts(:,XY),'descend');
end 
spts=pts(is,:);