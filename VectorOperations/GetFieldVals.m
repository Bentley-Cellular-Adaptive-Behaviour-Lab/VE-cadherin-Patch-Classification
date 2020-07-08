% function[f] = GetFieldVals(s,name)
% returns the values in the field 'name' in structure s

function[f] = GetFieldVals(s,name)
for i=1:length(s) 
    t=s(i);
    f(i,:)=cat(1,getfield(t,name)); 
end;