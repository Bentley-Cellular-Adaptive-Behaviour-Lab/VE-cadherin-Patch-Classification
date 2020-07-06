function[h]=PlotPatches(p,t,col,t2)
if(isempty(p))
    h=[];
    return;
end

if(ishold)
    ho=1;
else
    ho=0;
end

if(nargin<3); col='w'; end;
if((nargin<2)||isempty(t)); t=0; end;
if((nargin<4)||isempty(t2)); t2=0; end;

for i=1:length(p)
    by(i,:)=[p(i).rs(1) p(i).rs(1) p(i).rs(end) p(i).rs(end) p(i).rs(1)];
    bx(i,:)=[p(i).cs(1) p(i).cs(end) p(i).cs(end) p(i).cs(1) p(i).cs(1)];
end
h=plot(bx',by',col);
if(~isequal(t,0))
    hs=[];
    hold on
    for i=1:length(p)
        if(length(t)==length(p))
            g=text(p(i).cs(1)+5,p(i).rs(end)-15,int2str(t(i)),'color',col(1));
        else
            g=text(p(i).cs(1)+5,p(i).rs(end)-15,int2str(i),'color',col(1));
        end
        hs=[hs;g];
    end
    h=[h;hs];
end
if(~isequal(t2,0))
    hs=[];
    hold on
    for i=1:length(p)
        if(~isempty(t2(i).s))
            g=text(p(i).cs(end)-15,p(i).rs(end)-15,t2(i).s,'color',col(1));
            hs=[hs;g];
        end
    end
    h=[h;hs];
end
if(~ho)
    hold off;
end
