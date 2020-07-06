function[flag,val] = IsIntStr(s)

if(s=='i') 
    flag=0;
    val=[];
else
    val=str2num(s);
    if(isempty(val)) flag=0;
    else flag=1;
    end
end