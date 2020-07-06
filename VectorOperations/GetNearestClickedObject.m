% function[obj,b,p,q,mind,i_m,axpick,pickHdl] = ...
%     GetNearestClickedObject(Objects,tst,xstr,ystr)%,hdls)
% 
% selects the nearest object from Objects clicked. Returns object index,
% button pressed. Last 2 paramters are defunct for now. Could be extended 
% as in GetNearestClickedPts 
% 
% tst specifies the title. Default is:
% 'Click near object to select. Return to end'
% if tst=0 then leave the label as it was
%
% ystr specifies the ylabel. Default is:
% 'circular objects defined by circle centres'
% if ystr=0 then leave the label as it was
% 
% xstr specifies the xlabel. Default is no label
% if xstr=0 then leave the label as it was
% 
% it returns the index of the selected object in obj, 0 if return entered
% b, p and q are the values returned from ginput, 
% mind os the minimum distacne to the object (NaN if return entered)
% i_m is the indx of the object within the object group (ie f there are 3
% LMs then it will be 1 - 3
% 
% axpick is not used (supposed to indicate the axis picked). Likewise
% PickHdl = gca as is not really used

function[obj,b,p,q,mind,i_m,axpick,pickHdl] = ...
    GetNearestClickedObject(Objects,tst,xstr,ystr)%,hdls)

% check if there is a nest
nestNum=find(ismember({Objects.str},'nest'),1);

if((nargin<2)||(isempty(tst))) 
    if(isempty(nestNum))
        title('Click near object to select. Return end')
    else
        title('Click near object to select, n for nest. Return end')
    end
elseif(~isequal(tst,0))
    if(isempty(nestNum))
        title(tst);
    else
        title([tst ', n for nest'])
    end
end
if((nargin<3)||(isempty(xstr))) 
    xlabel('')
elseif(~isequal(xstr,0))
    xlabel(xstr)
end
if((nargin<4)||(isempty(ystr))) 
    ylabel('circular objects defined by circle centres')
elseif(~isequal(ystr,0))
    ylabel(ystr)
end

[p,q,b]=ginput(1);
pickHdl=gca;
axpick=NaN;
% if(nargin>2)
%     axpick=find(pickHdl==hdls);
%     pts=pts(axpick).pts;
% end

if(isempty(b))
    obj=0;
    i_m=0;
    mind=NaN;
    return;
elseif(~isempty(nestNum)&&isequal(b,'n'))
    obj=nestNum;
    i_m=1;
    mind=0;
else
    for i=1:length(Objects)
        vs=AddToEachRow(Objects(i).pts,-[p,q]);
        ds=sum(vs.^2,2);
        [mini_ds(i),i_ms(i)]=min(ds);
    end
    [mind,obj]=min(mini_ds);
    i_m=i_ms(obj);
end

