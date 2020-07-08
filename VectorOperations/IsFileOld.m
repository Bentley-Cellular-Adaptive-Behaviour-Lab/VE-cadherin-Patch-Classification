% [Out,fn]=IsFile(fname) 
% Out = 1 if file exists, 0 otherwise
% filename returned in fn (so wild cards can be used)

function[Out,fn]=IsFile(fname)

s=dir(fname);
if(length(s)==0)
   Out=0;
   fn=[];
else
   Out=1;
   fn=char(s.name);
end
