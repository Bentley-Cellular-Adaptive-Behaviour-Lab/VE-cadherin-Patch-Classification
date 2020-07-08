% function OrderPointsAng(pts,direction,startVal,m)
%
% this function orders a set of 2d points so that they are ordered 
% pts should be a matrix with each row as a point
% as it uses cart2pol needs to be upgraded for other D points with more
% direction
%
% direction about their mean starting from startVal
% if driection is >0 then go CCW (this is the default)
% if driection is <=0 then go CW 
% the default is CCW and starting at 0 as in typical axes
%
% it's useful when you a user clicks on points around an object as they can
% click in any order but then this always does the ordering
% should probably be a method in ca class of 'click on object'
% 
% NB haven't done the startVal but yet!!!

function[spts] = OrderPointsAng(pts,direction,startVal,m)
% check if there's enough points to make sense
NumPts=size(pts,1);
if(NumPts<2)
    spts=pts;
    return;
end
% set defaults
if(nargin<2)
    direction=1;
end
if(nargin<3)
    startVal=0;
end

% get centroid of points
if(nargin<4)
    m=mean(pts,1);
end
% take the centroid off all the points
relpts=pts-ones(NumPts,1)*m;

% get angles relative to centroid and make them between 0 and 2pi
th=cart2pol(relpts(:,1),relpts(:,2));

% take off startVal and make them between 0 and 2pi
startVal=mod(startVal,2*pi);
th=mod(th-startVal,2*pi);

% sort them as increasing or decreasing based on direction
if(direction>0)   
    [~,is]=sort(th,'ascend');
else
    [~,is]=sort(th,'descend');
end 
spts=pts(is,:);
