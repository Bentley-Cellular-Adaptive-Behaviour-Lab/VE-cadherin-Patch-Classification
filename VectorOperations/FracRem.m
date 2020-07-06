% function[whole,decim] = FracRem(x)
% returns the integer part of x in whole and the remainder in decim
% such that whole+decim=x

function[whole,decim] = FracRem(x)

whole=fix(x+1e-4);
decim=x-whole;
if(decim<1e-8)
   decim=0;
end
