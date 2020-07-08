function[ns,s,e]=ReadNumbersFromString(str,opt)
o=regexp(str,'\d');
[s,e]=GetConsecutivePoints(o);
s=o(s);
e=o(e);
for i=1:length(s) 
    ns(i)=str2num(str(s(i):e(i))); 
end
