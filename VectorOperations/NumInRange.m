function[NumIn,i,j,vals]=NumInRange(V,a,b)

if(a==b)
   NewV=(V==a);
   [i,j,vals]=find(NewV.*V);
   NumIn=length(i);
else
   NewV=(V>a)&(V<=b);
   [i,j]=find(NewV);
   NumIn=length(i);
   vals=V(i);
end
