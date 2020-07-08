function Script_949Data
wtfiles=dir('*wt*.mat');
for j=1:length(wtfiles)
    load(wtfiles(j).name)
    wtprop(j,:)=100*Fs/sum(Fs);
    wt(j,:)=Fs;
    disp(wtfiles(j).name)
end
kofiles=dir('*ko*.mat');
disp(' ')

for j=1:length(kofiles)
    load(kofiles(j).name)
    ko(j,:)=Fs;
    koprop(j,:)=100*Fs/sum(Fs);
    disp(kofiles(j).name)
end

n=ones(1,6)*NaN;
xldat=[wt;n;ko;n;100*sum(wt)/sum(wt(:));100*sum(ko)/sum(ko(:));...
    n;n;wtprop;n;n;koprop;n;n;mean(wtprop);mean(koprop);...
    n;median(wtprop);n;median(koprop)];
xlswrite('summary data.xls',xldat);
save 949SummaryData.mat ko* wt* xldat
x=[-3:-1 0:2];
subplot(2,1,1)
plot(x,mean(wtprop),'k',x,mean(koprop),'r:')
subplot(2,1,2)
plot(x,median(wtprop),'k',x,median(koprop),'r:')
for i=1:6
[p,h]=ranksum(wtprop(:,i),koprop(:,i))
end

wt_act=sum(wtprop(:,1:3),2)
ko_act=sum(koprop(:,1:3),2)
median(ko_act)
median(wt_act)
[p,h]=ranksum(wt_act,ko_act)
[p,h]=ranksum(wt_act,ko_act,'tail','right')

% wt_act_weighted=mean([wtprop(:,1)*3,wtprop(:,2)*2,wtprop(:,3)]/100,2)
% ko_act_weighted=mean([koprop(:,1)*3,koprop(:,2)*2,koprop(:,3)]/100,2)


