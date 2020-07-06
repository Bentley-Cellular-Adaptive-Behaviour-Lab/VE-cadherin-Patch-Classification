function[Picked] = PickFileFromList(f,NumOnLine)

if(nargin<2) NumOnLine=1; end;
if(nargin<1) f=''; end;
s=dir(f);
if(isempty(s)) 
    Picked=0;
    return;
end
while 1
    WriteFileOnScreen(s, NumOnLine);
    Picked=ForceNumericInput('select file number or return to select none: ');
    if(isempty(Picked))
%         j=input('No file selected. Return if this is ok\n');
%         if(isempty(j))
            Picked=0;
            return;
%         end
    else
%         j=input(['File ' s(Picked).name ' selected. Return if this is ok\n']);
%         if(isempty(j))
            Picked=s(Picked).name;
            return;
%         end
    end
end

function WriteFileOnScreen(fns, NumOnLine)
if isempty(fns) return; end
L=size(fns,1);
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