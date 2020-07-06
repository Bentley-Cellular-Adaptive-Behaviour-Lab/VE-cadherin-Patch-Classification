function[out,isdocked]=DockFigures(OnOrOff)
if((nargin<1)||isempty(OnOrOff))
    h=get(0,'DefaultFigureWindowStyle');
    if(isequal(h,'normal'))
        OnOrOff=1;
    else
        OnOrOff=0;
    end
end
if(OnOrOff)
    set(0,'DefaultFigureWindowStyle','docked')
    out='figs docked';
    isdocked=1;
else
    set(0,'DefaultFigureWindowStyle','normal')
    out='figs un-docked';
    isdocked=0;
end