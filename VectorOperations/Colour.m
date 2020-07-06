% function[ColStr] = Colour(numb,LongList)
% returns line styles given an integer. Optional argument LongList fgoes
% througha longer list of colours. Colours cycle through list repeatedly.
% Lists are: Short=['b- ';'r: ';'g--';'k-.'];
%            LOng =['b- o';'g--x';'y- s';'k-. ';'c- ^';'r--d'] 

function[ColStr] = Colour(numb,LongList)
if(nargin<2) 
    Colors=['b- ';'r: ';'g--';'k-.'];
else
    Colors=['b- o';'g--x';'m: s';'k-. ';'c- ^';'r--d';'y: *'];
end
numb=mod(numb,length(Colors));
numb(numb==0)=length(Colors); 
ColStr=Colors(numb,:);
