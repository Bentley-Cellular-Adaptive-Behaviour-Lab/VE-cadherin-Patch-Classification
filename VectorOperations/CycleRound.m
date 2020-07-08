% function[n]=CycleRound(m,ma,mi)
%
% function which takes a number and makes it loop round ma. 
% Eseentially, it's mod(m,ma) but with 0=ma.
% however there's an optional argument mi which is the min so it
% cycles round mi to ma. 
% mi and ma can also be specified as 2 element vector ma=[mi ma]
%
% Use this to cycle round frames when looking at videos eg in 
% CheckThresholdBee.m
%
% USAGE
% % Cycle round 1 to 5, 3 to 5 and 2 to 5
% x=1:20;
% plot(x,CycleRound(x,5),x,CycleRound(x,5,3),'r',x,CycleRound(x,[2 5]),'g')
%
% % add 15 to frame = 65 and make it cycle within the beginning
% % and end of nums which holds all the frames
% 
% nums=11:70;
% frameadd=15;
% ind=65;
% ind=CycleRound(ind+frameadd,nums([1 end]));
% f=MyAviRead(vidfn,nums(ind));

function[n]=CycleRound(m,ma,mi)
if(isempty(m))
    n=[];
    return;
end

if(nargin<3)
    if(length(ma)<2)
        mi=0;
    else
        mi=ma(1);
        ma=ma(2);
    end
end

mN=ma-mi+1;
m=m-mi+1;
n=mod(m,mN);
n(n==0)=mN;
n=n+mi-1;