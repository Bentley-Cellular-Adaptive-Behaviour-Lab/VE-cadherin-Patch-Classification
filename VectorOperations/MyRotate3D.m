% function[newx]=MyRotate3D(x,az,el,Cart)
% function to rotate all points in x=(th,phi,r) (default)
% or x=(x,y,z) (if Cart is defined) (in columns) thru az and el radians

function[nth,nphi,nr]=MyRotate3D(th,phi,r,az,el,Cart)
if (Cart|(nargin>3)) [th,phi,r]=cart2sph(th,phi,r); end;
nth=th+az;
nphi=phi+el;
nr=r;
if (Cart|(nargin>3)) [nth,nphi,nr]=sph2cart(nth,nphi,nr); end;
