function CompareDir
dmat;
cd CEC2002
d1=cd;
d2=['k:TempLap\MatlabFiles\CEC2002'];
CompareFiles(d1,d2)

function CompareFiles(d1,d2)
l1=dir(d1);
l2=dir(d2);
m1=length(l1);
m2=length(l2);
[x1{1:m1}]=deal(l1.name);
[x2{1:m2}]=deal(l2.name);
equals=ismember(x1,x2);