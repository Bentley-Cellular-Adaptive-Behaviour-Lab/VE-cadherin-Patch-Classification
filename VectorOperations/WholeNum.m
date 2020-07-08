% function[Whole, ScaleFac]=WholeNum(x)
% takes a number x (not an int) and returns it as a whole number Whole together with 
% the scaling factor ScaleFac which is the power of 10 by which it is multiplied

function[Whole, ScaleFac]=WholeNum(x)

ScaleFac=0;
[a,b]=FracRem(x);
while(b>1e-9)
   x=x.*10;
   ScaleFac=ScaleFac+1;
   [a,b]=FracRem(x);
end
Whole=x;