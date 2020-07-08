% function SetTickLength(AxHdl,TickLen)
% sets the length of ticks to TickLen*default length

function SetTickLength(AxHdl,TickLen)

TLen=get(AxHdl,'TickLength');
TLen(1)=TLen(1)*TickLen;
set(AxHdl,'TickLength',TLen)
