% function[dat,xp]=StatsOverX(x,y,xdiv,AngVar,getIs,ignoreNaNs)
%
% this function generates various stats based on y after binning the data
% based on x 
%
% xdiv allows you to specify the edges of the bins (if a vector), or a
% number of bins (if a number) and defaults to 20
%
% it returns a structure dat which has various fields and xp which is the
% centre of the bins used (good for plotting
%
% usage: to plot mean and sd:
% [dat,xp]=StatsOverX(x,y);
% errorbar(xp,[dat.me],[dat.sd])
%
% to plot median and 25th and 75th
% errorbar(xp,[dat.med],[dat.med]-[dat.p25],[dat.p75]-[dat.med])
% 
% to plot circular mean and sd IT USED TO BE:
%  errorbar(xp,[dat.meang],[dat.angsd])
% but I realised this was stupid as you shouldn't do non-angular stats for
% angular data so now if AngVar is selected it does the angular variants
% However,as everything needs to be in radians you'll probably want to do
% 
% errorbar(xp,[dat.me]*180/pi,[dat.sd]*180/pi)
% errorbar(xp,[dat.med]*180/pi,([dat.med]-[dat.p25])*180/pi,([dat.p75]-[dat.med])*180/pi)
% 
% the other input variables re optional. AngVar (default=1) specifies that
% this is an angular varaible and so computes circular mean/median. the
% Option to have it as 0 just saves a sall amount of computation
% 
% getIs (default 0) returns the indices of the data that are in each bin which is
% useful to then do other stuff to the data (and as this function can be
% used to handily parcel up the data
% 
% ignoreNaNs (default 1) is likely defunct. If it's 1 it means treat the
% NaNs as missing values. Not clear why one wouldn't want to do this...
function[dat,xp,binedges]=StatsOverX(x,y,xdiv,AngVar,getIs,ignoreNaNs)

if((nargin<3)||isempty(xdiv)) 
    xdiv=20; 
end;
if((nargin<4)||isempty(AngVar))
    AngVar=1;
end 
if((nargin<5)||isempty(getIs))
    getIs=0;
end 
if((nargin<6)||isempty(ignoreNaNs))
    ignoreNaNs=1;
end     

if(length(xdiv)==1)
    minx=min(x);
    maxx=max(x);
    wid=(maxx-minx)/xdiv;
    xdiv=minx:wid:maxx;
end

binedges=xdiv;
for i=1:(length(xdiv)-1)
    is=(x>=xdiv(i))&(x<xdiv(i+1));
    xp(i)=0.5*(xdiv(i)+xdiv(i+1));
    d=y(is);
    if(ignoreNaNs==1)
        notNan=~isnan(d);
        d=d(notNan);
%         if(sum(notNan)==0)
%         else
%             d()=d;
    end
    if(AngVar)
        [mea,vl]=MeanAngle(d);
%         dat(i).meang=mea;
        dat(i).me=mea;
        if(size(d,2)>size(d,1))
%             dat(i).medang=circ_median(d');
            dat(i).med=circ_median(d');
        else
%             dat(i).medang=circ_median(d);
            dat(i).med=circ_median(d);
        end
%         dat(i).angsd=sqrt(2*(1-vl));
        dat(i).sd=sqrt(2*(1-vl));
        dat(i).p25=dat(i).med-dat(i).sd;
        dat(i).p75=dat(i).med+dat(i).sd;
        
        % this is a bit legacy. Not sure I should use this
        dat(i).meangL=vl;
    else
        dat(i).med=median(d);
        dat(i).me=mean(d);
        dat(i).sd=std(d);
        dat(i).p25=prctile(d,25);
        dat(i).p75=prctile(d,75);
    end
    dat(i).n=length(d);
    dat(i).x=d;
    dat(i).xdiv=xdiv;
    if(getIs==1)
        dat(i).is=is;
    end
end
if(AngVar)
    disp('warning: not really circular interquartile ranges')
end
            