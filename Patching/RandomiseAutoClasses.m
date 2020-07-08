rand('twister', sum(100*clock));
load temp_RndDat
nin=size(vals,1);
rp=randperm(nin);
vals=vals(rp,:);
x=floor((nin-1)/6)
m=zeros(6,size(vals,2));
s=m;
figure(1)
for j=1:6
    is=((j-1)*x+1):(j*x);
    m(j,:)=mean(vals(is,:),1);
    s(j,:)=std(vals(is,:),1);
end

strs={'dens small';'dens lines';'dens bigs';'m wigg big';...
    'm ecc big';'m area big';'max area big';'sum area big';...
    'mean green';'% over thresh';'m area all';'#lines';'#big';'#med';...
    'all big';'big*wigg';'wigg nz';'ecc nz';...
    'class';'# patches'};
i_pl=[13 14 4 5];% 4 17 5 18 15 16];


for i=1:size(m,2)
    subplot(2,2,i);
    BarErrorBar(1:6,m(:,i),s(:,i))
    ylabel(strs(i_pl(i)))
end

rp=randperm(nin);
vals=vals(rp,:);
figure(2)
i2=[0 cumsum(ninclass)]
for j=1:6
    is=(i2(j)+1):i2(j+1);
    m(j,:)=mean(vals(is,:),1);
    s(j,:)=std(vals(is,:),1);
end

for i=1:size(m,2)
    subplot(2,2,i);
    BarErrorBar(1:6,m(:,i),s(:,i))
        ylabel(strs(i_pl(i)))

end
