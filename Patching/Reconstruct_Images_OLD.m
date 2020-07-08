function Reconstruct_Images_OLD(fnlist,opt)

%  CheckTypeV2s(fn)
if(opt==1)
    AssignClassToPatchIm(fnlist);
elseif(opt==2)
    AssignColocToPatchIm(fnlist)
end

function AssignColocToPatchIm(fnlist)

% % set up the type of output you want
% %
% disp(' ');
% disp('Pick the ');

% set the number of bins for the data
nbins=10;

% get the colormap
[cmap,cmapw]=ColMapColoc(nbins);

% set the threshold
disp('Enter a threshold value for the colocalised data.')
disp('This should be a number between 0 and 1 and sets the colocalised')
disp('threshold as the maximum  colocalised value in each image')
pcthresh=ForceNumericInput('multiplied by the value input (eg 0.1 is 10%):  ')

% now decide whether you want to group the data
% WriteFileOnScreen(fnlist,1);
% fn_starts={'ctrl';'mutant'}
% inp=input('For different file-starts/all files enter 0: ');
% if(inp==0)
%     fn_starts={};
% end

% set up some iniital variables for data collection etc
ColocData=[];
Freqs=[];
allcoloc(1).cols=[];
handclasFlag=1;
for i=1:length(fnlist)
    fn=fnlist(i).name;
    if(isequal(fn(end-2:end),'lsm'))
        % do the LSM version
        lsmflag=1;
        fno=[fn(1:end-4) '_sl1_Mask.mat'];
        load(fno);
    else
        lsmflag=0;
        nl=1;
    end

    for sl=1:nl
        if(lsmflag)
            fn_start=[fn(1:end-4) '_sl' int2str(sl)];
        else
            fn_start=fn(1:end-4);
        end
    fno=[fn_start '_Mask.mat'];
    fnout=[fn(1:end-4) '_sl' int2str(sl) '_ColIm.mat'];
    imout=[fn(1:end-4) '_Im_sl_' int2str(sl) '.tiff'];
                fno2=[fn(1:end-4) '_sl' int2str(sl) '_Patch' int2str(j) 'HandClassRnd.mat'];

    % do the image version
    fno=[fn(1:end-4) '_Mask.mat'];
    fnout=[fn(1:end-4) '_ColIm.mat'];
    imout=[fn(1:end-4) '_ColIm.tiff'];
    load(fno)
    if(isequal(mask,-1))
        save(fnout,'cim');
    elseif(colchan==0)
        disp(['No coloc channel selected for  file ' fn])
    else
        % set the threshold value based on the max value in this image
        % could do something across the images also
        cthresh=max(colim(:))*pcthresh;

        % or if you want to do a hardcoded amount ie same for all files
        % uncomment the line below
        %cthresh=25
        for j=1:length(patches)                % in the hand classified version if it's a small patch it
            % gets classed as empty and doesn't get looked at
            %
            % not sure what to do about this in the coloc version
            % but probably isn't a big deal, so I've left it as empty
            % if it's a small (area > 10) but could change this to
            % greater than 0 as shown
            if(patches(j).area>10)
                % if(patches(j).area>0)

                % load the patch data as this has the coloc in it
                fno2=[fn(1:end-4) '_Patch' int2str(j) '.mat'];
                load(fno2)

                % get the hand classified fielname
                fn2=[fn(1:end-4) '_Patch' int2str(j) 'HandClassRnd.mat'];

                % usually I'd pass in the filename fn2 as a string
                % including the folder but there's issues going between
                % mac and pc with / and \ etc
                % first check if data has been classified by hand
                if(isdir('HandClassified'))
                    cd HandClassified
                else
                    handclasFlag=0;
                end

                % this assigns a class to the patch based on the Hand
                % Classified data
                [clas,ptype,stren]=GetClassFromAttributes(fn2,patches(j).area);
                patches(j).ptype=ptype;
                patches(j).stren=stren;
                patches(j).class=clas;

                % then come back to the original directory if have
                % cd-ed to HandClassified
                if(handclasFlag)
                    cd ..
                end

                % various options here as to what to do with coloc data

                % first mask out the coloc patch
                colocmask=col_patch.*mask_patch;

                % make it into a vector
                colocmasc_vec=colocmask(:);

                % then get all the above 0 values which essentially is
                % all the bits that are in the mask
                colocmasc_vec_over0=colocmasc_vec(colocmasc_vec>0);

                % mean value of above coloc in the mask
                %                     patches(j).class=mean(colocmasc_vec_over0);

                % alternatively could do the mean value of all over
                % threshold points
                colocmasc_vec_overT=colocmasc_vec(colocmasc_vec>cthresh);
                %                     patches(j).class=mean(colocmasc_vec_overT);

                % Or the percentage of that mask that is over
                % threshold
                pc_overT=100*length(colocmasc_vec_overT)/length(colocmasc_vec_over0);
                patches(j).coloc=pc_overT;
            else
                % small classed as empty
                patches(j).ptype=-2;
                patches(j).stren=0;
                patches(j).class=0;
                patches(j).coloc=0;
            end
        end

        cols=[patches.coloc];
        [coldat,fr]=GetColocData(patches);
        figure(2*i-1);
        clf
        PlotColocData(coldat,cols,fr,fn)

        allcoloc(i).cols=cols;
        ColocData=[ColocData;coldat];
        Freqs=[Freqs;fr];

        cim=zeros(size(rim));
        cim=ColourPatchColoc(mask,patches,cim);

        %             subplot(2,2,1),
        figure(2*i);
        clf
        imagesc(cim);
        caxis([0 55]),
        %colormap(cmapw)
        title('Masked patch coloured according to coverage')
        axis equal;
        axis off;
        set(gca,'Position',[0 0 1 1],'Box','off','TickLength',[0 0])
        print(imout,'-dtiffn');
        title(fn)
        save(fnout,'colim','cmap','cmapw','cim','patches','coldat','cthresh','fr')%,'vim','thl');
    end
end
figure(2*i+1);
PlotColocData(ColocData,allcoloc,Freqs,'all data')


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
hist(cols)
axis tight
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
    0 255 174;0 167 255;0 0 255;...  % 1 :3 weakly to Strongly inhibited – 6 classes;
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
    0 255 174;0 167 255;0 0 255;...  % 1 :3 weakly to Strongly inhibited – 6 classes;
    0 255 5;0 255 5;0 255 5;...% 4:6 is mixed, weakly to strongly
    0 0 0;0 0 0]/255;   % last ones are black
cmapw=cmap;
cmapw(8:10,:)=1;

function[cmap,cmapw]=ColMap
cmap=[255 0 0;255 180 0;161 255 0;... % Strongly active -3:-1;
    0 0 0;...% 0 = empty
    0 255 174;0 167 255;0 0 255;...  % 1 :3 weakly to Strongly inhibited – 6 classes;
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