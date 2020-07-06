% Function which takes a vector V and reverses the elements

function[NewV]=INVERT(V)

N=length(V);
for i=1:N
   NewV(i)=V(N-i+1);
end
return