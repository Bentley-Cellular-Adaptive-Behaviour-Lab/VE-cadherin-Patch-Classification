function TextureAnalysisTiff

rand('twister',sum(100*clock));

% % get the list of files
% flistDA=dir('*DA.tif');
% flistV=dir('*V.tif');

% cd('C:\_MyDocuments\Current\My Dropbox\Dropbox\Junctions_ZO1\SMIFH2_junctions_Lifeact Exp2\cropped images Exp 2')
% check all are in right format
all=dir('*.tif');
% if((length(flistDA)+length(flistV))~=length(all))
%     disp('need to alter filenames so they end in either DA.tif or V.tif')
%     keyboard;
% end

% to run the automatic classification, one
% needs a threshold for objects based on the s.d. level.
% This is got via PickThreshes which calls GetStdThresh and is held in file
% V_StdThreshV3.mat or DA_StdThreshV3.mat
% to avoid overwriting, when generated I put this in folder HandThresholds

% opt=1 is thrsholding on std-image. opt=2 is thrsholding on image
opt=2; 

fn_starts={'DMSO_e';'SMIFH2_e'};

disp(' ')
if(opt==2)
    disp('THRESHOLDING BASED ON IMAGE');
else
    disp('THRESHOLDING BASED ON STD FILTER');
end


disp(' ')
disp('enter 1 to Pick Thresholds');
disp('enter 2 to auto classify');
disp('enter 3 to show results: ');
disp('enter 4 to hand classify: ');
inp=input('enter 5 to show hand classify results: ');
if(isequal(inp,1))
    PickThreshes(all,fn_starts,opt);
elseif(isequal(inp,2))
    AutoClassifyTiff(all,fn_starts,opt);
elseif(isequal(inp,4))
    ClassifyPatchesRandomTiff(all,fn_starts,opt);
elseif(isequal(inp,3))
    ShowClassifyTiff(opt);
else
    ShowClassifyPatches(fn_starts,opt)
end


function ShowClassifyPatches(fn_starts,opt)
Fs=zeros(4,6);
for i=1:4
    figure(i)
    cd(['..\..\SMIFH2_junctions_Lifeact Exp' int2str(i) '\cropped images Exp ' int2str(i)])
    Fs=Fs+GetFreqs(fn_starts);
end

figure(5)
c='total'
strs={[c 'DMSO V'];[c 'DMSO DA'];[c 'SMIFH2 V'];[c 'SMIFH2 DA']};
for i=1:4
    subplot(2,2,i)
    bar([-3:-1 1:3],100*Fs(i,:)/sum(Fs(i,:)))
    title(strs(i))
    npat=sum(Fs(i,:));
    out(i,:)=[npat Fs(i,:) round(100*Fs(i,:)/npat)];
end
disp(out)

function[Fs]=GetFreqs(fn_starts)
flist=dir('*.tif');
% get a lits of all the fish and a list of all the different fish
[fishlist,fishnums,fishfreqs]=DivideFilesIntoFish(flist,fn_starts);
c=[-3 -2 -1 3 2 1 4 5 6];
of='HandClassRnd.mat';
for i=1:length(fishlist)
    fno=[fishlist(i).name(1:end-4) of];
    load(fno)
    fishlist(i).ptype=ptype;
    fishlist(i).strens=strens;
    if(isequal(fishlist(i).name(end-4),'V'))
        fishlist(i).VorDA=1;
    elseif(isequal(fishlist(i).name(end-5:end-4),'DA'))
        fishlist(i).VorDA=2;
    else
        fishlist(i).VorDA=0;
        fishlist(i).name
    end

    fishlist(i).mclass=[NaN;NaN];
    fishlist(i).class=[NaN];
    if(ptype==3)
        fishlist(i).mclass=c([strens(1),strens(2)+3])';
    elseif(ismember(ptype,1:2))
        fishlist(i).class=c(strens+3*(ptype-1));
    else
        [ptype strens]
    end
end
ty=[fishlist.fishtype];
dav=[fishlist.VorDA];
cl=[fishlist.class];
m=[fishlist.mclass];
Fs=[];  
% order is dmso v then da then smif v then da
for i=1:2
    for j=1:2
Fs=[Fs;Frequencies(cl((ty==i)&(dav==j)),[-3:-1 1:3])+ ...
    0.5*(Frequencies(m(1,(ty==i)&(dav==j)),[-3:-1 1:3])+...
    Frequencies(m(2,(ty==i)&(dav==j)),[-3:-1 1:3]))];
    end
end
c=cd;
c=c(end-4:end);
strs={[c 'DMSO V'];[c 'DMSO DA'];[c 'SMIFH2 V'];[c 'SMIFH2 DA']};
for i=1:4
    subplot(2,2,i)
    bar([-3:-1 1:3],100*Fs(i,:)/sum(Fs(i,:)))
    title(strs(i))
    npat=sum(Fs(i,:));
    out(i,:)=[npat Fs(i,:) round(100*Fs(i,:)/npat)];
end
save([of(1:end-4) 'All.mat'])
disp(out)

function ClassifyPatchesRandomTiff(flist,fn_starts,opt)

% get a lits of all the fish and a list of all the different fish
[fishlist,fishnums,fishfreqs]=DivideFilesIntoFish(flist,fn_starts);

% now get the maxes and mins for each fish then thresholds for each fish
np=length(fishlist);
fishlist=fishlist(randperm(np));
cstrs={'unclassified';'active';'inhibited';'mixed';...
    'empty';'unsure'};
cols=['w--';'r--';'y--';'c--';'k--';'g--'];

ptypes=zeros(1,np);
for i=1:length(fishlist)
    fno=[fishlist(i).name(1:end-4) 'HandClassRnd.mat'];
    if(isfile(fno))
        load(fno)
        ptypes(i)=ptype;
    end
end
i=find(ptypes==0,1);
if(isempty(i))
    i=1;
end
while 1
    fno=[fishlist(i).name(1:end-4) 'HandClassRnd.mat'];
    % get the max and min for each fish
    maxf=[fishlist(i).fstart '_Maxes.mat'];
    load(maxf)
    if(isfile(fno))
        load(fno)
        ptypes(i)=ptype;
    else
        ptype=0;
        strens=0;
    end
    im=imread(fishlist(i).name);
    imagesc(im);
    axis equal;
    axis tight
    
    while 1
        % set the string and color type from current classification
        if(ismember(ptype,1:3))
            str=[char(cstrs(ptype+1)) ' strength ' p_str];
        else
            str=char(cstrs(ptype+1));
        end
        col=cols(ptype+1,1);
        if(sum(ptypes==0)==0)
            alldone=1;
            title(['ALL PATCHES CLASSIFIED: patch ' int2str(i) '/' int2str(np)],'Color','r');
        else
            alldone=0;
            title(['patch ' int2str(i) '/' int2str(np)],'Color',col);
        end
        xlabel(str,'Color',col);

        % classify
        disp(' ')
        disp(['currently ' str '; Enter: '])
        disp('1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure;')
        inp=input('-1 end classifying; return done; 0 go back one:  ');
        if(isempty(inp))
            break;
        elseif(isequal(inp,-1))
            if(alldone)
                return
            else
                disp('not all patches classified yet; ctrl c to quit')
            end;
            break;
        elseif(ismember(inp,[1:5]))
            ptype=inp;
            ptypes(i)=inp;
            if(ismember(inp,1:2))
                tempr=0;
                while(~ismember(tempr,1:3))
                    tempr=input('enter strength, 1=high, 2=med,  3=low:  ');
                end
                strens=tempr;
            elseif(inp==3)
                tempr=0;
                while(~ismember(tempr,1:3))
                    tempr=input('enter active strength, 1=high, 2=med,  3=low:  ');
                end
                strens(1)=tempr;
                tempr=0;
                while(~ismember(tempr,1:3))
                    tempr=input('enter inhibited strength, 1=high, 2=med,  3=low:  ');
                end
                strens(2)=tempr;
            else
                strens=0;
            end
            p_str=num2str(strens);
            save(fno,'ptype','strens','p_str');
        elseif(isequal(inp,0))
            i=i-2;
            break
        end
    end

    %move round 1
    i=mod(i+1,np);
    if(i==0)
        i=np; 
    end;
end
            


function ShowClassifyTiff(opt)
strs={'dens small';'dens lines';'dens bigs';'m wigg big';...
    'm ecc big';'m area big';'max area big';'sum area big';...
    'mean green';'% over thresh';'m area all';'#lines';'#big';'#med';...
    'all big';'big*wigg';'wigg nz';'ecc nz';...
    'class';'# patches'};

if(opt==1)     % this is the file for object thresholds based on std filter picking
    endbit='_StdThreshV3.mat';
elseif(opt==2)    % this is the file for object threshold based on the Image
    endbit='_StdThreshImage.mat';
end
outf=['AutoClassify' endbit];
load(outf)
vs=GetVsForClustering(dat);
% these are the things that I'm going to plot
i_pl=[13 14 4 5];% 4 17 5 18 15 16];
i1=[dat.fishtype]==1;
i2=[dat.fishtype]==2;
for i=1:length(i_pl)
    v1=vs(i1,i_pl(i));
    me(i,1)=mean(v1);
    s(i,1)=std(v1);
    v2=vs(i2,i_pl(i));
    me(i,2)=mean(v2);
    s(i,2)=std(v2);
    figure(1)
    subplot(2,2,i)
    BarErrorBarTiff(1:2,me(i,:)',s(i,:)');
    title(char(strs(i_pl(i))))
    SetXLabs(gca,{'DMSO';'SMIFH2'});

    figure(2)
    subplot(2,2,i)
    [y1,x1]=hist(v1,10);
    [y2,x2]=hist(v2,10);
    plot(x1,y1,'k',x2,y2,'r:')
    title(char(strs(i_pl(i))))
    legend('DMSO','SMIFH2');
end


function PickThreshes(flist,fn_starts,opt)

% get a lits of all the fish and a list of all the different fish
[fishlist,fishnums,fishfreqs]=DivideFilesIntoFish(flist,fn_starts);
disp(['there should be ' int2str(sum(fishfreqs)) ' samples from ' int2str(length(fishnums)) ...
    ' fish with numbers/frequencies:' ])
disp([int2str([fishnums;fishfreqs])])
disp(['From ' int2str(length(flist)) ' files'])
% WriteFileOnScreen(flist,2)

% % get the start of the filename
% fn=flist(1).name;
% s=findstr(' ',fn);
% fbit=fn((s(end)+1):(end-4));
% % get maxes and mins across whole data set
% GetMaxMin(flist,fbit)

% now get the maxes and mins for each fish then thresholds for each fish
ns=[fishlist.fishnum];
rndfishnums=fishnums(randperm(length(fishnums)))
sThresh=-1;
for i=rndfishnums
    is=find(i==ns);
    % get the max and min for each fish
    [maxf,mamax,mimin]=GetMaxMin(fishlist(is),fishlist(is(1)).fstart);

    if(opt==2)
        fno2=[fishlist(is(1)).fstart '_StdThreshImage.mat'];
    else
        fno2=[fishlist(is(1)).fstart '_StdThreshV3.mat'];
    end

    % now get thresholds for each fish
    if(isfile(fno2))
        load(fno2)
    end
    oldt=sThresh;
    %     oldt=max(1,round(var*rand(1)-0.5*var)+sThresh);
    %     [sthresh]=stdThreshMultPlots(flist,oldt,numpatches,[mimin,mamax],opt);
    [sThresh]=stdThreshSingPatch(fishlist(is),oldt,[mimin,mamax],opt);
    save(fno2,'sThresh');

    % 1 is for std filter, 2 the image
    % this is kind of redundant but is needed for individual thresholds
    %     GetStdThresh(flist,fbit,1)
    %    GetStdThresh(flist,flist(is(1)).fstart,2)
end
AutoClassifyTiff(flist,fn_starts,opt);

function[fishlist,fishnums,fishfreqs]=DivideFilesIntoFish(flist,fn_starts)
for i=1:length(flist)
    fishlist(i).name=flist(i).name;
    s=char(fn_starts(1));
    k=findstr(s,fishlist(i).name);
    nadd=1;
    if(~isempty(k))
        sp=k+length(s);
        st=fishlist(i).name(sp:end);
        [ns,inds]=ExtractNumbers(st);
        fishlist(i).fishnum=ns(1)+(nadd-1)*1e3;
        fishlist(i).fstart=fishlist(i).name(1:(sp+inds(1,2)-1));
    else
        nadd=nadd+1;
        s=char(fn_starts(2));
        k=findstr(s,fishlist(i).name);
        sp=k+length(s);
        st=fishlist(i).name(sp:end);
        [ns,inds]=ExtractNumbers(st);
        fishlist(i).fishnum=ns(1)+(nadd-1)*1e3;
        fishlist(i).fstart=fishlist(i).name(1:(sp+inds(1,2)-1));
    end
    fishlist(i).fishtype=nadd;
end
fishnums=unique([fishlist.fishnum]);
fishfreqs=hist([fishlist.fishnum],fishnums);
% for i=1:length(fishnums)
%     fishfreqs(i)=sum([fishlist.fishnum]==fishnums(i));
% end

function AutoClassifyTiff(flist,fn_starts,opt)

% thfs=[1.25 1.5 2 2.5 3 4];
% sfs=[1.5:0.2:2.5];

% these are different options to the lsm version
if(opt==1)
    % this is the file for object thresholds based on std filter picking
    endbit='_StdThreshV3.mat';
elseif(opt==2)
    % this is the file for object threshold based on the Image
    endbit='_StdThreshImage.mat';
elseif(opt==3)
    % not used
    sfs=[1000:500:3000];
end

[fishlist,fishnums]=DivideFilesIntoFish(flist,fn_starts);

outf=['AutoClassify' endbit];
outftxt=['AutoClassify' endbit(1:end-4) '.csv'];
nh=ones(3);
dat=[];

ns=[fishlist.fishnum];
for i=fishnums
    flist=fishlist(find(i==ns));
    fno=[fishlist(1).fstart endbit];
    load(fno)
    % now classify each fish
    for j=1:length(flist)
        ims(j).im=imread(flist(j).name);
        if(opt==1)
            im=Mystdfilt(ims(i).im,nh);
        else
            im=ims(j).im;
        end
        t_im=double(im>sThresh);
        v=t_im(:);
        da=AnalysePatchIm(t_im,im);
        da.area=length(v);
        da.nover=length(v(v>0));
        da.pcs=round(100*da.nover/da.area);
        da.fishnum=i;
        da.name=flist(j).name;
        da.fstart=flist(j).fstart;
        da.fishnum=flist(j).fishnum;
        da.fishtype=flist(j).fishtype;
        da.whichfish=j;
        da.fnThresh=fno;
        da.th=sThresh;
%         da.th_im=t_im;
%         da.im=im;
        dat=[dat da];
    end
    save(outf,'dat')%,'goods','patches','goods')
end
ShowClassifyTiff(opt)

% this get's the objects and various properties. Not entirely sure im is
% needed but it was in AutoClassifyLSM.m so I've kept it in
function[out]=AnalysePatchIm(threshim,im)

threshB=50;
threshM=10;

v_im=threshim(:);
% get objects based on thresholds or std filter
[L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(threshim,im,threshB);
% out.s_lev=s_lev;
% out.t1=t1;
% out.sf=sf;
out.g=MyPrctile(v_im(v_im>0),[50 25 75])';
out.n_s=num_s;
out.L_s=L_s;
out.isline_s=isline_s;
out.bigs_s=find(ar_s>threshB);
out.nbig_s=sum(ar_s>threshB);
out.nline_s=length(isline_s);
out.nmeds_s=sum(ar_s>threshM);
out.meds_s=find(ar_s>threshM);
out.ecc_s=ecc_s;
[out.wig_s,out.l_s,out.wid_s]=objWiggliness(objIm_s,L_s,out.bigs_s);

function[s,L,num,ar,isline,lineim,ecc]=GetObjects(t2im,im,threshB)
[L,num] = bwlabeln(t2im);
s=regionprops(L,im,'Area','Eccentricity',...
    'MajorAxisLength','MinorAxisLength',...
    'Perimeter','MeanIntensity','Solidity','Orientation');
minax=[s.MinorAxisLength];
majax=[s.MajorAxisLength];
meanint=[s.MeanIntensity];
ecc=[s.MajorAxisLength]./minax;
per=2*([s.MajorAxisLength]+minax);
ar=[s.Area];
arovlength=ar./majax;
sol=[s.Solidity];

isline=find((ecc>3)&([s.Area]>threshB));
lineim=zeros(size(im));
for j=1:length(isline)
    lineim=lineim+double(L==isline(j))*j;
end

function[w,l,mw]=objWiggliness(im,S,is)
w=[];
l=[];
mw=[];
for i=1:length(is)
    num=is(i);
    nim=(im==num);
    [w(i),l(i),mw(i)]=Wiggliness(nim,S(num).Orientation);
end

function[w,l,mw] = Wiggliness(im,ang)
newim=imrotate(im,90-ang);
rs=sum(newim,2);
r1=find(rs,1,'first');
r2=find(rs(r1:end),1,'last')+r1-1;
rows=r1:r2;
for i=1:length(rows)
    wid(i)=sum(newim(rows(i),:));
end
w=iqr(wid);
l=std(wid);%r2-r1+1;
mw=median(wid);


function[vs,clasl]=GetVsForClustering(da)
ar=[da.area];%1;%
[o,eccObj,wigg,nlines,mwObj,meObj,maObj,maxaObj,saObj,mallObj]=text_getbigs(da);
% [o,eccObj,wigg,nlines,mwObj,meObj]=text_getbigs(da);
dls=1e4*nlines./ar;
saObj=100*saObj./ar;
nmed=[da.nmeds_s]-[da.nbig_s];
nbig=[da.nbig_s]-nlines;
dmed=1e4*([da.nmeds_s]-[da.nbig_s])./ar;
dbigo=1e4*([da.nbig_s]-nlines)./ar;
pcover=[da.pcs]';
g=[da.g];
mg=g(1,:)';
vs=[dmed' dls' dbigo' mwObj' meObj' maObj' maxaObj' saObj' mg pcover mallObj' nlines' nbig' nmed'];
% vs=[dmed' dls' dbigo' mwObj' meObj'];
clasl=[];%[da.class];


function[o,eccObj,wigg,nlines,mwObj,meObj,maObj,maxObj,saObj,mallObj]=text_getbigs(da)
wigg=[da.wig_s];
[y,x]=hist(wigg,0:15);
o.x1=x;
o.y1=y/sum(y);

eccObj=[];solObj=[];%arObj=[];
for i=1:length(da)
    b=[da(i).bigs_s];
    eccb=[da(i).ecc_s(b)];
    nlines(i)=sum(eccb>=2);
    eccObj=[eccObj eccb];
    solObj=[solObj [da(i).L_s(b).Solidity]];

%     arObj=[arObj [da(i).L_s(b).Area]];
    arObj=[da(i).L_s(b).Area];
    a_all=[da(i).L_s(b).Area];
    saObj(i)=sum([da(i).L_s(b).Area]);
    if(isempty(a_all))
        mallObj(i)=0;
    else
        mallObj(i)=mean(a_all);
    end
   
    if(isempty(b))
        mwObj(i)=0;
        meObj(i)=0;
        maObj(i)=0;
        maxObj(i)=0;
    else
        mwObj(i)=mean([da(i).wig_s]);
        meObj(i)=mean(eccb);
        maObj(i)=mean(arObj);
        maxObj(i)=max(arObj);
    end
end


% this does the plotting one patch at a time
function[thresh]=stdThreshSingPatch(flist,thresh,imax,opt)

% get patches
rp=randperm(length(flist));
flist=flist(rp);
sp=1;
nh=ones(3);

v=[];
sv=[];

% this gets maxes and mins across the fish
for i=1:length(flist)
    ims(i).im=imread(flist(i).name);
    ims(i).stdim=Mystdfilt(ims(i).im,nh);
    v=[v;ims(i).im(:)];
    sv=[sv;ims(i).stdim(:)];
end

% comment this out to show relative to all the patches
% not just the fish; slight reducndacney here as this is passsed in but
% it adds elxibility if I want to use a sacling across all fish
imax=[min(v) max(v)];
stdax=[min(sv) max(sv)];
if(opt==2)
    lims=imax;
    tadd=100;
else
    lims=stdax;
    tadd=20;
end

% auto threshold
if((nargin<2)||thresh<0)
    if(opt==2)
        thresh=1.5*median(v);
    else
        thresh=1.5*median(sv);
    end
end

threshB=50;
threshM=10;

% start with first figure
figure(1)
clf
i=1;
while 1

    if(opt==2)
        % do the threshold on the standard image
        s2im=double(ims(i).im>thresh);
    else
        s2im=double(ims(i).stdim>thresh);
    end
    % this is old and only gives a rough idea of what's going on
    %     s2im=double(sim_mask>(sf*s_lev));
    %     [L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(s2im,im,threshB);
    [L,num] = bwlabeln(s2im);
    s=regionprops(L,'Area');%,'Perimeter');
    ar=[s.Area];
    ms=find((ar>=threshM));%&(ar<threshB));
    bs=find(ar>=threshB);
    numbig=length(bs);
    numsmall=length(ms)-numbig;
    bwm = ismember(L,ms);
    bwb = ismember(L,bs);
    tpl=s2im+bwm+bwb;

    stdThreshPlotPatchesSing(ims,i,tpl,L,imax,stdax,opt)
    disp([' threshold, currently ' int2str(thresh)]);
    %         text(-800,-150,'up/down arrow to change threshold; return end' ...
    %         ,'FontSize',14);
    subplot(2,2,2)
    xlabel([int2str(numbig) ' big objects; ' int2str(numsmall) ' mediums']);
    subplot(2,2,4)
    xlabel('up/down arrow to change threshold; n next patch; return end');

    [x,y,b]=ginput(1);

    %     inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
    if(isempty(x))
        break;
    elseif(b==30)
        %         Increase threshold
        thresh=min(thresh+tadd,lims(2));
    elseif(b==31)
        %         decrease threshold;
        thresh=max(lims(1),thresh-tadd);
    elseif(b==110)
        % get a new images
        i=i+1;
        if(i>length(flist))
            i=1;
        end
    end
end

function stdThreshPlotPatchesSing(ims,i,tpl,L,imax,stdax,opt)

if(opt==2)
    s1='; THRESHOLDING THIS';
    s2='';
else
    s2='; THRESHOLDING THIS';
    s1='';
end

subplot(2,2,1)
imagesc(ims(i).im)
axis equal; axis tight
caxis(imax)
title(['original image ' int2str(i) '/' int2str(length(ims)) s1])

subplot(2,2,3)
imagesc(ims(i).stdim)
axis equal; axis tight;
caxis(stdax)
title(['std filtered image' s2])

subplot(2,2,2)
imagesc(tpl);caxis([0 3])
axis equal; axis tight;
title('objects (blue), smalls (orange) bigs (red)')

subplot(2,2,4)
imagesc(L)
axis equal; axis tight;
title('all objects, 1 colour per object')

% currently this is defunct
function GetStdThresh(fns,fbit,opt)
numpatches=3;

maxf=[fbit '_Maxes.mat'];
if(opt==2)
    fno2=[fbit '_StdThreshImage.mat'];
else
    fno2=[fbit '_StdThreshV3.mat'];
end

nl=1;
if(isfile(fno2))
    load(fno2)
    oldthresh=median(sThreshes);
else
    sThreshes=NaN*ones(1,nl);
    oldthresh=-1;
end
var=100;

if 1 %(isfile(maxf))
    load(maxf);
else
    mamax=256^2-1;
end
for sl=1:nl
    if 0%(exist('sthresh'))
        oldt=sthresh;
    elseif(opt==1)
        oldt=oldthresh;
    else
        oldt=max(1,round(var*rand(1)-0.5*var)+oldthresh);
    end
    %     [sthresh]=stdThreshMultPlots(flist,oldt,numpatches,[mimin,mamax],opt);
    [sthresh]=stdThreshSingPatch(flist,oldt,[mimin,mamax],opt)
    sThreshes(sl)=sthresh;
    oldthresh=sthresh;
    %     save(fno3,'sthresh','-append');
    save(fno2,'sThreshes');
end


% this does roughly the same as above but shows multiple patches
function[thresh]=stdThreshMultPlots(flist,thresh,numpatches,imax,opt)

% get patches
rp=randperm(length(flist));
sp=1;
nh=ones(3);

imnums=rp(sp:(sp+numpatches-1));
v=[];
for i=1:length(imnums)
    ims(i).im=imread(flist(imnums(i)).name);
    ims(i).stdim=Mystdfilt(ims(i).im,nh);
    if(opt==2)
        v=[v;ims(i).im(:)];
    else
        v=[v;ims(i).stdim(:)];
    end
end
stdax=[min(v) max(v)];
disp('this does images scaling across patches and might need changing')

if((nargin<2)||thresh<0)
    thresh=2.5*median(v);
end

threshB=50;
threshM=10;
if(opt==2)
    tadd=100;
    m=2;
else
    tadd=20;
    m=3;
end

% plot the patches
figure(1)
clf
stdThreshPlotPatches(ims,numpatches,m,imax,stdax,opt)

while 1

    for i=1:length(ims)
        if(opt==2)
            % do the threshold on the standard image
            s2im=double(ims(i).im>thresh);
        else
            s2im=double(ims(i).stdim>thresh);
        end
        %     s2im=double(sim_mask>(sf*s_lev));
        %     [L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(s2im,im,threshB);
        [L,num] = bwlabeln(s2im);
        s=regionprops(L,'Area');%,'Perimeter');
        ar=[s.Area];
        ms=find((ar>=threshM));%&(ar<threshB));
        bs=find(ar>=threshB);
        bwm = ismember(L,ms);
        bwb = ismember(L,bs);
        tpl=s2im+bwm+bwb;

        subplot(numpatches,m,m*(i-1)+2)
        %         imagesc(L)
        imagesc(tpl);caxis([0 3])
        axis equal; axis tight;
    end
    subplot(numpatches,m,2);title('objects');
    disp([' threshold, currently ' int2str(thresh)]);
    %         text(-800,-150,'up/down arrow to change threshold; return end' ...
    %         ,'FontSize',14);
    subplot(numpatches,m,numpatches*(m-1)+2);
    xlabel('up/down arrow to change threshold; n next patch; return end');
    [x,y,b]=ginput(1);

    %     inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
    if(isempty(x))
        break;
    elseif(b==30)
        %         Increase threshold
        thresh=min(thresh+tadd,stdax(2));
    elseif(b==31)
        %         decrease threshold;
        thresh=max(stdax(1),thresh-tadd);
    elseif(b==110)
        % get 3 new images
        sp=sp+numpatches;
        if((sp+numpatches-1)>length(rp))
            sp=1;
        end
        imnums=rp(sp:(sp+numpatches-1));
        v=[];
        for i=1:length(imnums)
            ims(i).im=imread(flist(imnums(i)).name);
            ims(i).stdim=Mystdfilt(ims(i).im,nh);
            v=[v;ims(i).stdim(:)];
        end
        stdax=[min(v) max(v)];
        % plot the new images
        stdThreshPlotPatches(ims,numpatches,m,imax,stdax,opt)
    end
end

function stdThreshPlotPatches(ims,numpatches,m,imax,stdax,opt)
for i=1:length(ims)
    subplot(numpatches,m,m*(i-1)+1)
    imagesc(ims(i).im)
    axis equal; axis tight
    caxis(imax)

    if(opt~=2)
        subplot(numpatches,m,m*(i-1)+3)
        imagesc(ims(i).stdim)
        axis equal; axis tight;
        caxis(stdax)
    end
end
subplot(numpatches,m,1);title('original');
if(opt~=2)
    subplot(numpatches,m,3);title('std filtered');
end

function[outf,mamax,mimin]=GetMaxMin(flist,fbit)

outf=[fbit '_Maxes.mat'];
for i=1:length(flist)
    im=imread(flist(i).name);
    v=im(:);
    maxes(i)=max(v);
    mins(i)=min(v);
    si(i,:)=size(im);
    ar(i)=length(v);
end
mamax=max(maxes);
mimin=min(mins);
save(outf,'fbit','maxes','mamax','mins','mimin','ar','si','flist');


function SetXLabs(AxHdl,TickLabs)
TickPos=get(AxHdl,'XTick');
set(AxHdl,'XTick',TickPos,'XTickLabel',TickLabs);

function[h]=BarErrorBarTiff(X,Y,E,BarWidth,ErrWidth,col)
if(nargin<6) col='b' ; end
if((nargin<5)||isempty(ErrWidth)) ErrWidth=0 ; end
if((nargin<4)||isempty(BarWidth)) BarWidth=0.8 ; end
if(isempty(X)) X=1:length(Y); end
ph=bar(X,Y,BarWidth);
h=gca;
YUp=Y+E;
hold on;
for i=1:length(ph)
    x=get(get(ph(i),'Children'),'XData');
    if(size(col,1)>1)
        set(ph(i),'FaceColor',col(2,:));
    end
    xs=mean(x);%([1 3],:));
    if(ErrWidth==0) Wid=0.33*mean(x(3,:)-x(1,:));
    else Wid=0.5*ErrWidth;
    end
    for j=1:length(xs)
        % vertical lines
        plot([xs(j) xs(j)],[Y(j,i) YUp(j,i)],col(1,:));
        % horizontal lines
        plot([xs(j)-Wid xs(j)+Wid],[YUp(j,i) YUp(j,i)],col(1,:));
    end
end
hold off