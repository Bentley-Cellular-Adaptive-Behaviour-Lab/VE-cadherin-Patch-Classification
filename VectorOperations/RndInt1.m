% function[RVal] = RndInt1(MaxVal)
% generates a random number in the range [1, MaxVal]

function[RVal] = RndInt1(MaxVal)

RVal=ceil(rand*MaxVal);