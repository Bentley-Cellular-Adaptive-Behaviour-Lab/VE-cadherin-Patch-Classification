% from http://mathworld.wolfram.com/Line-LineIntersection.html
function[x,y]=IntersectionPoint(x1,x2,x3,x4,y1,y2,y3,y4,pl)
if(nargin<9) pl=0; end;

d1=det([x1 y1;x2 y2]);
d2=det([x3 y3;x4 y4]);
d3=det([x1-x2 y1-y2;x3-x4 y3-y4]);

x=det([d1 x1-x2;d2 x3-x4])/d3;
y=det([d1 y1-y2;d2 y3-y4])/d3;

if(pl)
    cr=0;
    if((x>=min(x1,x2))&&(x<=max(x1,x2)))
        if((y>=min(y1,y2))&&(y<=max(y1,y2)))
            if((x>=min(x3,x4))&&(x<=max(x3,x4)))
                if((y>=min(y3,y4))&&(y<=max(y3,y4))) cr=1; end
            end
        end
    end
    plot([x1 x2],[y1 y2],'b',[x3 x4],[y3 y4],'r')
    hold on;
    if(cr)
        plot([x1 x],[y1 y],'k--s');
        plot([x3 x],[y3 y],'r--s')
    else
        plot([x1 x],[y1 y],'k:o');
        plot([x3 x],[y3 y],'r:o')
    end
    hold off
end