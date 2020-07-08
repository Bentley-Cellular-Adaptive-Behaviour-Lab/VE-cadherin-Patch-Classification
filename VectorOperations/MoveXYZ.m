function MoveXYZ(Hdl,x,y,z)

set(Hdl,'Units','normalized');
X=get(Hdl,'Position');
set(Hdl,'Position',X+[x y z]);