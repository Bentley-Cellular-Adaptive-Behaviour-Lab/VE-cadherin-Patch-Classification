% function[Col,LSty,Mark]=PlotSkip(x,y,i,sk,PHdl)
% function which plots x vs y in plot PHdl using colour i,LineStyle i and symbol i 
% from the following lists: 
%							Colors=['b';'g';'y';'k';'c';'r']';
%							LineStyles=['- ';': ';'--';'-.';'- ';'--'];
%							Symbols=['x   ';'.   ';'o   ';'d   ';'^   ';'none'];
% however, it only plots symbol i every sk points along the line

function[Col,LSty,Mark]=PlotSkip(x,y,i,sk,PHdl)

Colors=['b';'g';'y';'k';'c';'r']';
LineStyles=['- ';': ';'--';'-.';'- ';'--'];
Symbols=['x   ';'.   ';'o   ';'d   ';'^   ';'none'];
xsk=x(1:sk:length(x));
ysk=y(1:sk:length(y));
figure(PHdl)
if(Symbols(i,:)~='none')
   plot(xsk,ysk,[Colors(i) Symbols(i,:)]);
   hold on;
   plot(x,y,[Colors(i) LineStyles(i,:)]);
	hold off;   
end
Col=Colors(i);
LSty=LineStyles(i,:);
Mark=Symbols(i,:);

