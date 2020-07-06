% function[freqs,vals]=FrequenciesOLDSlow(x,vals)
% function takes an array and returns the frequency of each member of vals
% if vals is not specified, it finds the frequency of each unique member of x 
%
% this is the old slow (but transparent) version. Could be used for testing
% the new one
function[freqs,vals,o]=FrequenciesOLDSlow(x,vals)
if(isempty(x))
    if(nargin>1)
        freqs=zeros(size(vals));
    else
        freqs=[];
        vals=[];
    end
    return;
end
x=x(:)';
if(nargin<2) 
    vals =unique(x); 
end;
freqs=zeros(size(vals));
for i=1:length(vals)
    freqs(i) = length(find(x==vals(i)));
end
