% function[dat]=GetSmallVarsFromFile(fn,sz)
% 
% function which gets the variables from fn and removes any that are below
% sz Mb and retruns them in a structure dat

function[dat]=GetSmallVarsFromFile(fn,sz)
load(fn);
s=whos;
bytes=[s.bytes];
s=s(bytes<(sz*1e6));
dat=[];
for i=1:length(s)
    name=char(s(i).name);
    eval(['dat.' name '=' name]);
end
% bigs=