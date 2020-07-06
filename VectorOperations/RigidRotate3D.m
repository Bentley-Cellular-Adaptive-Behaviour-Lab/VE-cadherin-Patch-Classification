% function[newx]=RigidRotate3D(x,y,z,az,el)
% function to rotate all points in x=(x,y,z) (in columns) thru az and el radians
% **Object needs to be centered on y-axis***

function[nx,ny,nz]=RigidRotate3D(x,y,z,az,el)
% first a rigid rotation around the y-axis to take it up thru -el
Ry = [cos(el) 0 -sin(el); 0 1 0; sin(el) 0 cos(el)];
X=Ry*[x;y;z];
x=X(1,:);y=X(2,:);z=X(3,:);

% then transform to sphericals and rotate around z by theta degrees
[th,phi,r]=cart2sph(x,y,z);
nth=th+az;
[nx,ny,nz]=sph2cart(nth,phi,r); 
