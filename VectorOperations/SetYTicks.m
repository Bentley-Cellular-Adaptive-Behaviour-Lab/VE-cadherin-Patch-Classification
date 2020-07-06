% function SetYTicks(AxHdl,NTick,TFactor,NumDec,TickPos,TickLabs)
% 
% sets the Yticks: (default) sets the number of tick labels, equally spced
% and multiplied by TFactor, default 1. 
%
% If NTick is empty,
% keeps the automatically generated ticks and multiplies by
% TFactor (useful for graphs of low or high numbers
%
% If NTick = 0  turnd the ticks off
%
% if defined TickPos sets ticks to positions defined by TickPos with (default)
% Ticklabels to where they are (multiplied by TFactor) and to TickLabs  otherwise
%
% If NumDec is defined it sets the decima;l places for the ticklabels  

function SetYTicks(AxHdl,NTick,TFactor,NumDec,TickPos,TickLabs)

if((nargin<3)||isempty(TFactor)) TFactor=1; end

if(isequal(NTick,0)) set(AxHdl,'YTick',[]);
elseif(nargin<4)
    if(isempty(NTick)) ticks=get(AxHdl,'YTick');
    else
        x=get(AxHdl,'YTick');
        tickdist=(x(end)-x(1))/(NTick-1);
        ticks=[x(1):tickdist:x(end)];
    end
    tickstr=num2str(ticks'.*TFactor);
    set(AxHdl,'YTick',ticks,'YTickLabel',tickstr);
elseif(nargin<5) 
    x=get(AxHdl,'YTick');
    tickdist=(x(end)-x(1))/(NTick-1);
    ticks=[x(1):tickdist:x(end)];
    tickstr=num2str(ticks'.*TFactor,NumDec);
    set(AxHdl,'YTick',ticks,'YTickLabel',tickstr);
elseif(nargin<6)
    if(isempty(NumDec)||NumDec<0)
        tickstr=num2str(TickPos'.*TFactor);
    else
        tickstr=num2str(TickPos'.*TFactor,NumDec);
    end      
    set(AxHdl,'YTick',TickPos,'YTickLabel',tickstr);  
else
    if(isempty(TickPos)) TickPos=get(AxHdl,'YTick');end;
    set(AxHdl,'YTick',TickPos,'YTickLabel',TickLabs);
end
