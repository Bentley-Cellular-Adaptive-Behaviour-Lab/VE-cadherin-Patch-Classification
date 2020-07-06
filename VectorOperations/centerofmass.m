function[centx,centy]=centerofmass(M)

[x,y]=size(M);
TotM=sum(sum(M));
RowSum=sum(M,1);
ColSum=sum(M,2);
centx=sum(RowSum.*[1:y])/TotM;
centy=sum(ColSum.*[1:x]')/TotM;