function[LegHdl,ObjHdl]=SetLegend(LStyles,TextStrs,LineLengthScale)

DummHdl=subplot('Position',[1.5 1.5 1 1]);
x=0:1;
subplot(DummHdl);
for i=1:length(TextStrs)
   plot(x,LStyles(i,:));
   hold on;
end
hold off;
[LegHdl,ObjHdl]=legend(TextStrs);
set(LegHdl,'Units','normalized');
for i=2:length(ObjHdl)
   x=get(ObjHdl(i),'XData');
   if(length(x)==2)
   	x(2)=x(2)*LineLengthScale;
      set(ObjHdl(i),'XData',x);
   end
end
X=get(LegHdl,'Position');
set(LegHdl,'Position',[0.15 0.8 X(3) X(4)]);

function SetLegendLines(Cols,LStyles,Markers,LHdls)

LHdls=LHdls(2:length(LHdls));
for i=1:length(Cols)
   set(LHdls(i),'Color',Cols(i),'LineStyle',LStyles(i,:))
   if (Markers(i,:)~='none')
      set(LHdls(i),'MarkerEdgeColor',Cols(i),'Marker',Markers(i,:))
   end
end

