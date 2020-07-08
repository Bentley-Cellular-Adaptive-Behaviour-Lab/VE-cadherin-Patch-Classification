function[h]=TextXYZGui(str,hdl,x,y,wid,ht)
% get the position of the current object
pos = hdl.Position;

if((nargin<2)||isempty(hdl))
    hdl=gcf;
end
if((nargin<3)||isempty(x))
    x=0.01;
end
if((nargin<5)||isempty(wid))
%     wid=np2(3);
    wid=pos(3)-x-0.01;
end
if((nargin<6)||isempty(ht))
%     ht=np2(4);
    ht=0.05;
end
if((nargin<4)||isempty(y))
    y=0.01+ht;
end


% % use text simply to get width of text box
% % TODO: this dodn't work when I tried it as the text was a different font
% hdum=text(0,0,str,'FontName');% ,gcf.FontName,'FontSize',gcf.FontSize);
% hdum.Units='normalized';
% np2=hdum.Extent;
% delete(hdum)



newpos=[pos(1)+x, pos(2)+pos(4)-y, wid, ht];
h=uicontrol('Style','Text','String',str,'Units',...
    'normalized','Position',newpos,'HorizontalAlignment','left');

 
