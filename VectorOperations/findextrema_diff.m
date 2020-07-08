function [ma,mi,mav,miv,infu,infd]=findextrema(v)

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
a=diff(v);%gradient(a);
ad=diff(0.5*sign(a)); 
p=find(abs(ad)==1); %find position of signum change
if(~isempty(p)) 
    zp=p+a(p)./(a(p)-a(p+1));	%linear interpolate zero crossing
    mip=find(ad(p)==1);
    map=find(ad(p)==-1);
%     mi=zp(mip); ma=zp(map);
    mi=p(mip)+1; ma=p(map)+1;
end

% find any flat bits
z=find(a==0,1);
while(~isempty(z))
    af=find(a(z+1:end),1);
    if(z==1)
        if(isempty(af)) 
            infu=[infu 0.5*length(a)]; 
            break;
        elseif(a(af+z)>0) mi=[mi 1+0.5*af];
        else 
            ma=[ma 1+0.5*af];
        end
    else
        bf=a(z-1);
        if(bf>0)
            if(isempty(af))
                ma=[ma 0.5*(z+length(a))];
                break;
            elseif(a(af+z)>0) infu=[infu z+0.5*af];
            else ma=[ma z+0.5*af];
            end
        else
            if(isempty(af))
                mi=[mi 0.5*(z+length(a))];
                break;
            elseif(a(af+z)>0) mi=[mi z+0.5*af];
            else infd=[infd z+0.5*af];
            end
        end
    end
    z=find(a(af+z:end)==0,1)+af+z-1;
end
ma=sort(ma);
mi=sort(mi);
miv=v(round(mi)); mav=v(round(ma));
infu=infu;
infd=infd;