function[pts,hdls]=GetAndPlotPoints(nPts,col)
for i=1:nPts
    x=[];
    while(isempty(x))
        [x,y]=ginput(1);
    end
    h=plot(x,y,col);
    if(i==1)
        pts=[x,y];
        hdls=h;
    else
        pts=[pts;x,y];
        hdls=[hdls;h];
    end
end