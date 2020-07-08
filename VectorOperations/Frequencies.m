% function[freqs,vals]=Frequencies(x,vals)
%
% function takes an array and returns the frequency of each member of vals
% if vals is not specified, it finds the frequency of each  member of x 
%
% This is an update of FrequenciesOLDSlow and works faster.
% I've pretty thoroughly tested it though keep the olde one just in case

function[freqs,vals]=Frequencies(x,vals)

% check if x is empty
if(isempty(x))
    if(nargin>1)
        freqs=zeros(size(vals));
    else
        freqs=[];
        vals=[];
    end
    return;
end

% if it's a matrix unwrap it and make it a row vector
x=x(:);

% first sort the data so it's in acending order
x=sort(x)';

% now do a diff, to find where there are any jumps which mean there's a new
% number. Need to add in the last point to get the largest number
js=[find(diff(x)),length(x)];

% now diff the result to find how many points there are between jumps, ie
% the frequency of each value. need the 0 to get the frequency of the 
% lowest values
n2=diff([0,js]);

% next find the value of each of the frequencies by looking at the js.
% These are the points of jumps in value so the last of each set of values
f2=x(js);

% The above only gets frequencies of the points that are in x. If we want
% frequencies of a set of values, need to do something slightly different
% There might be a quicker way than ismember for ordered stuff but this is
% pretty quick
if(nargin>1)    
    
    % first set all frequencies to 0
    freqs=zeros(size(vals));
    
    % find all positions in vals that are in f2 (in) and the indices of f2
    % (ia) that they are at
    [in,ia]=ismember(vals,f2);
    
    % insert the correct frequencies from n2 in to freqs
    freqs(in)=n2(ia(in));

else
    vals=f2;
    freqs=n2;
end