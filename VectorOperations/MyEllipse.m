% function MyEllipse(a,b,X,thet,NumPts,col)
% Function draws an ellipse with axis widths a , b at posiotn X 
% (default =0,0) with ecentricity (angle between x-axis) phi (default 0)
% NumPts is optional (default 100 as is colour default blue

function MyEllipse(a,b,X,phi,col,NumPts)
if (nargin <6) NumPts = 100; end
if (nargin <5) col='b'; end
if (nargin <4) phi = 0; end
if (nargin <3) X=[0,0]; end
theta = [-0.03:(2*pi/NumPts):2*pi];

% Parametric equation of the ellipse
%----------------------------------------
 x = a*cos(theta);
 y = b*sin(theta);
% Coordinate transform 
%----------------------------------------
 Xs = cos(phi)*x - sin(phi)*y;
 Ys = sin(phi)*x + cos(phi)*y;
 Xs = Xs + X(1);
 Ys = Ys + X(2);
plot(Xs,Ys,col)