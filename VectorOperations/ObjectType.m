% function[obtype]=ObjectType(Object)
% Currently outputs 1 if it's a circle, 0 not, 2 if a stripe
% Could be extended

function[obtype]=ObjectType(Object)
if(isfield(Object,'type'))
    if(~isempty(Object.type))   
        obtype=Object.type;
        return;
    end
end
if(~isfield(Object,'wid')||isempty(Object.wid))
    obtype=0;
elseif(sum(Object.wid)>0)
    obtype=1;
else
    obtype=2;
end