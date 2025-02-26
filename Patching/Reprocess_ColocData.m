function Reprocess_ColocData%(fnlist,opt)

fnlist=dir('*ColImAll.mat');

% set the threshold
disp('Enter a threshold value for the colocalised data.')
disp('This should be a number between 0 and 100 and sets the max ')
cmax=ForceNumericInput('colour in each image:  ');

allcols=[];
for k=1:length(fnlist)
    fn=fnlist(k).name;
    load(fn)
    
    cols=[allpatches.coloc];
    means(k)=median(cols);
    stds(k)=iqr(cols);
    [y(k,:),x]=hist(cols,0:0.5:100);
    disp(['file ' fn(1:end-13) ': mean=' num2str(means(k))])
    
    allcols=[allcols cols];
    if(~isempty(cim))
        % show and print images
        figure(3*k-1); clf
        imagesc(cim);
        caxis([0 cmax]),
        %colormap(cmapw)
        axis equal; axis off; title(['Dll4 coverage: ' fn ': mean=' num2str(means(k))])
%         set(gca,'Position',[0 0 1 1],'Box','off','TickLength',[0 0])
%         print(imout,'-dtiffn');
%         saveas(gcf,[imout(1:end-5) '.fig']);
        
        figure(3*k); clf
        imagesc(vim);
        caxis([0 cmax]),
%         axis equal; axis off; title(['Dll4 coverage, VeCad: ' fn])
%         set(gca,'Position',[0 0 1 1],'Box','off','TickLength',[0 0])
%         print(imoutV,'-dtiffn');
    end
end
for k=1:length(fnlist)
    figure(1)
    if(k<=4)
        plot(x,y(k,:)/sum(y(k,:)),'r')
    else
        plot(x,y(k,:)/sum(y(k,:)),'b')
    end
    hold on
end
hold off
axis tight
xlim([0 30])%max(allcols)+2])
xlabel('% coverage, red is KO, blue WT')
ylabel('num patches')
title(['% coverage, red is KO, blue WT'])

% figure(3*k+1);
% PlotColocData(ColocData,allcoloc,Freqs,'all data')



function[coldat,fr]=GetColocData(patches)%,classlist)
classlist=[-3:-1 1:3 0];
classes=[patches.class];
coloc=[patches.coloc];
for i=1:length(classlist)
    is=find(classes==classlist(i));
    fr(i)=length(is);
    coldat(i)=mean(coloc(is));
end
% currently not doing anything with the mixed classes
% mclasslist=[6:-1:4];


function PlotColocData(coldat,cols,fr,fn)
% astrall2={'active strong';'active medium';'active weak';'inhib weak';'inhib medium';'inhib strong';'empty'};
astrall2={'strong';'medium';'weak';'weak';'medium';'strong';'empty'};
s='% over threshold';

if(isstruct(cols))
    cols=[cols.cols];
end
subplot(2,2,1)
hist(cols,1:2:100)
axis tight
xlim([0 max(cols)+2])
xlabel(s)
ylabel('num patches')
title(['file ' fn ': histogram of ' s])
subplot(2,2,2)
if(size(coldat,1)==1)
    bar([-3:-1 1:3 5],coldat)
else
    BarErrorBar([-3:-1 1:3 5],mean(coldat)',std(coldat)');
    %     BarErrorBar([-3:-1 1:3 6:8],mean(dppc,1)',std(dppc,1)',[],[],['k';'w']);
end
axis tight
xlim([-4 6])
SetXTicks(gca,[],[],[],[-3:-1 1:3 5],astrall2)
ylabel('% over threshold')
title(['file ' fn ': ' s ' per class'])
subplot(2,2,3)
if(size(fr,1)==1)
    bar([-3:-1 1:3 5],fr)
else
    BarErrorBar([-3:-1 1:3 5],mean(fr)',std(fr)');
    %     BarErrorBar([-3:-1 1:3 6:8],mean(dppc,1)',std(dppc,1)',[],[],['k';'w']);
end
axis tight
xlim([-4 6])
SetXTicks(gca,[],[],[],[-3:-1 1:3 5],astrall2)
ylabel('number patches in each class')
title(['file ' fn ': num patches in each class'])
% output data
buf=NaN*ones(1,size(coldat,2));
dat=[coldat;buf;fr];
xlswrite([fn(1:end-4) '.xls'],dat);
% xlswrite([fn(1:end-4) 'HistData.xls'],dat);


function AssignClassToPatchIm(fnlist)

[cmap,cmapw]=ColMap;
cim=-1;
for sl=1:length(fnlist)
    fn=fnlist(sl).name;
    if(isequal(fn(end-2:end),'lsm'))
        % do the LSM version
        AssignClassToPatchLSM(fn);
    else

        % do the image version
        fno=[fn(1:end-4) '_Mask.mat'];
        fnout=[fn(1:end-4) '_Im.mat'];
        imout=[fn(1:end-4) '_Im.tiff'];
        load(fno)
        if(isequal(mask,-1))
            save(fnout,'cim');
        else
            cd HandClassified
            for j=1:length(patches)
                % if is not a small one
                if(patches(j).area>10)
                    fno2=[fn(1:end-4) '_Patch' int2str(j) 'HandClassRnd.mat'];
                    load(fno2)
                    patches(j).ptype=ptype;
                    patches(j).stren=strens;

                    % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
                    % 0 means that the patch wasn't classified
                    %  classes=[-3:-1;3:-1:1;6:-1:4
                    % strength is 1:3 where 1=high, 2=med,  3=low and is used for
                    % classes 1-3. Have to average for the mixed
                    if(ptype==1)  % active
                        cs=-3:-1;
                        patches(j).class=cs(strens);
                    elseif(ptype==2) % inhibited
                        cs=3:-1:1;
                        patches(j).class=cs(strens);
                    elseif(ptype==3)  % mixed
                        cs=6:-1:4;
                        patches(j).class=cs(round(mean(strens)));
                    elseif(ptype==4)   % empty
                        patches(j).class=0;
                    elseif(ptype==5)   % unsure
                        patches(j).class=7;
                    elseif(ptype==0)   % not done
                        patches(j).class=8;
                    else
                        patches(j).class=8;
                    end
                else
                    % small classed as empty
                    patches(j).ptype=-2;
                    patches(j).stren=0;
                    patches(j).class=0;
                end
            end
            %             if(isequal(cim,-1))
            cim=zeros(size(mask));
            %             end
            cim=ColourPatch(mask,patches,cim);

            mim=mask.*rim;
            vm=mim(:);
            thl=1.5*median(vm(vm>0));
            vim=(rim>thl).*cim;

            classes=[patches.class]
            subplot(2,2,1),
            imagesc(cim);
            caxis([-3 8]), colormap(cmapw)
            title('Masked patch coloured according to class')
            subplot(2,2,2),
            imagesc(vim)
            caxis([-3 8]),colormap(cmapw)
            title('Above threshold bits of patches coloured')
            subplot(2,2,3),
            imagesc(rim>thl)
            title('Above threshold bits of masked patches')
            subplot(2,2,4),
            imagesc(rim)
            title('original image being coloured')
            disp(['image ' int2str(sl) '/' int2str(length(fnlist)) '; press any key to continue']);
            pause;
            clf;
            imagesc(vim)
            caxis([-3 8]),colormap(cmapw)
            axis equal;
            axis off;
            set(gca,'Position',[0 0 1 1],'Box','off','TickLength',[0 0])
            print(imout,'-dtiffn');
            save(fnout,'rim','cmap','cmapw','cim','patches','vim','thl');
            cd ..
        end
    end
end


function AssignClassToPatchLSM(fn)

[cmap,cmapw]=ColMap;
fno=[fn(1:end-4) '_sl1_Mask.mat'];
load(fno);
cim=-1;
for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    fnout=[fn(1:end-4) '_sl' int2str(sl) '_Im.mat'];
    imout=[fn(1:end-4) '_Im_sl_' int2str(sl) 'Im.tiff'];
    load(fno)
    if(isequal(mask,-1))
        save(fnout,'cim','nl');
    else
        cd HandClassified
        for j=1:length(patches)
            % if is not a small one
            if(patches(j).area>10)
                fno2=[fn(1:end-4) '_sl' int2str(sl) '_Patch' int2str(j) 'HandClassRnd.mat'];
                load(fno2)
                patches(j).ptype=ptype;
                patches(j).stren=strens;

                % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
                % 0 means that the patch wasn't classified
                %  classes=[-3:-1;3:-1:1;6:-1:4
                % strength is 1:3 where 1=high, 2=med,  3=low and is used for
                % classes 1-3. Have to average for the mixed
                if(ptype==1)  % active
                    cs=-3:-1;
                    patches(j).class=cs(strens);
                elseif(ptype==2) % inhibited
                    cs=3:-1:1;
                    patches(j).class=cs(strens);
                elseif(ptype==3)  % mixed
                    cs=6:-1:4;
                    patches(j).class=cs(round(mean(strens)));
                elseif(ptype==4)   % empty
                    patches(j).class=0;
                elseif(ptype==5)   % unsure
                    patches(j).class=7;
                elseif(ptype==0)   % not done
                    patches(j).class=8;
                else
                    patches(j).class=8;
                end
            else
                % small classed as empty
                patches(j).ptype=-2;
                patches(j).stren=0;
                patches(j).class=0;
            end
        end
        if(isequal(cim,-1))
            cim=zeros(size(rim));
        end
        cim=ColourPatch(mask,patches,cim);

        mim=mask.*rim;
        vm=mim(:);
        thl=1.5*median(vm(vm>0));
        vim=(rim>thl).*cim;

        [patches.class]
        subplot(2,2,1),
        imagesc(cim);
        caxis([-3 8]), colormap(cmapw)
        title('Masked patch coloured according to class')
        subplot(2,2,2),
        imagesc(vim)
        caxis([-3 8]),colormap(cmapw)
        title('Above threshold bits of patches coloured')
        subplot(2,2,3),
        imagesc(rim>thl)
        title('Above threshold bits of masked patches')
        subplot(2,2,4),
        imagesc(rim)
        title('original image being coloured')
        disp(['slice ' int2str(sl) '/' int2str(nl) '; press any key to continue']);
        pause;
        clf;
        imagesc(vim)
        caxis([-3 8]),colormap(cmapw)
        axis equal;
        axis off;
        set(gca,'Position',[0 0 1 1],'Box','off','TickLength',[0 0])
        print(imout,'-dtiffn');
        save(fnout,'rim','cmap','cmapw','cim','patches','nl','vim','thl');
        cd ..
    end
end

function ColMapForFig
cmap=[255 0 0;255 180 0;161 255 0;... % Strongly active -3:-1;
    0 255 174;0 167 255;0 0 255;...  % 1 :3 weakly to Strongly inhibited � 6 classes;
    255 255 255;...% white
    0 0 0]/255;   % last ones is black
figure(1);
colormap(cmap);
h=colorbar;
str1=int2str([-3:-1 1:3 4 5]');
set(h,'YTick',1.5:8.5,'YTickLabel',str1)
s=char(str1(1:6,:),'mixed','empty');
figure(2);
colormap(cmap);
h=colorbar;
% set(h,'YTick',1.5:8.5,'TickLength',[0 0],'YTickLabel',s)
set(h,'YTick',1.5:8.5,'YTickLabel',s)
figure(3);
colormap(cmap);
s=char('strongly active','medium active','weakly active',...
    'strongly inhibited','medium inhibited','weakly inhibited',...
    'mixed','empty');
h=colorbar;
set(h,'YTick',1.5:8.5,'TickLength',[0 0],'YTickLabel',s)


% this is the colour map for the colocalised image
%
% It could be based on the number of bins that the data is binned into so
% I've passed that in as a variable but its currtnely unsued
function[cmap,cmapw]=ColMapColoc(nbins)
cmap=[255 0 0;255 180 0;161 255 0;... % Strongly active -3:-1;
    0 0 0;...% 0 = empty
    0 255 174;0 167 255;0 0 255;...  % 1 :3 weakly to Strongly inhibited � 6 classes;
    0 255 5;0 255 5;0 255 5;...% 4:6 is mixed, weakly to strongly
    0 0 0;0 0 0]/255;   % last ones are black
cmapw=cmap;
cmapw(8:10,:)=1;

function[cmap,cmapw]=ColMap
cmap=[255 0 0;255 180 0;161 255 0;... % Strongly active -3:-1;
    0 0 0;...% 0 = empty
    0 255 174;0 167 255;0 0 255;...  % 1 :3 weakly to Strongly inhibited � 6 classes;
    0 255 5;0 255 5;0 255 5;...% 4:6 is mixed, weakly to strongly
    0 0 0;0 0 0]/255;   % last ones are black
cmapw=cmap;
cmapw(8:10,:)=1;

function[im]=ColourPatch(mask,patches,im)

for i=1:length(patches)
    im(patches(i).rs,patches(i).cs)=patches(i).class;
end
im=im.*mask;

function[im]=ColourPatchColoc(mask,patches,im)

for i=1:length(patches)
    im(patches(i).rs,patches(i).cs)=patches(i).coloc;
end
im=im.*mask;


% this function is currently unused
% it is legacy code and was used to check that all patch classifications
% that had been entered were legal values but that should all be sorted now
% so it's unneccessary, but something similar  * might* be useful
%
% essentially, it runs thorough each patch and checks that the
% classifications is a legal value and if not, prompts the user to change
% it

function CheckTypeV2s(fn)

fno=[fn(1:end-4) '_sl1_Mask.mat'];
load(fno);
for sl=1:nl
    disp(['Checking slice ' int2str(sl) ]);
    fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    fnout=[fn(1:end-4) '_sl' int2str(sl) '_TypeV3.mat'];
    load(fno)
    if(~isequal(mask,-1))
        clear ptype strens
        %         fno2=['Classified\' fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
        fno2=[fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
        load(fno2)
        for j=1:length(ptype)
            if(ismember(ptype(j),1:3))
                while(~ismember(strens(j),1:3))
                    disp(['Current class is: ' int2str(ptype(j)) ', strength is: ' int2str(strens(j))])
                    strens(j)=input('enter strength, 1=high, 2=med,  3=low:  ');
                end
                p_str(j).s=num2str(strens(j));
            end
        end
        save(fnout,'ptype','strens','p_str','nl');
    end
end