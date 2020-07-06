function WriteFileOnScreen(fns, NumOnLine)
if isempty(fns) 
    return; 
end
if(isstruct(fns))
    L=length(fns);
else
    L=size(fns,1);
end
N=fix(L/NumOnLine)-1;
M=rem(L,NumOnLine);
for i=0:N
    for j=1:NumOnLine
        fn=i*NumOnLine+j;
        fprintf('%d:  %s ',fn,fns(fn).name);
    end
    fprintf('\n');
end
for i=1:M
    fn=(N+1)*NumOnLine+i;
    fprintf('%d:  %s ',fn,fns(fn).name);
end