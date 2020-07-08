function[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(s,t,thresh_s,thresh_t,Plotting)
% 
% [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(s,t,thresh_s,thresh_t,Plotting)
% 
% This function gets the optima of s which is a function of t
% it has 2 threshold values and will ignore optima that are within thresh_s
% in s away and thresh_t in t away from the current one. 
% 
% this ignoring is cumulative so if you had a sine wave with minor noise it
% would just pick the peak and trough of the sine wave.
% 
% the 5th input is wjether to plot or not (default is to plot)
% 
% outputs are:
% ma_t/ma_s: t and s values of maxima
% mi_t/mi_s: t and s values of minima
% ma/mi: indices of maxima and minima
% 
% WARNING: tis is not perfect/bug free. 2 main things:
% 
% 1. you might want the first or last bit to be auto included. they're not
% at the moment but sometimes sneak in (probably mainly correctly)
% 
% 2. as indicated by the function it calls: 
% findextrema_FlatBitsDoesntwork
% it's not perfect if there are lots of flat bits ie exactly equal values. 
% This is rare in real data

if(nargin<5) Plotting=1; end;

% could do some smoothing here
% s=o;

% if doing this again, need to check the functions below...
[ma,mi]=findextrema_FlatBitsDoesntwork(s);
% [ma,mi]=findextrema(s);

% **** This messes up. Need to do something cleverer... 
% add in end points. Should really check for equality but ...
% if(s(1)<s(2)) mi=[1 mi];
% else ma=[1 ma];
% end
% if(s(end)<s(end-1)) mi=[mi length(s)];
% else ma=[ma length(s)];
% end

i=1;
while(i<=min(length(ma),length(mi)))
    ma_t=t(round(ma));
    mi_t=t(round(mi));
    ma_s=s(round(ma));
    mi_s=s(round(mi));
    %     plot(t,s);
    %     hold on; plot(ma_t,ma_s,'ro'); plot(mi_t,mi_s,'gs'); hold off;
    [close_is,close_as]=GetClosePoints(mi_s,mi_t,i,ma_s,ma_t,thresh_s,thresh_t);
    if(~isempty(close_is))
        if(length(close_as)==length(close_is))
            ma=setdiff(ma,ma(close_as));
            mi=setdiff(mi,mi(close_is));
        elseif(length(close_as)>length(close_is))
            mi=setdiff(mi,mi(close_is));
            [m,ind]=max(ma_s(close_as));
            close_as=close_as([1:ind-1, ind+1:end]);
            ma=setdiff(ma,ma(close_as));
        else
            ma=setdiff(ma,ma(close_as));
            [m,ind]=min(mi_s(close_is));
            close_is=close_is([1:ind-1, ind+1:end]);
            mi=setdiff(mi,mi(close_is));
        end
        %i=1;
    else i=i+1;
    end
end
ma_t=t(round(ma));
mi_t=t(round(mi));
ma_s=s(round(ma));
mi_s=s(round(mi));
if(Plotting) 
    plot(t,s,ma_t,ma_s,'ro',mi_t,mi_s,'gs'); 
end;
ma=round(ma);
mi=round(mi);

function[close_is,close_as]=GetClosePoints(s,t,i,si,ti,s_s,t_s)
close_is=[];
close_as=i;
%Check ones before it
if(i>length(s))
    j=i;
    % Check ones before
    while(((j-1)>=1)&(isclose(s(j-1),t(j-1),si(j),ti(j),s_s,t_s)))
        close_is=[close_is j-1];
        if(isclose(s(j-1),t(j-1),si(j-1),ti(j-1),s_s,t_s))
            close_as=[close_as j-1];
        else break;
        end
        j=j-1;
    end
elseif(t(i)<ti(i))
    j=i;
    % Check ones before
    while(isclose(s(j),t(j),si(j),ti(j),s_s,t_s))
        close_is=[close_is j];
        if(((j-1)>=1)&(isclose(s(j),t(j),si(j-1),ti(j-1),s_s,t_s)))
            close_as=[close_as j-1];
        else break;
        end
        j=j-1;
    end
    % Check ones after
    j=i+1;
    while((j<=length(s))&(isclose(s(j),t(j),si(j-1),ti(j-1),s_s,t_s)))
        close_is=[close_is j];
        if((j<=length(si))&(isclose(s(j),t(j),si(j),ti(j),s_s,t_s)))
            close_as=[close_as j];
        else break;
        end
        j=j+1;
    end
else
    j=i;
    % Check ones before
    while(((j-1)>=1)&(isclose(s(j-1),t(j-1),si(j),ti(j),s_s,t_s)))
        close_is=[close_is j-1];
        if(isclose(s(j-1),t(j-1),si(j-1),ti(j-1),s_s,t_s))
            close_as=[close_as j-1];
        else break;
        end
        j=j-1;
    end
    % Check ones after
    j=i;
    while((j<=length(s))&(isclose(s(j),t(j),si(j),ti(j),s_s,t_s)))
        close_is=[close_is j];
        if(((j+1)<=length(si))&(isclose(s(j),t(j),si(j+1),ti(j+1),s_s,t_s)))
            close_as=[close_as j+1];
        else break;
        end
        j=j+1;
    end
end

function[isc]=isclose(s,t,si,ti,s_s,t_s)
if(abs(s-si)<s_s) isc=1;
elseif(abs(t-ti)<t_s) isc=2;
else isc=0;
end

function [ma,mi,infu,infd]=findextrema_FlatBitsDoesntwork(a)

% FINDEXTREMA - finds minima and maxima of data
%
% If 'y' is the data the function finds the maximas 'ma' and minimas 'mi'.
% The x-position of the extrema are interpolated.
%
% Usage: [ma,mi]=findextrema(y);
%
% Example:
%    x=-10:0.1:10; y=sin(x);
%    [ma,mi]=findextrema(y);
%    plot(y); hold on; plot(ma,y(round(ma)),'ro'); plot(mi,y(round(mi)),'gs'); hold off;
%
ma=[]; mi=[]; infu=[]; infd=[];
a=gradient(a);
ad=diff(0.5*sign(a)); 
p=find(abs(ad)==1); %find position of signum change
if(~isempty(p)) 
    zp=p+a(p)./(a(p)-a(p+1));	%linear interpolate zero crossing
    mip=find(ad(p)==1);
    map=find(ad(p)==-1);
    mi=zp(mip); ma=zp(map);
end

% find any flat bits
z=find(a==0,1);
while(~isempty(z))
    af=find(a(z+1:end),1);
    if(z==1)
        if(isempty(af)) 
            infu=[infu 0.5*length(a)]; 
            break;
        elseif(a(af+z)>0) mi=[mi 1+0.5*(af-1)];
        else ma=[ma 1+0.5*(af-1)];
        end
    else
        bf=a(z-1);
        if(bf>0)
            if(isempty(af))
                ma=[ma 0.5*(z+length(a))];
                break;
            elseif(a(af)>0) infu=[infu z+0.5*(af-1)];
            else ma=[ma z+0.5*(af-1)];
            end
        else
            if(isempty(af))
                mi=[mi 0.5*(z+length(a))];
                break;
            elseif(a(af+z)>0) mi=[mi z+0.5*(af-1)];
            else infd=[infd z+0.5*(af-1)];
            end
        end
    end
    z=find(a(af+z:end)==0,1)+af+z-1;
end
ma=sort(ma);
mi=sort(mi);
infu=infu;
infd=infd;