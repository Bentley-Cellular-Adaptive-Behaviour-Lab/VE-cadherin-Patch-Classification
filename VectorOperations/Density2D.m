% function[D]=Density2D(x,y,n,ys)
% 
% returns an n x n matrix of densities of 2D data
% default n is 20. 
% if y is empty or undefined, each row of x is a 2d vector
% if ys is undefined, it uses the min and max values of the data to define
% n bin edges
% if ys is defined, it uses n and ys as vectors of bin edges
%
% USAGE:
% D=Density2D(rand(100,2))
% D=Density2D(rand(100,1),rand(100,1))
% D=Density2D(rand(100,2),[],10)
% D=Density2D(rand(100,1),rand(100,1),5)
% D=Density2D(rand(100,1),rand(100,1),0:0.1:1,0:0.25:1)

function[D,xs,ys,xps,yps]=Density2D(x,y,n,ys)
% parse inputs
if((nargin<2)||isempty(y))
    y=x(:,2);
    x=x(:,1);
end
if(nargin<3) n=20; end;
if(nargin<4)
    xs=linspace(min(x),max(x)*1.0001,n+1);
    ys=linspace(min(y),max(y)*1.0001,n+1);
else xs=n;
end
% get the densities
m=length(ys)-1;
D=zeros(m,length(xs));
for i=1:m
    is=find((y>=ys(i))&(y<ys(i+1)));
    if(~isempty(is)) D(i,:)=histc(x(is),xs); end;
end
D=D(:,1:end-1);
xps=0.5*(xs(1:end-1)+xs(2:end));
yps=0.5*(ys(1:end-1)+ys(2:end));