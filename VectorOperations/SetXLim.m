% function SetXLim(AxHdl,x1,x2)
% Sets the xaaxis limits to x1 and x2. if only x1 is passed sets the limit nearest
%  to x1 to x1 and leaves the other where it was. if either are empty it leaves 
% them where they are

function SetXLim(AxHdl,x1,x2)

if(nargin==2)
   X=get(gca,'XLim');
   if(abs(x1-X(1))>abs(x1-X(2)))
      X(2)=x1;
   else
      X(1)=x1;
   end
   set(gca,'XLim',X);
elseif(isempty(x2))
   X=get(gca,'XLim');
   X(1)=x1;
   set(gca,'XLim',X);   
elseif(isempty(x1))
   X=get(gca,'XLim');
   X(2)=x2;
   set(gca,'XLim',X);   
else
   set(gca,'XLim',[x1 x2]);
end   