function[NumIn,i,j,vals]=NumInRange(V,a,EqOrNot)

if(EqOrNot)
   NewV=(V==a);
   [i,j,vals]=find(NewV.*V);
   NumIn=length(i);
else
   NewV=(V~=a);
   [i,j,vals]=find(NewV.*V);
   NumIn=length(i);
end
