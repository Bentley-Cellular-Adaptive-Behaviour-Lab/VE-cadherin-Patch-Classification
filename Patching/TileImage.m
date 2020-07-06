function[patches]=TileImage(tim,ht,wid,pl)
patches=[];
if(isequal(tim,-1))
    return
end
if(nargin<4); pl=1; end;

rs=sum(tim,2);
r1=find(rs,1,'first');
r2=find(rs(r1:end),1,'last')+r1-1;
[sl_row1,sl_row2]=getsli(r1,r2,ht);
% sl_midrow=round(0.5*(sl_row1+sl_row2))
for i=1:length(sl_row1)
    ris=sl_row1(i):sl_row2(i);
    slim=tim(ris,:);
    patches=[patches GetSlbox(wid,slim,ris)];
end
% get rid of empty ones
patches=patches([patches.area]>0);
% plot them if plotting needed
if(pl)
    subplot(2,2,1)
    imagesc(tim)
    subplot(2,2,2)
    imagesc(tim), hold on
    PlotPatches(patches,1); hold off
end


function[sl_row1,sl_row2]=getsli(r1,r2,wid)
len=(r2-r1)+1;
nsl=max(1,round(len/wid));
for i=1:nsl
    sl_row1(i)=r1+(i-1)*wid;
end
sl_row2=sl_row1-1+wid;
sl_row2(end)=r2;


function[o,ninrow]=GetSlbox(w,slim,ris)
% get start and end columns of each object
rs=sum(slim,1);
d=diff(sign(rs));
cst=find(d==1)+1;
if(isempty(cst))
    cst=1;
end
cen=find(d==-1);
if(isempty(cen))
    cen=length(rs);
end
if(cen(1)<cst(1))
    cst=[1 cst];
end
if(cst(end)>cen(end))
    cen=[cen length(rs)];
end
% for each objects, make big objects if the gap is less than 50
c=1;
while(length(cen)>c)
    if((cst(c+1)-cen(c))<(w/2))
        cst=cst([1:c (c+2):end]);
        cen=cen([1:(c-1) (c+1):end]);
    else
        c=c+1;
    end
end
o=[];
%divide the objects into 100's
for j=1:length(cst)
    [c1,c2]=getsli(cst(j),cen(j),w);
    for i=1:length(c1)
        out(i).rs=ris;
        out(i).cs=c1(i):c2(i);
        v=slim(:,out(i).cs);
        v=v(:);
        out(i).size=length(v);
        out(i).area=sum(v>0);
        out(i).pc=out(i).area/out(i).size;
    end
    o=[o out];
    clear out;
end
ninrow=length(o);
