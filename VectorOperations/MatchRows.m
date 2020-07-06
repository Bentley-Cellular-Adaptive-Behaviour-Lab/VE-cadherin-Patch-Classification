% function[i,v] = MatchRows(AllV,Vs)
% Function which returns the indices of rows in AllVs which match elements
% of Vs
%
% Could be vectorised for speed if needed

function[is,v] = MatchRows(AllVs,Vs)
is=[];
v=[];
for i=1:size(Vs,1)
    for j=1:size(AllVs,1)
        if(isequal(Vs(i,:),AllVs(j,:)))
            is = [is j];
            break;
        end
    end
end
if(~isempty(is)) v=AllVs(is,:); end;