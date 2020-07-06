% function[NewNum]=IRnd(MaxNum,x,y)
% function to get a random integer in the rangem [0 and MaxNum-1]
% if x is specified only, it returns and x by x mtarix of random ints
% if x and y specified, it returns an [x y] matrix of rand ints

function[NewNum]=IRnd(MaxNum,x,y)

if(nargin<2) NewNum=floor(rand*MaxNum);
elseif(nargin<3) NewNum=floor(rand(x)*MaxNum);
else NewNum=floor(rand(x,y)*MaxNum);
end
