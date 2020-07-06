function PickPointsInSubplots(X)


ipls=[1,2;1,3;2,3];

for i=1:3

    hdls(i)=subplot(1,3,i);
    pts(i).pts=X(:,ipls(i,:));
    plot(pts(i).pts(:,1),pts(i).pts(:,2),'.');
end

h=[0,0,0];
subplot(1,3,2)
xlabel('Click near a point to select. Return to end')
while 1
    [i_m,b,~,~,~,axP]=GetNearestClickedPt(pts,0,hdls);
    if(h(axP)~=0)
        delete(h(axP));
    end
    if(isempty(b))
        break;
    else
        pt=pts(axP).pts(i_m,:);
        hold on
        h(axP)=plot(pt(1),pt(2),'k*','MarkerSize',12);
        hold off
        s=[ 'point ' int2str(i_m)];
        ylabel(s)
        disp(s);
    end
end


