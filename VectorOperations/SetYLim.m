% function SetYLim(x1,x2,AxHdl)
% Sets the xaaxis limits to x1 and x2. if only x1 is passed sets the limit nearest
%  to x1 to x1 and leaves the other where it was. if either are empty it leaves 
% them where they are Default AxHdl = gca

function SetXLim(x1,x2,AxHdl)
if(nargin<3) AxHdl=gca;end;
if(nargin==1)
   X=get(AxHdl,'YLim');
   if(abs(x1-X(1))>abs(x1-X(2)))
      X(2)=x1;
   else
      X(1)=x1;
   end
   set(AxHdl,'YLim',X);
elseif(isempty(x2))
   X=get(AxHdl,'YLim');
   X(1)=x1;
   set(AxHdl,'YLim',X);   
elseif(isempty(x1))
   X=get(AxHdl,'YLim');
   X(2)=x2;
   set(AxHdl,'YLim',X);   
else
   set(AxHdl,'YLim',[x1 x2]);
end   