% function SquareAx(fhdl,SquareF,n)
% makes the figure in fighdl have a square axis n% (default 80)
% of the figure size. 
% If SquareF=1 (default is 1) it makes the figure square too 
% Bit buggy but works ok

function SquareAx(fhdl,n)

if(nargin<1) fhdl = gcf; end;
if(nargin<2) SquareF = 1; end;
if(nargin<3) n=0.8; end;

X=get(gcf,'Position');
if(X(3)<X(4))
    if(SquareF)
        X(4)=X(3);
        set(gcf,'Position',X);
    end
    nval=n*X(3)/X(4);
    set(gca,'Position',[0.1 0.1 n nval]);
else
    if(SquareF)
        X(3)=X(4);
        set(gcf,'Position',X);
    end
    set(gcf,'Position',X);
    nval=n*X(4)/X(3);
    set(gca,'Position',[0.1 0.1 nval n]);
end
