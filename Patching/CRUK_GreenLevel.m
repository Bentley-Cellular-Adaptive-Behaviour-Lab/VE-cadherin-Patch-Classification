function CRUK_GreenLevel(fn)

thresh=[2000]% 1500 2500:500:4000];
currdir=cd;
avals=[];grs=[];avalm=[];grm=[];ls=[];

threshMax=[2342,2342,3634,3634,2569,2569];
threshS=[1563,1563,2025,2025,1667,1667];
for k=1:length(thresh)
    c=1;
    
    for i=[1 3]%:4]
        changedir(i);
        s=dir('*.lsm');

        for j=1:length(s)
            fn=s(j).name;
            strs(c).name=fn;
%             GetMaxGreenLevel(s(j).name);
%             [valm]=GetValsThreshMax(fn,threshMax(c),threshS(c));
             [thmed,thmed_s,nl]=GetThreshMax(s(j).name,3);
             
             strs(c).thmed=thmed;
             strs(c).thmed_s=thmed_s;
             strs(c).nl=nl;

            [ym(c,:),xm(c,:),ys(c,:),xs(c,:),...
                vals,valm,th_m,th_s]=ShowDataMax(fn);
            avals=[avals;vals];
            grs=[grs;ones(size(vals))*c];
            avalm=[avalm;valm];
            grm=[grm;ones(size(valm))*c];
            strs(c).th=th_m;
            strs(c).th_s=th_s;
            strs(c).l=length(valm);
            c=c+1;
            ls=[ls [length(valm); length(vals)]]
            %             GetGreenLevelV2(s(j).name,[],4);
            %             GetGreenLevelV2(s(j).name,thresh(k));
        end
        
        %         for j=1:length(s)
        %             [med(j),y(j,:),x(j,:),dat(j).d]=ShowData(s(j).name,thresh(k));
        % %             figure(j)
        % %             bar(m)
        % %             ma(j).d=m;
        % %             med(j)=median(m);
        %             title(s(j).name)
        %         end
        %         figure(j+1)
        %         subplot(1,2,1)
        %         plot(x(1,:),y(1,:),x(2,:),y(2,:),'r:')
        %         axis tight, xlim([0 2e4])
        %         xlabel('green level'),
        %         ylabel('frequency'),
        %         Setbox
        %         subplot(1,2,2)
        %         bar(med);
        %         ylim([0 3.5e3])
        %         ylabel('green level'),
        %         Setbox
    end
end
strs
cd(currdir);

figure(1)
h=boxplot(avalm,grm,'positions',[1 2 3 5 4 6])
set(h(7,:),'Visible','off')
SetXTicks(gca,[],[],[],[],{'DAPT';'DMSO';'DAPT';'DMSO';'DAPT';'DMSO'})
Setbox
ylim([0 4e4])
title('max across z-stack')

figure(2)
h=boxplot(avals,grs,'positions',[1 2 3 5 4 6])
set(h(7,:),'Visible','off')
SetXTicks(gca,[],[],[],[],{'DAPT';'DMSO';'DAPT';'DMSO';'DAPT';'DMSO'})
Setbox
ylim([0 4e4])
title('mean across z-stack')


% x=xm;y=ym;m=4e4;xstr=('max green value')
x=xs;y=ys;m=1.25e4;xstr=('mean green value')
figure(1)
plot(x(1,:),y(1,:),'k',x(2,:),y(2,:),'k:','LineWidth',2)
axis tight,xlim([0 m]),Setbox;
xlabel(xstr);ylabel('frequency')
figure(3)
plot(x(3,:),y(3,:),'k',x(5,:),y(5,:),'k:','LineWidth',2)
axis tight,xlim([0 m]),Setbox
xlabel(xstr);ylabel('frequency')
figure(4)
plot(x(4,:),y(4,:),'k',x(6,:),y(6,:),'k:','LineWidth',2)
axis tight,xlim([0 m]),Setbox
xlabel(xstr);ylabel('frequency')

return
% CheckGreenLevel(s);
% return
% for i=[1 3]%:length(s)
%     Magnified(s(i).name,i*10);
% end

%
%
%     GetMaxGreenLevel(s(i).name);
% end

% to show the data

for i=1:length(s)

    %     GetMaxGreenLevel(s(i).name);
end
legend(s(1).name,s(2).name);

function[valm,vals]=GetValsThreshMax(fn,th_m,th_s)
fnl=[fn(1:end-4) '_data_3AllNoFillSmall.mat'];
load(fnl);
fns=[fn(1:end-4) '_datathreshAuto.mat']
[valm]=getvalsthresh(maxims,3,'max',th_m);
[vals]=getvalsthresh(s,3,'mean',th_s);
save(fns,'vals','valm','th_s','th_m','nl')

function[ym,xm,ys,xs,vals,valm,th_m,th_s]=ShowDataMax(fn)
ch=3;
% fns=[fn(1:end-4) '_datathresh.mat'];
fns=[fn(1:end-4) '_datathreshAuto.mat'];
load(fns)
[y,xm]=hist(valm,1000);ym=y/sum(y);
[y,xs]=hist(vals,1000);ys=y/sum(y);


function[thmed,thmeds,nl]=GetThreshMax(fn,ch)
fnl=[fn(1:end-4) '_data_' int2str(ch) 'AllNoFillSmall.mat'];
load(fnl);
thmed=median(maxims(:))*1.1;
thmeds=median(s(:))*1.1;
fns=[fnl(1:end-20) 'thresh.mat']
% if(~isfile(fns))
% %     load(fnl);
%     [vals,im_s,th_s,sig_s,small_s,opt_s]=getthresh(s,3,'mean');
%     save(fns)
%     [valm,im_m,th_m,sig_m,small_m,opt_m]=getthresh(maxims,3,'max');
%     save(fns)
% end

function changedir(fn,currdir)
if(fn==1) cd ../../Dsred_VEcadGFP_Dapi_4/10X
elseif(fn==2) cd ../../Pecam1_VEcad(GFP)_Dapi_2/10X
elseif(fn==3) cd ../../VEcad(GFP)_DsRed_Dapi_3/10X
elseif(fn==4) cd ../../VEcadGFP_Dll4_Dapi_1/10X
end



function[me,y,x,allvals]=ShowData(fn,th)
ch=3;
if(nargin<2)
    load([fn(1:end-4) '_data_' int2str(ch) 'v3.mat'])
else
    load([fn(1:end-4) '_data_' int2str(ch) 'Th' int2str(th) '.mat']);
end
% for i=1:length(dat)
%     me(i)=median(dat(i).vals);
% end
[y,x]=hist(allvals,1000);
me=median(allvals);
y=y./sum(y);

function CheckGreenLevel(s)
dc=1;
for ch=3%1:dc
    grr=[];
    for i=1:length(s)
        fn=s(i).name;
        load([fn(1:end-4) '_data_' int2str(ch) 'v3.mat'],'meds','thlev','grs','x','hall');
        for gr=1:length(grs)
            grr=[gr grs(gr).dat'];
        end
        [y,xx(i,:)]=hist(grr,100);
        yy(i,:)=y./sum(y);
        figure(4),
        subplot(dc,2,2*(ch-1)+i)
        plot(x,hall)
        [mm,x3(i,:)]=hist(meds(:,3));
        m(i,:)=mm/sum(mm);
        [thth,x2(i,:)]=hist(thlev);
        th(i,:)=thth/sum(thth);
        figure(2),
        subplot(dc,2,2*(ch-1)+i)
        boxplot(meds(:,3)')
        title(fn)
    end
    %     hold off;
    figure(1)
    subplot(dc,1,ch)
    plot(x3',m'),axis tight
    figure(3)
    subplot(dc,1,ch)
    plot(x2',th'),axis tight
    figure(5)
    subplot(dc,1,ch)
    plot(xx',yy'),axis tight
end

function Magnified(fn,fp)

% fn='DAPT_1.lsm';
im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
% zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX,dc);
zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX,dc);
ch=2;
thlev=350;
bigs=50;
histl=1:200:4e4;
for ch=1:dc
    figure(fp+ch)
    for i=round(nl/2)%1:nl
        i
        im=tiffread29(fn,2*i-1);
        nim=zs;
        for j=1:dc
            nim(:,:,j)=cell2mat(im(1).data(j));
        end
        %     h=subplot(2,2,1),
        %     show_image(im.data(1:3),h);
        m=nim(:,:,ch);

        subplot(2,2,1),
        imagesc(m);
        title([fn '; channel ' int2str(ch)])
        subplot(2,2,2),
        thlev(i)=0.5*median(max(m));
        thlev(i)=5*median(median(m));
        bw=(m>thlev(i));
        bwclean=bwareaopen(bw,50,8);

        imagesc(bwclean); hold on;
        %     [B,L,N] = bwboundaries(bwclean);
        %     for k=1:length(B),
        %         boundary = B{k};
        %         if(k > N)
        %             plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
        %         else
        %             plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
        %         end
        %     end
        hold off
        subplot(2,2,3)
        imagesc(stdfilt(m));
        subplot(2,2,4)
        imagesc(rangefilt(m));
        %     [hall(i,:),x]=hist(m(:),histl);
        %     bar(x,hall(i,:));
        %     newm=double(m).*double(bwclean);
        %     [dum,dum,grs(i).dat]=find(newm);
        %     subplot(2,2,4)
        %     [hb(i,:),x]=hist(grs(i).dat,histl);
        %     bar(x,hb(i,:));
        %     meds(i,:)=prctile(grs(i).dat,[5 25 50 75 95])
        drawnow;
    end
    % save([fn(1:end-4) '_data_' int2str(ch) 'v3.mat']);
end

function GetGreenLevelV2(fn,th,ch)
% fn='DAPT_1.lsm';
im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
% zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX,dc);
% zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX);
thlev=350;
bigs=50;
histl=1:200:4e4;
if(nargin<3)
    ch=3;
end
allvals=[];
for i=1:nl
    im=tiffread29(fn,2*i-1);
    m=double(cell2mat(im(1).data(ch)));%nim(:,:,ch);
    if((nargin<2)||isempty(th))
        while 1
            if(i==1)
                [vs,im_s,thresh(i)]=getthresh(m,1,i);
            else
                [vs,im_s,thresh(i)]=getthresh(m,1,i,thresh(i-1));
            end
            inp=input('enter -1 if you want to redo or return to continue');
            if(~isequal(inp,-1))
                break;
            end
        end
        save([fn(1:end-4) '_data_' int2str(ch) 'Thresh.mat'],'thresh','i');
    else
        [vs,im_s]=getdatath(m,1,th,i);
    end
    dat(i).vals=vs';
    allvals=[allvals vs'];
    %     save([fn(1:end-4) '_data_' int2str(ch) 'v3.mat']);
end
if(nargin<2)
    save([fn(1:end-4) '_data_' int2str(ch) 'v3.mat']);
else
    save([fn(1:end-4) '_data_' int2str(ch) 'Th' int2str(th) '.mat']);
end



function GetGreenLevel(fn)
% fn='DAPT_1.lsm';
im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
% zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX,dc);
% zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX);
ch=2;
thlev=350;
bigs=50;
histl=1:200:4e4;
ch=3%1:dc
for i=1:nl
    i
    im=tiffread29(fn,2*i-1);
    nim=zs;
    %     for j=1:dc
    %         nim=cell2mat(im(1).data(j));
    %     end
    %     h=subplot(2,2,1),
    %     show_image(im.data(1:3),h);
    m=cell2mat(im(1).data(ch));%nim(:,:,ch);

    subplot(2,2,1),
    imagesc(m);
    subplot(2,2,2),
    thlev(i)=0.5*median(max(m));
    thlev(i)=1.25*median(median(m));
    while thlev(i)>0
        bw=(m>thlev(i));
        bwclean=bwareaopen(bw,50,8);
        imagesc(bw); hold on;
        %     [B,L,N] = bwboundaries(bwclean);
        %     for k=1:length(B),
        %         boundary = B{k};
        %         if(k > N)
        %             plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
        %         else
        %             plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
        %         end
        %     end
        hold off
    end
    subplot(2,2,3)
    [hall(i,:),x]=hist(m(:),histl);
    bar(x,hall(i,:));
    newm=double(m).*double(bwclean);
    [dum,dum,grs(i).dat]=find(newm);
    subplot(2,2,4)
    [hb(i,:),x]=hist(grs(i).dat,histl);
    bar(x,hb(i,:));
    meds(i,:)=prctile(grs(i).dat,[5 25 50 75 95])
    drawnow;
end
save([fn(1:end-4) '_data_' int2str(ch) 'v3.mat']);


function GetMaxGreenLevel(fn)
% fn='DAPT_1.lsm';
im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
ch=3;
fnl=[fn(1:end-4) '_data_' int2str(ch) 'All.mat'];
if(~isfile(fnl))
    allims=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX,nl);
    maxims=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX);
    % zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX);
    for i=1:nl
        i
        im=tiffread29(fn,2*i-1);
        allims(:,:,i)=cell2mat(im(1).data(3));%nim(:,:,ch);
        maxims=max(maxims,allims(:,:,i));
    end
    s=mean(allims,3);
    save(fnl);
    clear allims
    save([fnl(1:end-4) 'Small.mat'])
else
end
%     load(fnl);

% [vals,th_s,im_s]=getthresh(s,0,'mean');
% [valm,th_m,im_m]=getthresh(maxims,0,'max');

function[vals,clean_im]=getdatath(s,opt,thresh,i)

pl=0;
bw=(s>thresh);
bwclean=bwareaopen(bw,50,8);
if(opt)
    bw2=imfill(bwclean,'holes');
else
    bw2=bwclean;
end
clean_im=s.*double(bw2);
v=clean_im(:);
if(pl)
    [y,x]=hist(v(v>0),1000);
    subplot(2,2,1), imagesc(s)
    title(['image ' int2str(i) '; threshold ' int2str(thresh)])
    subplot(2,2,2), imagesc(bw)
    subplot(2,2,3), imagesc(clean_im)
    subplot(2,2,4), plot(x,y/sum(y))
end
vals=v(v>0);

function[vals,clean_im,thresh,sigma,smalls,opt]=getvalsthresh(s,opt,i,thresh)

sigma=0;
smalls=100;
if(sigma>0)
    hsize=5*sigma;
    h = fspecial('gaussian', hsize, sigma);
    s_im=imfilter(s,h,'symmetric');
else
    s_im=s;
end

bw=(s>thresh);
if(smalls>0)
    bwclean=bwareaopen(bw,smalls,8);
else
    bwclean=bw;
end

if(opt==-1)
    bw2=imfill(bwclean,'holes');
elseif(opt==0)
    bw2=bwclean;
else
    SE = strel('square', opt);
    bw2=imclose(bwclean,SE);
end
clean_im=s.*double(bw2);

plotstuff_gt(s,bw,bwclean,bw2,clean_im,i,thresh,sigma,opt,smalls)

v=clean_im(:);
vals=v(v>0);


function[vals,clean_im,thresh,sigma,smalls,opt]=getthresh(s,opt,i,thresh)
if(nargin<4)
    thresh=1.1*median(s(:));
end
sigma=0;
smalls=100;
while 1
    if(sigma>0)
        hsize=5*sigma;
        h = fspecial('gaussian', hsize, sigma);
        s_im=imfilter(s,h,'symmetric');
    else
        s_im=s;
    end

    bw=(s>thresh);
    if(smalls>0)
        bwclean=bwareaopen(bw,smalls,8);
    else
        bwclean=bw;
    end

    if(opt==-1)
        bw2=imfill(bwclean,'holes');
    elseif(opt==0)
        bw2=bwclean;
    else
        SE = strel('square', opt);
        bw2=imclose(bwclean,SE);
    end
    clean_im=s.*double(bw2);

    plotstuff_gt(s,bw,bwclean,bw2,clean_im,i,thresh,sigma,opt,smalls)

    [br,thresh,sigma,opt,smalls]=get_input_gt(thresh,sigma,opt,smalls);
    if(br==1)
        break;
    end
    %     inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
    %     if(isempty(inp))
    %         break;
    %     else
    %         thresh=inp;
    %     end;
end
v=clean_im(:);
vals=v(v>0);

function plotstuff_gt(s,bw,bwclean,bw2,clean_im,i,thresh,sigma,opt,smalls)
v=clean_im(:);
[y,x]=hist(v(v>0),1000);
subplot(3,2,1), imagesc(s)
if(ischar(i))
    title([i ' image; threshold ' int2str(thresh)])
else
    title(['image ' int2str(i) '; threshold ' int2str(thresh)])
end
subplot(3,2,2), imagesc(bw)
title(['threshold = ' int2str(thresh)])
subplot(3,2,3), imagesc(max(bw*.35,bwclean))
title(['removed objects below ' int2str(smalls)])
subplot(3,2,4), imagesc(max(bw2*0.7,bwclean)),
title(['filled holes size ' int2str(opt^2)])
subplot(3,2,5), imagesc(clean_im)
subplot(3,2,6), plot(x,y/sum(y))

function[br,thresh,sigma,opt,smalls] = get_input_gt(thresh,sigma,opt,smalls)
inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
br=0;
if(isempty(inp))
    br=1;
elseif(inp<0)
    keyboard;
else
    thresh=inp;
end;
