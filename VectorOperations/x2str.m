function[XString] = x2str(x)

[x,y]=FracRem(x);
if(abs(y)<1e-9)
    XString=int2str(x);
else
    XString=[int2str(x) '_' ];
    while(abs(y)>1e-9)
        x=10*y;
        [x,y]=FracRem(x);
        XString=[XString int2str(x)];
    end
end