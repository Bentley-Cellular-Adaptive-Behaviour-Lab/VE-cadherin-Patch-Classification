% function[RVal] = RndInt(MaxVal)
% generates a random number in [0, MaxVal-1]

function[RVal] = RndInt(MaxVal)

RVal=floor(rand*MaxVal);