function TextureAnalysis

lsmlist={'DAPT7.lsm';'DAPT8.lsm';'DAPT_5_6.lsm';'DMSO_5.lsm';'DMSO_6.lsm';...
    'DMSO_7_8bit.lsm';'dapt_1.lsm';'dapt_2.lsm';'dapt_3a.lsm';'dapt_4a.lsm';...
    'dmso_1.lsm';'dmso_2.lsm';'dmso_3a.lsm';'dmso_4a.lsm'} ;

lsmlist2={'11_C_63X_1.lsm';'11_C_63X_2.lsm';'11_C_63X_3.lsm';...
    '63X_16.lsm';'63X_17.lsm';'63X_18.lsm';'B322_L5_1_C_20X_2.lsm'} ;

% lsmlist3={'Image1_dll4coloc.lsm';'Image2_dll4coloc.lsm';
%     'Image3_dll4coloc.lsm';'Image4_dll4coloc.lsm';'Image5_dll4coloc.lsm';...
%     'DMSO_63X_3.lsm';'DMSO_63X_4.lsm';'DMSO_63X_5.lsm';...
%     'DMSO_63X_6.lsm';'DMSO_63X_7.lsm';'DMSO_63X_8.lsm'} ;

% in the coloc ones, 2 was a copy of 1 and 3 was bad
lsmlist3={'Image1_dll4coloc.lsm';'Image4_dll4coloc.lsm';'Image5_dll4coloc.lsm';...
    'DMSO_63X_3.lsm';'DMSO_63X_4.lsm';'DMSO_63X_5.lsm';...
    'DMSO_63X_6.lsm';'DMSO_63X_7.lsm';'DMSO_63X_8.lsm'} ;

lsmlist4={'Claudio_63X_1.lsm';'Claudio_63X_2.lsm';'Claudio_63X_3.lsm';...
    'Eleonora_63X_1.lsm';'Eleonora_63X_2.lsm';...
    'Eleonora_63X_3.lsm';'Eleonora_63X_4.lsm';...
    'P22_CAF_63X_1.lsm';'P22_CAF_63X_2.lsm';'P22_CAF_63X_3.lsm'};

lsmlist5={'Claudio_63X_1.lsm';'Claudio_63X_2.lsm';'Claudio_63X_3.lsm';...
    '11_C_63X_1.lsm';'11_C_63X_2.lsm';'11_C_63X_3.lsm'};

% KATE TO DO: enter the names of lsms you want to process in here
lsmlist6={'1_front.lsm';'1_internal.lsm';...
    '2_front.lsm';'2_internal.lsm'};

% % this is what I run to get masks or results. You'll run it ot get masks
% % first argument is the option which sets which channels to read from
% % in this case option is 5, 
% % next is the file list, then which files from that list
% % comment this out once masks generated
% TexturePatches(5,lsmlist6,1)  
% 
% % % Next run this to classify them
% % % 1st argument option, 2nd lsmlist, 3rd which files to do
% ClassifyLSMs(5,lsmlist6,1)     % option 5 does new classification
% ClassifyLSMs(2,lsmlist4,[1:3 8:10])     % option 2 does old classification

% % run this to get the delta 4
% % change line 2064 (or thereabouts) to set the red channel correctly 
% TexturePatchesRed(5,lsmlist6,1)

% TexturePatches(4,lsmlist3,1:9)  % colocalised 
% TexturePatches(1,lsmlist,[8:14])

% ClassifyLSMs(2,lsmlist4,[1:3 8:10])     % this does classification

% ClassifyLSMs(20,lsmlist3,1)     % this does picking patches

% to run the automatic classification, one first needs to have classified
% the data by hand. These data should be in Classified/ ... TypeV2.mat files
% see line: 2613 to change this in function TextureSlices
% 
% this means that a background threshold will have been picked but one also
% needs a threshold for objects based on the s.d. level. This is got via
% PickThreshes with the data stored in _StdThreshV3.mat(in ftn GetStdThresh)
% PickThreshes calls GetStdThresh: option 1 does red channel, else standard
%
% to avoid overwriting, when generated I put this in folder HandThresholds
% see line 2565 of TextureSlices which itself is called from
% PickThreshes([1 4 5],lsmlist6)     % this picks object thresholds
% PickThreshes([1 4 5],lsmlist3,1)     % this picks red objet thresholds  


% % dwork
% % cd CRUK\WideField\Zoomed2\

% this bit outputs the results in various forms
ShowClassifyPatches(lsmlist,1:14);%[2:3 7:14]) % This shows the difference between dmso dapt
%  ShowClassifyPatches(lsmlist3,[1:9],3,'coloc');%[2:3 7:14])  % results for just dmso. 3=mixed is separate
%  ShowClassifyPatches(lsmlist3,[1:9],2,'coloc');%[2:3 7:14])  % results for just dmso. 3=mixed included
% [m1,s1]=ShowClassifyPatches(lsmlist2,1:3,2);%[2:3 7:14])  % this shows the difference when just dmso
% [m2,s2]=ShowClassifyPatches(lsmlist4,1:3,2);%[2:3 7:14])  % this shows the difference when just dmso
% [m3,s3]=ShowClassifyPatches(lsmlist4,8:10,2);%[2:3 7:14])  % this shows the difference when just dmso
% ShowClassifyPatches(lsmlist5,1:6);%[2:3 7:14])  
% TextureResults(1:14,lsmlist)
% FileThreshes

% this is for the level of red in files
% PlotAllRedData(lsmlist3,1:9)
% tempSmallFiles(1:14,lsmlist)

% this does the automatic results stuff
% TextureResultsHand(15,lsmlist)
% TextureResultsHand(1:14,lsmlist)
% ClusterAndCheckData

% % plot stuff
% errorbar(1:6,m2,s2,'k')
% hold on;
% errorbar([1:6]+0.05,m1,s1,'k:')
% errorbar([1:6]-0.05,m3,s3,'k--')
% astrall={'strong';'medium';'weak';'weak';'medium';'strong'};
% SetXTicks(gca,[],[],[],1:6,astrall)
% Setbox
% axis tight
% hold off
% BarErrorBar(1:6,[m2;m1;m3]',[s2;s1;s3]',[],[],'k')
% mClaud=m2;sClaud=s2;mP22=m3;sP22=s3;m11_C=m1;s11_C=s1;
% BarErrorBar(1:6,[mClaud;m11_C;mP22]',[sClaud;s11_C;sP22]',[],[],'k')
% colormap gray
% astrall={'strong';'medium';'weak';'weak';'medium';'strong'};
% SetXTicks(gca,[],[],[],1:6,astrall)
% Setbox
% ylim([0 70])

return

function GetDataToCluster(inds,lsmlist)
clas=[-3:-1 1:6 0];
allvs=[];allcs=[];
indsclas=1:10;
for k=inds
    fn=char(lsmlist(k));
    load([fn(1:end-4) 'SliceDataSF_HandSmall.mat'])

    [vs,clasl]=GetVsForClustering(dat);
    goods=ismember(clasl,clas(indsclas));
    clasl=clasl(goods)';
    vs=vs(goods,:);
    if(size(vs,1)~=length(clasl))
        [a,b]=GetVsForClustering(dat);
        keyboard
    end

    % get an estimate of centres
    [cs,ncla,empts]=GetCsForClustering(vs,clasl,clas,indsclas);
    allvs=[allvs;vs];
    allcs=[allcs;clasl];
    allncla(k,:)=ncla;
    nd(k).ncla=ncla;
    nd(k).cs=cs;
    nd(k).nsamp=sum(ncla);
    nd(k).vs=vs;
    nd(k).clasl=clasl';
end
sncla=sum(allncla,1);
save(['ClusterSliceDataSF_HandResAutoW0.mat'])


function TextureResultsHand(indsi,lsmlist)

% this command basically uses the list of lsm names to make the data file
% ClusterSliceDataSF_HandResAutoW0 which I'm sending you
% GetDataToCluster(1:14,lsmlist)

% comps=[-3:-1 -3:-1 3:-1:1 -1 1;3:-1:1 6:-1:4 6:-1:4 0 0];
clas=[-3:-1 1:6 0];
cst=['m.';'b.';'c.';'r.';'g.';'k.';'..';'..';'..';'y.'];
indsclas=1:10;

% this is the data file to load. It's hard coded but obviously you could
% adapt this
load ClusterSliceDataSF_HandResAutoW0

% indsi is the indices of the lsm files that were used to generate the data
% this allows you to look at the data per lsm file.
% however in the first instance, I would use all the data together so we
% set indsi to a 'flag' value
indsi=15;
for i=indsi
    % legacy stuff
%     fn=char(lsmlist(k));
%     load([fn(1:end-4) 'SliceDataSF_HandSmall.mat'])
% 
%     [vs,clasl]=GetVsForClustering(dat);
%     clasl=clasl(ismember(clasl,clas(indsclas)))';
% 
%     % get an estimate of centres
%     [cs,ncla,empts]=GetCsForClustering(vs,clasl,clas,indsclas);

    % if i is 15, ot does all the data together 
    if(i<15)
        vs=nd(i).vs;
        cs=nd(i).cs;
        ncla=nd(i).ncla;
        str='subplot(7,2,i)';
    else
        vs=allvs;%(:,1:5);
        [csall,ncla,empts]=GetCsForClustering(allvs,allcs,clas,indsclas);
        cs=csall;%(:,1:5);
        str='subplot(1,1,1)';
    end

%     nzs=sum(vs(:,1:3),2)~=0;
%     nzcla=allcs(nzs);
%     vs=vs(nzs,:);
    
    
    % pre-process data
    [pv,ps]=mapstd(vs');
    pv=pv';
    pcs=mapstd('apply',csall',ps)';
    
    % eyeball data
    str='subplot(5,1,pl)';
    str='subplot(4,4,pl)';
    js=[1:6 10];
    for j=js
        is=(allcs==clas(j));
        s(j,:)=std(vs(is,:));
        mv(j,:)=mean(vs(is,:),1);
        medv(j,:)=median(vs(is,:),1);
        iqv(j,:)=iqr(vs(is,:),1);        
        mpv(j,:)=mean(pv(is,:),1);
        spv(j,:)=std(pv(is,:),1);
    end
    for j=js
        is=(allcs==clas(j));
        mv(j,15)=mean(vs(is,12)+vs(is,13),1);
        s(j,15)=std(vs(is,12)+vs(is,13),1);
        mv(j,16)=mean(vs(is,13).*vs(is,4),1);
        s(j,16)=std(vs(is,13).*vs(is,4),1);
    end
    for j=js
        is=((allcs==clas(j))&(sum(vs(:,13:14),2)~=0));
        s(j,17)=std(vs(is,4));
        mv(j,17)=mean(vs(is,4),1);
        s(j,18)=std(vs(is,5));
        mv(j,18)=mean(vs(is,5),1);
    end    

    strs={'dens small';'dens lines';'dens bigs';'m wigg big';...
        'm ecc big';'m area big';'max area big';'sum area big';...
        'mean green';'% over thresh';'m area all';'#lines';'#big';'#med';...
        'all big';'big*wigg';'wigg nz';'ecc nz'};
    itouse=1:16;
    for pl=itouse
        figure(18)
        eval(str); 
        %             bar([1:3 5:7 9],csall(js,pl))
        barerrorbar([1:3 5:7 9],mv(js,pl),s(js,pl));axis tight
        title(char(strs(pl)))
    end
    for pl=1:14
     figure(19)
        eval(str)
        barerrorbar([1:3 5:7 9],mpv(js,pl),spv(js,pl));axis tight
        title(char(strs(pl)))
    end    
    
    % more eyeballing
    for pl=itouse
        figure(20)
        eval(str)
        for j=[1:6 10]
            is=(allcs==clas(j));
            [y,x]=hist(vs(is,pl));
            plot(x,y/sum(y),cst(j,1))
            hold on
        end
        hold off,axis tight
        figure(21)
        eval(str)
        for j=[1:6 10]
            is=(allcs==clas(j));
            [y,x]=hist(pv(is,pl));%,0:.1:1);
            plot(x,y/sum(y),cst(j,1))
            hold on
        end
        hold off,axis tight
    end

figure(5)
    cols=['b';'r';'k';'g';'k';'g'];
    i_pl=[13 14 4 5 4 17 5 18 15 16];
    x=[1:3 5:7 9];
    x=[1:7];
    for j=1:4%length(i_pl)
        subplot(2,2,j)
%         BarErrorBar(x,mv(js,i_pl(j)),s(js,i_pl(j)));axis tight
        errorbar(x,mv(js,i_pl(j)),s(js,i_pl(j)),cols(j));axis tight
        title(char(strs(i_pl(j))))
    end

    i_pl=[1 3 4 5 13 14];
    %     for pl =itouse
        figure(22)
%         subplot(2,2,1)
        for j=[1 6]%6 10]
            is=(allcs==clas(j));
            plot(vs(is,4),vs(is,5),[cst(j,1) 'x'])
            hold on
        end
        hold off
%     end


    % pre-process non-zero
    nzs=sum(vs(:,1:3),2)~=0;
    nzcla=allcs(nzs);
    nzvs=vs(nzs,:);
    [nzcs,nzcla,nzempts]=GetCsForClustering(nzvs,nzcla,clas,1:6);
    [nzpv,nzps]=mapstd(nzvs');
    nzpv=nzpv';
    nzpcs=mapstd('apply',nzcs',nzps)';

    % cluster data
    indsV=1:14;
    [csk,clask,nclak,err]=ClusterKM(pcs,pv,indsV,clas);
    [csk2,clask2,nclak2,err2]=ClusterKM(pcs([1:6 10],:),pv,indsV,clas);
    [csknz,clasknz,nclaknz,errnz]=ClusterKM(nzpcs(1:6,:),nzpv,indsV,clas);
    % remap centres
    csk_or=mapstd('reverse',csk',ps)';
    csk2_or=mapstd('reverse',csk2',ps)';
    csknz_or=mapstd('reverse',csknz',nzps)';
    
    % add mixed to others and get %s
    ncla3=[ncla(1:6)+0.5*ncla([9 8 7 7 8 9]) ncla(10)];
    nclak3=[nclak(1:6)+0.5*nclak([9 8 7 7 8 9]) nclak(10)];
    pc1=100*ncla(1:6)/sum(ncla(1:6));
    pc2=100*ncla3(1:6)/sum(ncla3(1:6));
    pcnz=100*nzcla(1:6)/sum(nzcla(1:6));
    pck1=100*nclak(1:6)/sum(nclak(1:6));
    pck2=100*nclak2(1:6)/sum(nclak2(1:6));
    pck3=100*nclak3(1:6)/sum(nclak3(1:6));
    pcknz=100*nclaknz(1:6)/sum(nclaknz(1:6));
    
    figure(1),    
    eval(str);
    bar(cs'),axis tight
    figure(2),    eval(str);
    bar(csk_or'),axis tight
    figure(3),    eval(str);
    bar(csk2_or'),axis tight
    figure(4), eval(str);bar([ncla' nclak']),axis tight
    figure(5), eval(str);bar([pc1' pck1']),axis tight
    figure(6), eval(str);bar([pc2' pck2' pck3']),axis tight
    figure(7), eval(str);bar([pcnz' pcknz']),axis tight
    
    %     [i1,i2,i3]=deal(1,2,3);
    for j=1:6
        is=(clask==clas(j));
        [y,x]=hist(pv(is,:));
        for pl=1:5
            figure(6+pl)
            plot(x,y(:,pl),cst(j,1))
            hold on
        end
%         plot3(pv(is,i1),pv(is,i2),pv(is,i3),cst(j,:))
%         plot3(ncs(j,i1),ncs(j,i2),ncs(j,i3),[cst(j,1) 'x'])
%         plot3(pcs(j,i1),pcs(j,i2),pcs(j,i3),[cst(j,1) 'o'])
    end

    %     xlabel('# vesicles'),ylabel('# lines'),zlabel('wiggliness of big objects')
end
for pl=1:5
    figure(6+pl)
    hold off
end

function[csk,clask,nclak,err]=ClusterKM(pcs,pv,indsV,clas)
options=[1,0.001,0.001,0,0];
options(14)=0;
[csk,opt,cla_k,elog]=kmeans(pcs(:,indsV),pv(:,indsV),options);
err=elog(end);
clask=zeros(size(cla_k,1));
for j=1:size(cla_k,2)
    is=cla_k(:,j)==1;
    nclak(j)=sum(is);
    clask(is)=clas(j);
end


function[cs,ncla,empts]=GetCsForClustering(vs,clasl,clas,indsclas)
empts=[];
for j=indsclas
    v1=vs(clasl==clas(j),:);
    ncla(j)=size(v1,1);
    if(ncla(j)==0)
        cs(j,:)=zeros(1,size(vs,2));%*NaN;
        empts=[empts j];
    else
        cs(j,:)=mean(v1,1);
%         mwObj=v1(:,4);
%         meObj=v1(:,5);
%         cs(j,:)=[mean(v1(:,[1:3]),1) ...
%             mean(mwObj(~isnan(mwObj))) mean(meObj(~isnan(meObj)))];
    end
end

% get new data vectors
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
clasl=[da.class];



function ClusterAndCheckData(fn)
fn='dmso_4aSliceDataSF_HandResAutoW0';
comps=[-3:-1 -3:-1 3:-1:1 -1 1;3:-1:1 6:-1:4 6:-1:4 0 0];
clas=[-3:-1 1:6 0];
cst=['m.';'b.';'c.';'r.';'g.';'k.'];

load(fn)
% plot all the previous centres
for j=1:6
    d=[];
    for i=1:14
        d=[d;nd(i).ncs(j,:)];
    end
    subplot(6,1,j)
    bar(d'),ylim([-1 1])
end

empts=[];
clear cs
% clasl=[];
% clasl=zeros(size(allvs,1));
for j=1:6%10
    v1=allvs(allcs(:,1)==clas(j),:);
    if(isempty(v1))
        cs(j,:)=zeros(1,5);%*NaN;
        empts=[empts j];
    else
        cs(j,:)=[mean(v1(:,[1:3]),1) ...
            mean(v1(~isnan(v1(:,4)),4)) mean(v1(~isnan(v1(:,5)),5))];
    end
    ncla(j)=size(v1,1);
end
clasl=allcs(:,1);
%     xlabel('# vesicles'),ylabel('# lines'),zlabel('wiggliness of big objects')
options(1:5)=[1,0,0,0,0];
options(14)=1;
inds=[1:5];
[pv,ps]=mapstd(allvs');
pv=pv';
pcs=mapstd('apply',cs',ps)';
[ncs,opt,cla_k,errlog]=kmeans(pcs(:,inds),pv(:,inds),options);

[i1,i2,i3]=deal(1,2,3);
figure(1)%*k+1)
clask=zeros(size(cla_k(:,1)));
for j=1:6%10
    is=cla_k(:,j)==1;
    nclak(j)=sum(is);
    clask(is)=clas(j);
    plot3(pv(is,i1),pv(is,i2),pv(is,i3),cst(j,:))
    plot3(ncs(j,i1),ncs(j,i2),ncs(j,i3),[cst(j,1) 'x'])
    plot3(pcs(j,i1),pcs(j,i2),pcs(j,i3),[cst(j,1) 'o'])
    hold on
end
hold off
for j=1:6
    subplot(6,1,j)
    bar(ncs(j,:)),ylim([-1 1])
end
figure(2)
bar([ncla' nclak'])
clask_dapt=clask(1:2332);
clask_dmso=clask(2333:end);
clasl_dapt=clasl(1:2332);
clasl_dmso=clasl(2333:end);
ndapt=Frequencies(clask_dapt,clas(1:6))/length(clask_dapt);
ndmso=Frequencies(clask_dmso,clas(1:6))/length(clask_dmso);
ldapt=Frequencies(clasl_dapt,clas(1:6))/length(clasl_dapt);
ldmso=Frequencies(clasl_dmso,clas(1:6))/length(clasl_dmso);
figure(3)
subplot(1,1,1),bar([ndapt' ndmso'])
% subplot(2,1,2),bar([ldapt' ldmso'])



function tempSmallFiles(inds,lsmlist)

for k=inds
    fn=char(lsmlist(k));
    load([fn(1:end-4) 'SliceDataSF_Hand.mat'])
    dat=rmfield(dat,'patch');
    dat=rmfield(dat,'p_im');
    dat=rmfield(dat,'m_im');
    dat=rmfield(dat,'fn_mask');
    dat=rmfield(dat,'fn_im');
    save([fn(1:end-4) 'SliceDataSF_HandSmall.mat'],'dat')
end


function TextureResults(inds,lsmlist)

f1=['dapt_1SliceDataSF2_5V3.mat'];
f2=['dapt_2SliceDataSF1_75V3.mat'];
m1=['dmso_1SliceDataSF3_5V3.mat'];
thfs=[1.25 1.5 2 2.5 3 4];
% sfs=[1.5:0.1:2];
sfs=[1.5:0.2:2.5];
thfs=[1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25];
sfs=[2.5:0.5:3.5];
sfs=[1.75 2:.5:4];
sfs=[1000:500:3000];
sfn={'1';'2';'3a';'4a'};
v=4;
dap=[];
for k=[1:7]%[2:6]% 3 5]
    k
    fn=char(lsmlist(k));
    load([fn(1:end-4) 'SliceDataSF_HandSmall.mat'])
    dap=[dap dat];
end
dam=[];
for k=[8:14]%[2:6]% 3 5]
    k
    fn=char(lsmlist(k));
    load([fn(1:end-4) 'SliceDataSF_HandSmall.mat'])
    dam=[dam dat];
end
ResultsSummary(dap,dam,1);

for k=1:6
    j=k;%k;
    %     f1=['dapt_1SliceDataTF' x2str(thfs(k)) 'SF' x2str(sfs(k)) '.mat']
    %     f2=['dmso_1SliceDataTF' x2str(thfs(k)) 'SF' x2str(sfs(k)) 'V2.mat']
    %     f1=['dapt_' char(sfn(j,:)) 'SliceDataSF' x2str(sfs(k)) 'V' int2str(v) '.mat']
    f1=['dapt_' char(sfn(j,:)) 'SliceDataSF_Hand.mat']
    %     f1=['dapt_' char(sfn(k,:)) 'SliceDataSF3_5V3.mat']
    load(f1);
    eval(['dap' int2str(k) '=dat;'])
    dp=dat;
    bps=find([dat.nbig_s]);
    n=k;
    %     f2=['dmso_' char(sfn(j,:)) 'SliceDataSF' x2str(sfs(n)) 'V' int2str(v) '.mat']
    f2=['dmso_' char(sfn(j,:)) 'SliceDataSF_Hand.mat']
    %     f2=['dmso_' char(sfn(k,:)) 'SliceDataSF3_5V3.mat']
    load(f2);
    bms=find([dat.nbig_s]);
    eval(['dam' int2str(n) '=dat;'])
    %     tempfunc(dp,dat,k);
    ResultsSummary(dp,dat,10*k);

end
keyboard
ResultsSummary(dap1(bps),dam1(bms));
ResultsSlice(dap4,8,5,1)

function ClassifyLSMs(opt,lsmlist,inds)

% sfn={'1';'2';'3a';'4a'};
% f1=['dapt_' char(sfn(opt,:)) '.lsm'];
% f2=['dmso_' char(sfn(opt,:)) '.lsm'];
% ClassifyPatches(f2,0)
% ClassifyPatches(f1,0)
% return;
s=dir('*.lsm');
if(nargin<3); inds=1:length(s); end;
% s.name='11_C_63X_2.lsm';
for i=inds
    if(nargin<2)
        fn=s(i).name;
    else
        fn=char(lsmlist(i));
    end
    if(isequal(fn(1:3),'63X'))
        [vecadCh,vessCh]=deal(2,4);
    elseif(isequal(fn(1:3),'11_C'))
        [vecadCh,vessCh]=deal(3,1);
    elseif(isequal(fn(1),'D'))
        [vecadCh,vessCh]=deal(1,1);
    else   % Zoomed2 stuff (dapt vs dmso)
        [vecadCh,vessCh]=deal(1,2);
    end

    if(opt==-1)
        ClassifyPatches(fn,-1);
    elseif(opt==2)
        ClassifyPatches(fn,2);
    elseif(opt==5)
        ClassifyPatchesRandom(fn,2);
    elseif(opt==10)
        PickPatches(fn,-1);
    elseif(opt==20)
        RedCh=2;
        PickPatches(fn,-1,RedCh);
    else
        ClassifyPatches(fn);
    end
end


function FileThreshes
sfn={'1';'2';'3a';'4a'};

for i=[2]
    f1=['dapt_' char(sfn(i,:))];
    fno3=[f1 '_sl1_Mask.mat'];
    load(fno3)
    for sl=1:nl
        %     fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
        clear sthresh mask
        fno3=[f1 '_sl' int2str(sl) '_Mask.mat'];
        load(fno3)
        if(~exist('sthresh'))
            sThreshes(sl)=NaN;
        else
            sThreshes(sl)=sthresh;
        end
    end
    save([f1 'StdThreshV3.mat']);
    f1=['dmso_' char(sfn(i,:)) '.lsm'];
    fno3=[f1 '_sl1_Mask.mat'];
    load(fno3)
    for sl=1:nl
        %     fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
        clear sthresh mask
        fno3=[f1 '_sl' int2str(sl) '_Mask.mat'];
        load(fno3)
        if(~exist('sthresh'))
            sThreshes(sl)=NaN;
        else
            sThreshes(sl)=sthresh;
        end
    end
    save([f1 'StdThThreshV3.mat']);
end

function PickThreshes(inds,lsmlist,opt)
if(nargin<3) opt=0; end;
% sfn={'1';'2';'3a';'4a'};
% f1=['dapt_' char(sfn(opt,:)) '.lsm'];
% f2=['dmso_' char(sfn(opt,:)) '.lsm'];
s=dir('*.lsm');
if(nargin<1); inds=1:length(s); end;
for i=inds
    if(nargin<2)
        f1=s(i).name;
    else
        f1=char(lsmlist(i));
    end
    if(opt==1)
        GetStdThresh(f1,opt);
    else
        GetStdThresh(f1,opt);
    end
    % GetDataStdThresh(f1,1);
end
% GetStdThresh(f1);
% GetStdThresh(f2);
% GetDataStdThresh(f1,1);
% GetDataStdThresh(f2,1);
return
s=dir('*.lsm');
for i=1
    fn=s(i).name;
    if(opt==5)  % vecadretina stuff
        if(isequal(fn(1:3),'63X'))
            [vecadCh,vessCh]=deal(2,4);
        else(isequal(fn(1:3),'11_C'))
            [vecadCh,vessCh]=deal(3,1);
        end
    else   % Zoomed2 stuff (dapt vs dmso)
        [vecadCh,vessCh]=deal(1,2);
    end
    GetDataStdThresh(fn,vecadCh);
    %     GetStdThresh(fn);
end


function GetDataStdThresh(fn,vecadCh)

im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
vals=NaN*zeros(nl*1e5,1);
c=1;
for sl=1:nl
    fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
    clear mask
    fno3=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat']
    load(fno)
    %     patches=TileImage(mask,100,100);
    %     save(fno,'patches','-append');
    if(isequal(mask,-1))
        save(fno3,'mask','nl');
        maxes(sl)=NaN;
        %         save(fno3,'rim','mask','patches','nl');
    else
        hereiam=[ sl nl]
        im=tiffread29(fn,2*sl-1);
        rim=double(cell2mat(im.data(vecadCh)));
        vs=rim(:).*mask(:);
        vs=vs(vs>0);
        l=length(vs);
        if((c+l)>nl*1e5)
            vals=[vals;vs];
        else
            vals(c:c+l-1)=vs;
        end
        c=c+l;
        maxes(sl)=max(vs);
        save(fno3,'rim','mask','patches','nl');
    end
end
mamax=max(maxes);
vals=vals(~isnan(vals));
s=sort(vals);
ind=round(0.9999*length(vals));
mmax=s(ind);
% mmax=MyPrctile(vals,99.99);
save([fn(1:end-4) '_Maxes.mat'],'vecadCh','maxes','mamax','mmax');

function GetStdThresh(fn,opt)

% im=tiffread29(fn,1);
% nl=im(1).lsm.DimensionZ;
% dc=im(1).lsm.DimensionChannels;

rand('twister',sum(100*clock));
numpatches=3;

if(opt==1)
    fno=[fn(1:end-4) '_sl1_MaskRed.mat'];
    fno2=[fn(1:end-4) '_StdThreshV3Red.mat']
    maxf=[fn(1:end-4) '_MaxesRed.mat'];
else
    fno=[fn(1:end-4) '_sl1_Mask.mat'];
    fno2=[fn(1:end-4) '_StdThreshV3.mat'];
    maxf=[fn(1:end-4) '_Maxes.mat'];
end
load(fno)

% if(isfile(fno2))
%     inp=input(['file ' fno2 ' exists; enter 0 to overwrite'])
%     if(~isequal(inp,0))
%         return;
%     end
%     load(fno2)
% else
%     thresh=zeros(1,nl)*NaN;
% end
if(opt==1)
    oldthresh=20;
else
    oldthresh=1e3;
    var=600;
end
if(isfile(fno2))
    load(fno2)
else
    sThreshes=NaN*ones(1,nl);
end

if(isfile(maxf))
    load(maxf);
    maxt=mamax;
else
    maxt=256^2-1;
end
for sl=1:nl
    %     fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
    clear sthresh mask
    if(opt==1)
        fno3=[fn(1:end-4) '_sl' int2str(sl) '_MaskRed.mat']
    else
        fno3=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    end
    load(fno3)
    if(isequal(mask,-1))
        maxes(sl)=NaN;
    else
        x=sum(mask);
        x1=find(x,1);
        x2=find(x,1,'last');
        x=sum(mask,2);
        y1=find(x,1);
        y2=find(x,1,'last');
        axlim=[x1 x2 y1 y2];
        %     figure(fp+ch)
        hereiam=[ sl nl]
        %         im=tiffread29(fn,2*sl-1);
        %         rim=double(cell2mat(im.data(1)));
        if(exist('sthresh'))
            oldt=sthresh;
        elseif(opt==1)
            oldt=oldthresh;
        else
            oldt=max(1,round(var*rand(1)-0.5*var)+oldthresh);
        end
        [sthresh]=stdThresh(rim,oldt,axlim,patches,numpatches,maxt);
        sThreshes(sl)=sthresh;
        oldthresh=sthresh;
        %     save(fno2,'thresh');%,'rim','mask');
        %         save(fno3,'rim','mask','patches');
        %         patches=TileImage(mask,100,100);
        save(fno3,'sthresh','-append');
        %         maxes(sl)=max(rim(:));
        save(fno2,'sThreshes');
    end
end
% save([fn(1:end-4) 'Maxes.mat'],'maxes');

function[thresh]=stdThresh(im,thresh,axlim,patches,numpat,maxt)
nh=ones(3);
stdim=stdfilt(im,nh);

if((nargin<2)||thresh<0)
    thresh=2.5*median(stdim(:));
end

threshB=50;
threshM=10;
tadd=100;
m=2;

% get patches
% [ar,plist]=sort([patches.area],'descend');
% pats=patches(plist);
[ar,plist]=sort([patches.pc],'descend');
numpat=min(numpat,length(patches));
npats=patches(plist(1:numpat));

% plot the main figure
figure(1)
subplot(2,2,1)
imagesc(im)
cax=caxis;
caxis([cax(1) maxt])
axis(axlim)
title('original image')
subplot(2,2,2)
imagesc(stdim)
axis(axlim)%colorbar
hold on
h=PlotPatches(npats,0);
hold off
title('s.d. filtered image')

% plot the patches
figure(2)
for i=1:numpat
    ax=[npats(i).cs([1 end]) npats(i).rs([1 end])];
    subplot(numpat,m,m*(i-1)+1)
    imagesc(im)
    cax=caxis;
    caxis([cax(1) maxt])
    axis(ax)

    %     subplot(numpat,m,m*(i-1)+2)
    %     imagesc(stdim)
    %     axis(ax)
end

while 1

    s2im=double(stdim>thresh);
    %     s2im=double(sim_mask>(sf*s_lev));
    %     [L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(s2im,im,threshB);
    [L,num] = bwlabeln(s2im);
    s=regionprops(L,'Area','Perimeter');
    ar=[s.Area];
    ms=find((ar>=threshM));%&(ar<threshB));
    bs=find(ar>=threshB);
    bwm = ismember(L,ms);
    bwb = ismember(L,bs);
    tpl=s2im+bwm+bwb;

    figure(2)
    for i=1:numpat
        ax=[npats(i).cs([1 end]) npats(i).rs([1 end])];
        subplot(numpat,m,m*(i-1)+2)
        imagesc(L)
        axis(ax)
    end
    %     title([' threshold, currently ' int2str(thresh)]);

    figure(1)
    subplot(2,2,4)
    imagesc(s2im.*im)
    xlabel('thresholded original')
    %     caxis([0 maxt])
    axis(axlim)
    %     title([' threshold, currently ' int2str(thresh)]);
    subplot(2,2,3)
    %     imagesc(tpl),
    %     caxis([0 3])
    imagesc(L)
    axis(axlim)
    %         text(-800,-150,'up/down arrow to change threshold; return end' ...
    %         ,'FontSize',14);
    title('up/down arrow to change threshold; return end');

    xlabel('objects. ')%Big=red, medium=yellow')
    [x,y,b]=ginput(1);

    %     inp=input(['enter threshold, currently ' int2str(thresh) '. Return if ok:  ']);
    if(isempty(x))
        break;
    elseif(b==30)
        %         keyboard;
        thresh=min(thresh+tadd,maxt);
    elseif(b==31)
        %         keyboard;
        thresh=max(0,thresh-tadd);
    end;
end

function PickPatches(fn,opt,RedCh)

if(nargin<3)
    RedCh=-1;
end
if(nargin<2)
    opt=0;
end
fno=[fn(1:end-4) '_sl1_Mask.mat'];
load(fno)

cstrs={'unclassified';'active';'inhibited';'mixed';...
    'empty';'unsure'};
cols=['b--';'r--';'y--';'c--';'w--';'g--'];

g=colormap('gray');
% g=g(end:-1:1,:);%g(:,[1 3])=0;

maxf=[fn(1:end-4) '_Maxes.mat'];
if(isfile(maxf))
    load(maxf);
    if(opt==2)
        maxt=mmax;
    else
        maxt=mamax;
    end
else
    maxt=256^2-1;
end

for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
    clear mask
    fno3=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    load(fno3)
    if(~isequal(mask,-1))
        x=sum(mask);
        x1=find(x,1);
        x2=find(x,1,'last');
        x=sum(mask,2);
        y1=find(x,1);
        y2=find(x,1,'last');
        axlim=[x1 x2 y1 y2];
        %     figure(fp+ch)
        hereiam=[ sl nl]
        figure(1)
        imagesc(rim)
        if(opt>0)
            cax=caxis;
            caxis([cax(1) maxt])
        end
        axis equal
        axis(axlim)
        colormap(g)
        title(['original: slice ' int2str(sl) '/' int2str(nl)])

        figure(2)
        imagesc(rim)
        axis equal
        if(opt>0)
            cax=caxis;
            caxis([cax(1) maxt])
        end
        colormap(g)
        np=length(patches);

        if(RedCh>0)
            fno4=[fn(1:end-4) '_sl' int2str(sl) '_MaskRed.mat'];
            load(fno4) 
            figure(3)
            imagesc(rim)
            axis equal
            if(opt>0)
                cax=caxis;
                caxis([cax(1) maxt])
            end
            colormap(g)
        end

        if(isfile(fno))
            load(fno)
            i=1;
            while 1
                %set the string and color type from current classification
                str=char(cstrs(ptype(i)+1));
                col=cols(ptype(i)+1,1);

                % plot current patches
                figure(1)
                hold on
                ah=[];
                for j=1:size(cols,1)
                    pjs=find(ptype==(j-1));
                    h=PlotPatches(patches(pjs),0,cols(j,:),p_str(pjs));
                    ah=[ah;h];
                end
                ah=[ah;PlotPatches(patches(i),i,[col '-*'],p_str(i))];
                hold off

                %plot current patch
                if(patches(i).area>10)
                    figure(2)
                    ax=[patches(i).cs([1 end]) patches(i).rs([1 end])];
                    axis(ax)
                    title(['patch ' int2str(i) '/' int2str(np)],'Color',col);
                    xlabel(str,'Color',col);

                    if(RedCh>0)
                        figure(3)
                        ax=[patches(i).cs([1 end]) patches(i).rs([1 end])];
                        axis(ax)
                        title(['patch ' int2str(i) '/' int2str(np)],'Color',col);
                        xlabel(str,'Color',col);
                    end
                    
                    % classify
                    disp(' ')
                    disp(['currently ' str '; Enter: '])
                    disp('return next patch or enter patch number')
                    inp=input('-1 next slice; 0 to print');
                    if(isempty(inp))
                    elseif(isequal(inp,-1))
                        break;
                    elseif(ismember(inp,1:length(patches)))
                        i=inp-1;
                    elseif(isequal(inp,0))
                        disp('entering keyboard mode to print')
                        keyboard;
                    else
                        i=i-1;
                    end
                end
                delete(ah);

                %move round 1
                i=mod(i+1,np);
                if(i==0); i=np; end;
            end
        end
    end
end


function ClassifyPatchesRandom(fn,opt)

figure(10)
if(nargin<2)
    opt=0;
end
fno=[fn(1:end-4) '_sl1_Mask.mat'];
load(fno)

cstrs={'unclassified';'active';'inhibited';'mixed';...
    'empty';'unsure'};
cols=['w--';'r--';'y--';'c--';'k--';'g--'];

maxf=[fn(1:end-4) '_Maxes.mat'];
if(isfile(maxf))
    load(maxf);
    if(opt==2)
        maxt=mmax;
    else
        maxt=mamax;
    end
else
    maxt=256^2-1;
end

for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
    clear mask
    fno3=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    load(fno3)
    if(~isequal(mask,-1))
        x=sum(mask);
        x1=find(x,1);
        x2=find(x,1,'last');
        x=sum(mask,2);
        y1=find(x,1);
        y2=find(x,1,'last');
        axlim=[x1 x2 y1 y2];
        %     figure(fp+ch)
        hereiam=[ sl nl]
%         if(opt
%         subplot(1,2,1)
%         imagesc(rim)
%         if(opt>0)
%             cax=caxis;
%             caxis([cax(1) maxt])
%         end
%         axis(axlim)
%         title(['original: slice ' int2str(sl) '/' int2str(nl)])
% 
%         subplot(1,2,2)
        imagesc(rim)
        if(opt>0)
            cax=caxis;
            caxis([cax(1) maxt])
        end
        axis equal;
        np=length(patches);

        if(~isfile(fno))
            ptype=zeros(1,np);
            strens=zeros(1,np)*NaN;
            p_str=[];
            p_str(np).s=[];
            todo=1;
        else
            load(fno)
            todo=0;
            if(sum(ptype==0))
                todo=1;
            end
        end
        if(todo)
            rndorder=randperm(np);
            i=1;
            while 1
                % get the ith from the radmon order
                r=rndorder(i);
                %set the string and color type from current classification
                str=char(cstrs(ptype(r)+1));
                col=cols(ptype(r)+1,1);

%                 % plot current patches
%                 subplot(1,2,1)
%                 hold on
%                 ah=[];
%                 for j=1:size(cols,1)
%                     pjs=find(ptype==(j-1));
%                     h=PlotPatches(patches(pjs),0,cols(j,:),p_str(pjs));
%                     ah=[ah;h];
%                 end
%                 ah=[ah;PlotPatches(patches(i),i,[col '-*'],p_str(i))];
%                 hold off

                %plot current patch
                if(patches(r).area>10)
%                     subplot(1,2,2)
                    ax=[patches(r).cs([1 end]) patches(r).rs([1 end])];
                    axis(ax)
                    % if all have been attempted, display different title
                    if(sum(ptype==0)==0)
                        title(['ALL PATCHES DONE: patch ' int2str(i) '/' int2str(np)],'Color','r');
                    else
                        title(['patch ' int2str(i) '/' int2str(np)],'Color',col);
                    end
                    xlabel(str,'Color',col);

                    % classify
                    disp(' ')
                    disp(['currently ' str '; Enter: '])
                    disp('1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure;')
                    inp=input(' -1 end; return skip; 0 go back one:  ');
                    if(isempty(inp))
                    elseif(isequal(inp,-1))
                        break;
                    elseif(ismember(inp,[1:5]))
                        ptype(r)=inp;
                        if(ismember(inp,1:3))
                            tempr=0;
                            while(~ismember(tempr,1:3))
                                tempr=input('enter strength, 1=high, 2=med,  3=low:  ');
                            end
                            strens(r)=tempr;
                            p_str(r).s=num2str(strens(r));
                        end
                        save(fno,'ptype','strens','p_str');
                    elseif(isequal(inp,0))
                        i=i-2;
                    else
                        i=i-1;
                    end
                else
                    ptype(r)=-2;
                end
%                 delete(ah);

                %move round 1
                i=mod(i+1,np);
                if(i==0); i=np; end;
            end
            % show the slice
            imagesc(rim)
            if(opt>0)
                cax=caxis;
                caxis([cax(1) maxt])
            end
            axis equal;
            hold on
            ah=[];
            for j=1:size(cols,1)
                pjs=find(ptype==(j-1));
                h=PlotPatches(patches(pjs),0,cols(j,:),p_str(pjs));
                ah=[ah;h];
            end
            hold off
            inp=1;
            while(~isequal(inp,0))
                inp=input('slice generated. enter 0 to continue');
            end
        end
    end
end


function ClassifyPatches(fn,opt)

if(nargin<2)
    opt=0;
end
fno=[fn(1:end-4) '_sl1_Mask.mat'];
load(fno)

cstrs={'unclassified';'active';'inhibited';'mixed';...
    'empty';'unsure'};
cols=['w--';'r--';'y--';'c--';'k--';'g--'];

maxf=[fn(1:end-4) '_Maxes.mat'];
if(isfile(maxf))
    load(maxf);
    if(opt==2)
        maxt=mmax;
    else
        maxt=mamax;
    end
else
    maxt=256^2-1;
end

for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
    clear mask
    fno3=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    load(fno3)
    if(~isequal(mask,-1))
        x=sum(mask);
        x1=find(x,1);
        x2=find(x,1,'last');
        x=sum(mask,2);
        y1=find(x,1);
        y2=find(x,1,'last');
        axlim=[x1 x2 y1 y2];
        %     figure(fp+ch)
        hereiam=[ sl nl]
        subplot(1,2,1)
        imagesc(rim)
        if(opt>0)
            cax=caxis;
            caxis([cax(1) maxt])
        end
        axis(axlim)
        title(['original: slice ' int2str(sl) '/' int2str(nl)])

        subplot(1,2,2)
        imagesc(rim)
        if(opt>0)
            cax=caxis;
            caxis([cax(1) maxt])
        end
        np=length(patches);

        if(~isfile(fno))
            ptype=zeros(1,np);
            strens=zeros(1,np)*NaN;
            p_str=[];
            p_str(np).s=[];
            todo=1;
        else
            load(fno)
            todo=0;
            if(sum(ptype==0))
                todo=1;
            end
        end
        if(todo)
            i=1;
            while 1
                %set the string and color type from current classification
                str=char(cstrs(ptype(i)+1));
                col=cols(ptype(i)+1,1);

                % plot current patches
                subplot(1,2,1)
                hold on
                ah=[];
                for j=1:size(cols,1)
                    pjs=find(ptype==(j-1));
                    h=PlotPatches(patches(pjs),0,cols(j,:),p_str(pjs));
                    ah=[ah;h];
                end
                ah=[ah;PlotPatches(patches(i),i,[col '-*'],p_str(i))];
                hold off

                %plot current patch
                if(patches(i).area>10)
                    subplot(1,2,2)
                    ax=[patches(i).cs([1 end]) patches(i).rs([1 end])];
                    axis(ax)
                    title(['patch ' int2str(i) '/' int2str(np)],'Color',col);
                    xlabel(str,'Color',col);

                    % classify
                    disp(' ')
                    disp(['currently ' str '; Enter: '])
                    disp('1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure;')
                    inp=input(' -1 end; return skip; 0 go back one:  ');
                    if(isempty(inp))
                    elseif(isequal(inp,-1))
                        break;
                    elseif(ismember(inp,[1:5]))
                        ptype(i)=inp;
                        if(ismember(inp,[1:3]))
                            strens(i)=input('enter strength, 1=high, 2=med,  3=low:  ');
                            p_str(i).s=num2str(strens(i));
                        end
                        save(fno,'ptype','strens','p_str');
                    elseif(isequal(inp,0))
                        i=i-2;
                    else
                        i=i-1;
                    end
                end
                delete(ah);

                %move round 1
                i=mod(i+1,np);
                if(i==0); i=np; end;
            end
        end
    end
end


function[m,s]=ShowClassifyPatches(lsmlist,inds,ret,ts)
if(nargin<3)
    ret=0;
    ts=[];
end
sfn={'1';'2';'3a';'4a'};
cstrs={'unclassified';'active';'inhibited';'mixed';...
    'empty';'unsure'};
i=1;
dap=[1 1 1 0 0 0 1 1 1 1 0 0 0 0];
pn=[1 3 5 2 4 6 7 9 11 13 8 10 12 14];
if(ret==3) dpa=zeros(1,9);
else dpa=zeros(1,6);
end
dma=zeros(1,6);
dppc=[];
dmpc=[];
figure(2)
for k=1:length(inds)
    opt=inds(k);
    if(ret>=2)
        subplot(length(inds),1,k)
    else
        subplot(7,2,pn(opt))
    end
    %     f1=['dapt_' char(sfn(opt,:)) '.lsm'];
    fn=char(lsmlist(opt));
    [p1,s1,ad1,f1,fa1]=ResClassifyPatches(fn);
    % output fa1 is with the mixed channels added 50:50 into the
    % active/inhibited
    %
    % if option ret is 3 or 4, instead just ignore the mixed channels
    if(ret==3)
        fa1=f1(1:9);
    elseif(ret==4)
        fa1=f1(1:9);
    end
    
    % make a percentage out of the values
    pc=fa1*100/sum(fa1);
    bar([-3:-1 1:3],pc(1:6))
    ylabel(fn(1:end-4))
    n0(k,:)=[f1(end) sum(f1) sum(f1(1:6))]
    if(ret>=2)
        dpa=dpa+fa1;
        dppc=[dppc;pc];
    elseif(dap(opt))
        dpa=dpa+fa1;
        dppc=[dppc;pc];
    else
        dma=dma+fa1;
        dmpc=[dmpc;pc];
    end
    %     [p2,s2,ad2,f2,fa2]=ResClassifyPatches(f2);
    %     i1=[p1,s1 NaN];
    %     i2=[p2,s2 NaN];
    %     bar([i1([2 7 10 3 8 10 4 9 10 5 10 6 10 1]);...
    %         i2([2 7 10 3 8 10 4 9 10 5 10 6 10 1])]')
    %     SetXTicks(gca,[],[],[],[1.5 4.5 7.5 10 12 14],cstrs([2:6 1]))
    %     bar([-3:-1 1:3],[fa1*100/sum(fa1);fa2*100/sum(fa2)]')
    %     title([char(sfn(opt,:)) ': dapt=blue; dmso=red'])
    %     i=i+1;
end
ma=max([dppc(:);dmpc(:)]);
for k=1:length(inds)
    opt=inds(k);
    %     figure(opt)
    if(ret>=2)
        subplot(length(inds),1,k)
    else
        subplot(7,2,pn(opt))
    end
    ylim([0 ma])
end
% subplot(7,2,1), title('dapt')
% subplot(7,2,2), title('dmso')

dp1=ones(sum(dap(inds)==1),1);
dm1=ones(sum(dap(inds)==0),1);
grs=[-6*dp1;-5*dp1;-4*dp1;-3*dp1;-2*dp1;-1*dp1;...
    1*dm1;2*dm1;3*dm1;4*dm1;5*dm1;6*dm1];
vals=[dppc(:);dmpc(:)];

% if(isempty(dmpc)); dmpc=zeros(3,6); end;
astr(1).s={'strong';'medium';'weak'};
astr(2).s={'weak';'medium';'strong'};
astrall={'strong';'medium';'weak';'weak';'medium';'strong'};
astrall2={'strong';'medium';'weak';'weak';'medium';'strong';'weak';'medium';'strong'};
tstr={'active';'inhibited'};
if(ret==2)
    %     subplot(4,1,4)
%     ts='retinas_11x_'
%     ts='coloc_'
    if(nargin<4) 
        ts=fn(1:7); 
    end;
    figure(3)
    bar([-3:-1 1:3],[dpa*100/sum(dpa)])%;dma*100/sum(dma)]')
    title('total %ages: dapt=blue; dmso=red')
    saveas(gcf,[ts 'sum_hand'], 'fig');
    saveas(gcf,[ts 'sum_hand'], 'bmp');
    colormap gray
    
    figure(4)
    colormap gray
    BarErrorBar([-3:-1 1:3],mean(dppc,1)',std(dppc,1)',[],[],['k';'w'])
    Setbox;ylim([0 70]);
    SetXTicks(gca,[],[],[],[-3:-1 1:3],astrall)
    title(['mean ' ts ' %ages: dapt=blue; dmso=red'])
    saveas(gcf,[ts 'means_hand'], 'fig');
    saveas(gcf,[ts 'means_hand'], 'bmp');
elseif(ret==3)
    figure(4)
    colormap gray
    BarErrorBar([-3:-1 1:3 6:8],mean(dppc,1)',std(dppc,1)',[],[],['k';'w'])
    Setbox;ylim([0 70]);
    SetXTicks(gca,[],[],[],[-3:-1 1:3 6:8],astrall2)
    title(['mean ' ts ' %ages'])
    xlim([-4 4])
    saveas(gcf,[ts 'means_hand'], 'fig');
    saveas(gcf,[ts 'means_hand'], 'bmp');
    xlim([5 9]);ylim([0 2])
    saveas(gcf,[ts 'means_hand_Mixed'], 'fig');
    saveas(gcf,[ts 'means_hand_Mixed'], 'bmp');

    figure(5)
    dm1=ones(length(inds),1);
    grs=[-3*dm1;-2*dm1;-1*dm1;1*dm1;2*dm1;3*dm1;6*dm1;7*dm1;8*dm1];
    h=boxplot(dppc(:),grs,'positions',[-3:-1 1:3 6:8]);
    Setbox;ylim([0 60]);
    SetXTicks(gca,[],[],[],[-3:-1 1:3 6:8],astrall2)
    title(['distribution of ' ts ' %ages'])
    xlim([-4 4])
    saveas(gcf,[ts 'boxplots_hand'], 'fig');
    saveas(gcf,[ts 'boxplots_hand'], 'bmp');
    xlim([5 9]);ylim([0 2])
    saveas(gcf,[ts 'boxplots_hand_Mixed'], 'fig');
    saveas(gcf,[ts 'boxplots_hand_Mixed'], 'bmp');
    
else
    figure(1)
    subplot(2,2,1),
    bar([-3:-1 1:3],[mean(dppc);mean(dmpc)]')
    title('mean %ages: dapt=blue; dmso=red')
    subplot(2,2,2),
    bar([-3:-1 1:3],[median(dppc);median(dmpc)]')
    title('median %ages: dapt=blue; dmso=red')
    subplot(2,2,3),
    bar([-3:-1 1:3],[dpa*100/sum(dpa);dma*100/sum(dma)]')
    title('total %ages: dapt=blue; dmso=red')
    subplot(2,2,4),
    h=boxplot(vals,grs,'positions',[-7:-5 1:3 -3:-1 5:7]);
end

m=mean(dppc,1);
s=std(dppc,1);

ias=[1:3; 4:6];
ibs=[-6:-4 1:3; -3:-1 4:6];
if(ret==0)
    for i=1:2
        astrs=astr(i).s;
        is=ias(i,:);
        ts=char(tstr(i));
        figure(2+i)
        colormap gray
        %     bar(1:3,[mean(dppc(:,is));mean(dmpc(:,is))]')
        BarErrorBar(1:3,[mean(dppc(:,is));mean(dmpc(:,is))]',[std(dppc(:,is));std(dmpc(:,is))]',[],[],'k')
        Setbox;ylim([0 60]);
        SetXTicks(gca,[],[],[],[1:3],astrs([1:3]))
        title(['mean ' ts ' %ages: dapt=blue; dmso=red'])
%         saveas(gcf,[ts 'means_hand_daptvsdmso'], 'fig');
%         saveas(gcf,[ts 'means_hand_daptvsdmso'], 'bmp');
        
        figure(4+i)
        %     bar([1:3],[median(dppc(:,is));median(dmpc(:,is))]')
        BarErrorBar(1:3,[median(dppc(:,is));median(dmpc(:,is))]',0.5*[iqr(dppc(:,is));std(dmpc(:,is))]')
        Setbox;ylim([0 60]);
        SetXTicks(gca,[],[],[],[1:3],astrs([1:3]))
        title(['median ' ts ' %ages: dapt=blue; dmso=red'])
%         saveas(gcf,[ts 'medians_hand_daptvsdmso'], 'fig');
%         saveas(gcf,[ts 'medians_hand_daptvsdmso'], 'bmp');

        figure(6+i)
        bar([1:3],[dpa(is)*100/sum(dpa);dma(is)*100/sum(dma)]')
        Setbox;ylim([0 40]);
        SetXTicks(gca,[],[],[],[1:3],astrs([1:3]))
        title(['total ' ts ' %ages: dapt=blue; dmso=red'])
%         saveas(gcf,[ts 'sum_hand_daptvsdmso'], 'fig');
%         saveas(gcf,[ts 'sum_hand_daptvsdmso'], 'bmp');

        figure(8+i)
        colormap gray
        is=ismember(grs,ibs(i,:));
        h=boxplot(vals(is),grs(is),'positions',[1:3:7 2:3:8]);
        Setbox;ylim([0 60]);
        SetXTicks(gca,[],[],[],[1:3:7]+.5,astrs([1:3]))
        title(['distribution of ' ts ' %ages: dapt (left); dmso (right)'])
%         saveas(gcf,[ts 'boxplots_hand_daptvsdmso'], 'fig');
%         saveas(gcf,[ts 'boxplots_hand_daptvsdmso'], 'bmp');
    end
    % plot the values as dots
    keyboard
    figure(10)
    x=[-3:-1 1:3];
    xgap=[-.3:.1:0.3]/4;%rand(size(dppc,1),1)*0.05;
    g2=0.15;
    for i=1:6
        x1=xgap+x(i)-g2;
        x2=xgap+x(i)+g2;
        plot(x1,dppc(:,i),'k.',x2,dmpc(:,i),'kx')
        hold on
    end
    plot(x-g2,median(dppc),'bo',x+g2,median(dmpc),'ro')
    Setbox;ylim([0 60]);
    SetXTicks(gca,[],[],[],x,astrs([3 2 1 1:3]))
    hold off
    for i=1:6
        [p(i),h1(i)]=ranksum(dppc(:,i),dmpc(:,i));
    end
    [p(7),h1(7)]=ranksum(sum(dppc(:,1:3),2),sum(dmpc(:,1:3),2))
end


function[pcs,s,alldat,f,f2]=ResClassifyPatches(fn)

im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
pts=[];
strs=[];
alldat=[];
ncs=6;
for sl=1:nl
    fno=['Classified\' fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
    if(isfile(fno))
        load(fno)
        np(sl)=length(ptype);
        v1s=ones(np(sl),1);
        pts=[pts ptype];
        strs=[strs strens];
        alldat=[alldat;[sl*v1s (1:np(sl))' np(sl)*v1s ptype' strens']];
    else
        np(sl)=0;
    end
end
nps=length(pts);
Fss=Frequencies(pts,0:(ncs-1));
pcs=100*Fss/nps;
% alldat=[alldat zeros(size(alldat,1),1)];
% alldat=[alldat alldat(:,end-1)+10];
c=[-3 -2 -1 3 2 1 4 5 6];
for i=1:3
    for j=1:3
        alldat((pts==i)&(strs==j),end)=c(j+3*(i-1));
        f(j+3*(i-1))=sum((pts==i)&(strs==j));
    end
    s(i)=mean(strs(pts==i));
end
% reverse the inhibited!
f2=f([1:3 6:-1:4]);
% add them on as 50:50 to each group
f2=f2+f([7:9 9 8 7])*0.5;
f([7:9])*100/nps
f(10)=Fss(1);
fno=['Classified\' fn(1:end-4) '_TypeV2_All.mat'];
save(fno,'alldat','Fss','pcs','s','f2','f')


function dummy
[dapt,dmso]=GetIm(3,2);

% vr=400:600;
% vc=600:800;
% dapt=dapt(vr,vc);
% dmso=dmso(vr-25,vc);
figure(3)
show_ims(dapt,dmso,0)
figure(4)
[pim,mim,pt,mt,mpim,mmim]=getmask(dapt,dmso);
nh=ones(3);
sp=stdfilt(dapt,nh);
sm=stdfilt(dmso,nh);
rp=double(rangefilt(dapt,nh));
rm=double(rangefilt(dmso,nh));
figure(5)
show_ims(sp,sm,0)
figure(6)
show_ims(sp.*pim,sm.*mim,2)
figure(7)
show_ims(rp.*pim,rm.*mim,2)
figure(8)
ts=min(pt,mt):10:100;
for i=1:length(ts)
    i
    subplot(2,3,1)
    %     [num1(i),s1]=ObjectThresh(mpim,pt*2);
    [num1(i),e1,a1]=ObjectThresh(mpim,ts(i));
    subplot(2,3,4)
    %     [num2(i),s2]=ObjectThresh(mmim,mt*2);
    [num2(i),e2,a2]=ObjectThresh(mmim,ts(i));
    subplot(2,3,2)
    %     plot([s1.a],[s1.e],'b.',[s2.a],[s2.e],'rx')
    [y1,x1]=hist(e1,20);
    [y2,x2]=hist(e2,20);
    plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:')
    subplot(2,3,5)
    [y1,x1]=hist(a1,20);
    [y2,x2]=hist(a2,20);
    plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:')
    subplot(2,3,3)
    bar([num1(i) num2(i)])
end
i=3
a=10
keyboard
imagesc(mmim)
[y3,x3]=frequencies(mpim);
[y4,x4]=frequencies(mmim);
[y3,x3]=frequencies(mpim);
[y4,x4]=frequencies(mmim);
subplot(2,3,6)
plot(ts,num1,ts,num2,'r:'),axis tight

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
% figure(20)
% subplot(1,2,1)
% imagesc(im)
% subplot(1,2,2)
% imagesc(newim)
% title(['wiggliness = ' num2str(w)])
% disp('in wiggliness; return to continue')
% pause


function[v1,v2,v3,v4]=tempfunc(dap1,dam3,i)
figure(i)
[v1,v2]=GetAllGs(dam3);
[v3,v4]=GetAllGs(dap1);
[y,x1]=hist(v1,100);y1=y/sum(y);
[y,x2]=hist(v2,100);y2=y/sum(y);
[y,x3]=hist(v3,100);y3=y/sum(y);
[y,x4]=hist(v4,100);y4=y/sum(y);
subplot(2,1,1),plot(x1,y1,'r:',x3,y3)
subplot(2,1,2),plot(x2,y2,'r:',x4,y4)

function[va,vas]=GetAllGs(dat)
va=[];
vas=[];
nh=ones(3);
for i=1:length(dat)
    im=dat(i).p_im;
    sim=stdfilt(im,nh);
    vmask=dat(i).m_im(:);
    vsim=vmask.*sim(:);
    v=vmask.*im(:);
    va=[va;v(v>0)];
    vas=[vas;vsim(vsim>0)];
end


%
% ResultsSumm(dap,dam)
%
% ShowPatch(dat(j))
% ShowPatch(dap(98))

function ResultsSummary(dap,dam,fadd)
if(nargin<3)
    fadd=0;
end
nf=length(dap)/length(dam);

% Big objects eccentricity solidity and wiggliness
figure(1+fadd)
[bp,bep,bwp,nlp]=text_getbigs(dap);
[bm,bem,bwm,nlm]=text_getbigs(dam);
subplot(2,2,1)
plot(bp.x1,bp.y1,bm.x1,bm.y1,'r:')
bar([bp.x1],[[bp.y1]' [bm.y1]'])
title('wiggliness'),axis tight
subplot(2,2,2)
plot(bp.x2,bp.y2,bm.x2,bm.y2,'r:')
title('eccentriciy'),axis tight
subplot(2,2,3)
plot(bp.x3,bp.y3,bm.x3,bm.y3,'r:')
bar([bp.x3],[[bp.y3]' [bm.y3]'])
title('wiggliness of non-lines'),axis tight
subplot(2,2,4)
plot(bp.x4,bp.y4,bm.x4,bm.y4,'r:')
bar([bp.x4],[[bp.y4]' [bm.y4]'])
title('wiggliness of lines'),axis tight

% numbers of patches with different things
figure(2+fadd)
plotns(dap,dam,nf,nlp,nlm,4+fadd)

% mean/median green levels
figure(3+fadd)
[dp,xp]=StatsOverX(bep,bwp,-0:2:10);
[dm,xp]=StatsOverX(bem,bwm,-0:2:10);
subplot(2,2,1)
plot(bep,bwp,'bo')
xlabel('eccentricity')
ylabel('wiggliness')
subplot(2,2,2)
plot(bem,bwm,'rx')
xlabel('eccentricity')
ylabel('wiggliness')
subplot(2,2,3)
plot(xp,[dp.me],xp,[dm.me],'r:','Linewidth',2)
xlabel('mean eccentricity');ylabel('mean wiggliness');axis tight
subplot(2,2,4)
plot(xp,[dp.med],xp,[dm.med],'r:','Linewidth',2)
xlabel('median eccentricity');ylabel('median wiggliness');axis tight
[sp,xp]=hist([dap.s_lev],20);
[sm,xm]=hist([dam.s_lev],20);
plot(xp,sp,xm,sm,'r:'),axis tight,xlabel('threshold')

return
op=text_getdat(dap);
om=text_getdat(dam);
subplot(2,2,1)
plot(op.x1,op.y1,op.x2,op.y2,'b:', ...
    om.x1,om.y1,'r',om.x2,om.y2,'r:')
title('mean/median (:) patch greens')
axis tight
subplot(2,2,2)
plot(op.x4,op.y4,op.x5,op.y5,'b:', ...
    om.x4,om.y4,'r',om.x5,om.y5,'r:')
title('median background/threshold (:) greens')
axis tight
subplot(2,2,4)
plot(op.x6,op.y6,om.x6,om.y6,'r',op.x7,op.y7,'b:', ...
    om.x7,om.y7,'r:')
title('median background/threshold (:) std')
axis tight
subplot(2,2,3)
plot(op.x3,op.y3,om.x3,om.y3,'r',op.x8,op.y8,'b:', ...
    om.x8,om.y8,'r:')
title('mean object greens (patch vs all (:))')
axis tight

function plotns(dap,dam,nf,nlp,nlm,fignum)
subplot(2,2,1)
% [y,x]=hist([dap.n]-[dap.nmeds]);[y2,x2]=hist([dam.n]-[dam.nmeds]);
% plot(x,y/sum(y),x2,y2/sum(y2),'r:'),
lp=length(dap);
lm=length(dam);

% mean green levels and areas
d=[dap.g];glevp=d(1,:);
d=[dam.g];glevm=d(1,:);
d=[dap.backG_s];blevp=d(1,:);
d=[dam.backG_s];blevm=d(1,:);
arp=[dap.area];
arm=[dam.area];

nmedp=[dap.nmeds_s]-[dap.nbig_s];
nmedm=[dam.nmeds_s]-[dam.nbig_s];
notlinep=[dap.nbig_s]-nlp;
notlinem=[dam.nbig_s]-nlm;
emptyp=find([dap.nmeds_s]<1);
emptym=find([dam.nmeds_s]<1);

% line w.o. medium or big objects
onlylp=find((nlp>0)&(nmedp==0)&(notlinep==0));
onlylm=find((nlm>0)&(nmedm==0)&(notlinem==0));

% line w.o.  big objects
% onlylpi=find((nlp>0)&(notlinep==0));
% onlylmi=find((nlm>0)&(notlinem==0));
onlylpi=find((nlp>0)&(nmedp>0)&(notlinep==0));
onlylmi=find((nlm>0)&(nmedm>0)&(notlinem==0));

% only vesicles
% onlyvp=find([dap.nbig_s]==0);
% onlyvm=find([dam.nbig_s]==0);
onlyvp=find(([dap.nbig_s]==0)&(nmedp>0));
onlyvm=find(([dam.nbig_s]==0)&(nmedm>0));

m=3;n=3;
pcp=[length(emptyp) length(onlylp) length(onlylpi) length(onlyvp)]*100/lp;
pcm=[length(emptym) length(onlylm) length(onlylmi) length(onlyvm)]*100/lm;
pcs=[pcp;pcm];
subplot(m,n,1),bar(pcs(:,[1 4])')
title('% empty patches/vesicles only')
subplot(m,n,2),bar(pcs(:,[2 3])')
title('% only lines/lines and vesicles')
subplot(m,n,4),
[y,x]=hist(glevp(emptyp),20);
[y2,x2]=hist(glevm(emptym),20);
[y3,x3]=hist(glevp(onlyvp),20);
[y4,x4]=hist(glevm(onlyvm),20);
plot(x,y/sum(y),x2,y2/sum(y2),'r:')%, ...
axis tight;title('empty green level')
subplot(m,n,7),
plot(x3,y3/sum(y3),x4,y4/sum(y4),'r:');
axis tight;title('vesicles green level')
subplot(m,n,5),
[y,x]=hist(blevp(onlylp),20);
[y2,x2]=hist(blevm(onlylm),20);
[y3,x3]=hist(blevp(onlylpi),20);
[y4,x4]=hist(blevm(onlylmi),20);
plot(x,y/sum(y),x2,y2/sum(y2),'r:')%, ...
%     x3,y3/sum(y3),'b--x',x4,y4/sum(y4),'r:x');
axis tight;title('line only green level')
subplot(m,n,8),
plot(x3,y3/sum(y3),x4,y4/sum(y4),'r:');
axis tight;title('line+vesicles green')
subplot(m,n,3),
[y,x]=hist(nmedp(onlylpi),0:10);
[y2,x2]=hist(nmedm(onlylmi),0:10);
plot(x,y/sum(y),x2,y2/sum(y2),'r:');axis tight
title('# vesicles in patches with only lines')
subplot(m,n,6),
[y,x]=hist(nmedp([dap.nbig_s]==0),0:10);
[y2,x2]=hist(nmedm([dam.nbig_s]==0),0:10);
plot(x,y/sum(y),x2,y2/sum(y2),'r:');axis tight
title('# vesicles in patches w.o. bigs')
subplot(m,n,9),
arsp=[sum(arp(emptyp)) sum(arp(onlylp))]*100/sum(arp);
arsm=[sum(arm(emptym)) sum(arm(onlylm))]*100/sum(arm);
bar([arsp;arsm]')
title('areas of empty/line only patches')

figure(fignum)
subplot(2,2,1)
[y,x]=hist(nmedp,0:20);
[y2,x2]=hist(nmedm,0:20);
[y3,x3]=hist([dap.nmeds_s],0:15);
[y4,x4]=hist([dam.nmeds_s],0:15);
plot(x,y,x2,y2*nf,'r:');%,x3,y3,'b:',x4,y4*nf,'r:'),
axis tight; title('# vesicles')
subplot(2,2,2)
% plot(x,y/sum(y),x2,y2/sum(y2),'r:'),axis tight
[y,x]=hist(nmedp./[dap.area],20);
[y2,x2]=hist(nmedm./[dam.area],20);
plot(x,y,x2,y2*nf,'r:'),axis tight
axis tight; title('density of vesicles')
subplot(2,2,3)
% [y,x]=hist([dap.nbig_s],0:10);
% [y2,x2]=hist([dam.nbig_s],0:10);
[y,x]=hist([dap.nbig_s]-nlp,0:5);
[y2,x2]=hist([dam.nbig_s]-nlm,0:5);
plot(x,y,x2,y2*nf,'r:')
axis tight; title('# big objects')
subplot(2,2,4)
[y,x]=hist([dap.nline_s],0:5);
[y2,x2]=hist([dam.nline_s],0:5);
[y,x]=hist([nlp],0:5);
[y2,x2]=hist([nlm],0:5);
% plot(x,y/sum(y),x2,y2/sum(y2),'r:'),axis tight
plot(x,y,x2,y2*nf,'r:')
axis tight; title('# lines')


% dsp.n=[dap.n_s];dsp.nbig=[dap.nbig_s];
% dsp.nmeds=[dap.nmeds_s];dsp.nline=[dap.nline_s];
% dsm.n=[dam.n_s];dsm.nbig=[dam.nbig_s];
% dsm.nmeds=[dam.nmeds_s];dsm.nline=[dam.nline_s];


function[o,eccObj,wigg,nlines,mwObj,meObj,maObj,maxObj,saObj,mallObj]=text_getbigs(da)
wigg=[da.wig_s];
[y,x]=hist(wigg,0:15);o.x1=x;o.y1=y/sum(y);

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
% [y,x]=hist(eccObj,0:10);o.x2=x;o.y2=y/sum(y);
% [y,x]=hist(wigg((eccObj<2)),0:10);o.x3=x;o.y3=y/sum(y);
% [y,x]=hist(wigg((eccObj>=2)),0:10);o.x4=x;o.y4=y/sum(y);
% [y,x]=hist(solObj,20);o.x3=x;o.y3=y/sum(y);
% [y,x]=hist(arObj,20);o.x4=x;o.y4=y/sum(y);

function[o]=text_getdat(da)
% [y,x]=hist([da.pct2]);o.x1=x;o.y1=y/sum(y);
% [y,x]=hist([da.pcs]);o.x2=x;o.y2=y/sum(y);
% [y,x]=hist([da.pct2]);o.x3=x;o.y3=y/sum(y);

d=[da.backG_s];[y,x]=hist(d(1,:));o.x4=x;o.y4=y/sum(y);
d=[da.th1];l=MyPrctile(unique(d),[25 75]);
o.x5=l([1 1 2 2 1]);m=max([o.y4]);o.y5=[0 m m 0 0];

d=[da.backStd_s];[y,x]=hist(d(1,:));o.x6=x;o.y6=y/sum(y);
d=[da.s_lev];l=MyPrctile(unique(d),[25 75]);
o.x7=l([1 1 2 2 1]);m=max([o.y6]);o.y7=[0 m m 0 0];

intObj=[];
for i=1:length(da)
    v1=[da(i).p_im].*[da(i).m_im];
    vs=v1(v1>0);
    medglev(i)=median(vs);
    meaglev(i)=mean(vs);
    Ints=[da(i).L_s.MeanIntensity];
    meaObj(i)=mean(Ints);
    intObj=[intObj Ints];
end
[y,x]=hist(meaglev,20);o.x1=x;o.y1=y/sum(y);
[y,x]=hist(medglev,20);o.x2=x;o.y2=y/sum(y);
[y,x]=hist(meaObj,20);o.x3=x;o.y3=y/sum(y);
[y,x]=hist(intObj,20);o.x8=x;o.y8=y/sum(y);


function ResultsPatch(dat,m,i,pnum,ca,opt)
if(opt==1)
    out=AnalysePatch(dat.p_im,dat.m_im,[dat.th1 dat.th2_s],dat.thf,dat.thf_s,dat.patch,2,m,i,pnum,ca);
else
    out=AnalysePatch(dat.p_im,dat.m_im,dat.th1,dat.thf,dat.thf_s,dat.patch,2,m,i,pnum,ca);
end


function ResultsSlice(da,sl,numfs,opt)
clf
% sl is which slice to process, numfs is how many figs to plot in 1 opt
% controls which version of std thresholding to do
is=find([da.sl]==sl);
da=da(is);
figure(1)
clf
fn=[da(1).fn_im];
im=tiffread29(fn,2*[da(1).sl]-1);
gim=double(cell2mat(im.data(1)));
% imagesc(double(gim>(dat.th1)).*gim);
imagesc(gim);
ca=caxis;
for i=1:length(da)
    patches(i)=da(i).patch;
    v1=[da(i).p_im].*[da(i).m_im];
    glev(i)=median(v1(v1>0));
end
hold on;
h=PlotPatches(patches,1);
hold off

figure(2)
m=4;n=2;
d=[da.backG_s];
backG=d(1,:);
d=[da.backStd_s];
backStd=d(1,:);
subplot(m,n,1)
bar(backG),axis tight
title('Background green')
subplot(m,n,2)
bar(backStd),axis tight
title('Background s.d.')
subplot(m,n,3)
bar([da.pcs]),axis tight
title('% over thresh')
subplot(m,n,4)
bar([da.n_s]),axis tight
title('num objects')
subplot(m,n,5)
bar([da.nmeds_s]),axis tight
title('num medium objects')
subplot(m,n,6)
bar([da.nbig_s]),axis tight
title('num big objects')
subplot(m,n,7)
bar([da.nline_s]),axis tight
title('num lines')
subplot(m,n,8)
bar(glev),axis tight
title('median green level')
% bar([[da.s_lev] NaN da(1).th1_s da(1).th2_s]),axis tight
% title('thresholds (ignore)')

nsl=length(da);
r=0;
for i=1:nsl
    fnum=ceil(i/numfs);
    figure(fnum+2)
    ResultsPatch(da(i),numfs,i-numfs*r,i,ca,opt);
    if(mod(i,numfs)==0)
        r=r+1;
    end
end


function ShowPatch(dat)
figure(4)
subplot(4,3,10)
fn=[dat.fn_mask(1:6) '.lsm'];
im=tiffread29(fn,2*[dat.sl]-1);
gim=double(cell2mat(im.data(1)));
imagesc(double(gim>(dat.th1)).*gim);
imagesc(gim);
hold on;
h=PlotPatches(dat.patch,1);
title('low threshold')
hold off
% subplot(4,3,11)
% imagesc(double(gim>(dat.th1)).*gim);
% title('low threshold')
subplot(4,3,11)
imagesc(double(gim>(dat.thf*dat.th1)).*gim);
title('high threshold')
ca=caxis;
out=AnalysePatch(dat.p_im,dat.m_im,dat.th1,dat.thf,dat.thf_s,dat.patch,1);
subplot(4,3,1)
caxis(ca)


function TexturePatchesRed(opt,lsms,inds)

s=dir('*.lsm');
for i=inds% 1];
    fn=char(lsms(i));
    if(opt==2)  % vecadretina stuff
    elseif(opt==4)   % colocalised vessels
        if(isequal(fn(1:3),'Ima'))
            redCh=2;
        elseif(isequal(fn(1:4),'DMSO'))
            redCh=2;
        end
    elseif(opt==5)   % new new stuff internal/front
        redCh=1;
    end
    
    % get the red values
    GetDataStdThreshRed(fn,redCh);
    TextureSlicesRed(fn,i);    
%         TextureSliceMasksRed(fn);
end


% this function is the helper function which calls the function which makes
% the masks. The masks are then used to in the patching program which 
% generates the patches to be classified, either by hand or automatically
% so this is, in most cases, the first function which needs to be run
% 
% the bulk of the function simply is a case-by-case list of the lsms and 
% hard coded options which say which channel of the lsm will be used to
% decide on the mask and which will be shown when patching
% 
% gets inputs which are 
% opt: which sets an option; it's not really used but could be
% lsms has the list of lsm files and inds is which of those to process
%
% in the GUI, I imagine that all these options will be set by the user so
% this is somewhat defunct but I include it for reference
function TexturePatches(opt,lsms,inds)

% this is legacy code but essentially says: do all the lsms in the
% directory
s=dir('*.lsm');
if(nargin<3); inds =1:length(s); end;

for i=inds
    % again, legacy
    if(nargin<2)
        fn=s(i).name;
    else
        fn=char(lsms(i));
    end
    
    % this bit is where I hardcoded which channels were used for the 
    % mask (vessCh) and which for classifying (vecadCh)
    if(opt==2)  % vecadretina stuff
        if(isequal(fn(1:3),'63X'))
            [vecadCh,vessCh]=deal(2,4);
        elseif(isequal(fn(1:4),'11_C'))
            [vecadCh,vessCh]=deal(3,1);
        elseif(isequal(fn(1:4),'B322'))
            [vecadCh,vessCh]=deal(1,1);
        elseif(isequal(fn(1:4),'Clau'))
            [vecadCh,vessCh]=deal(2,1);
        elseif(isequal(fn(1:4),'Eleo'))
            [vecadCh,vessCh]=deal(2,1);
        elseif(isequal(fn(1:4),'P22_'))
            [vecadCh,vessCh]=deal(1,1);
        end
    elseif(opt==3)   % new stuff where there aren't vessel staining
        [vecadCh,vessCh]=deal(1,1);
    elseif(opt==4)   % colocalised vessels
        if(isequal(fn(1:3),'Ima'))
            [vecadCh,vessCh,redCh]=deal(3,4,2);
        elseif(isequal(fn(1:4),'DMSO'))
            [vecadCh,vessCh,redCh]=deal(3,3,2);
        end
    elseif(opt==5)   % new new stuff internal/front
%         [vecadCh,vessCh]=deal(3,2);
        [vecadCh,vessCh]=deal(2,2);
    else   % Zoomed2 stuff (dapt vs dmso)
        [vecadCh,vessCh]=deal(1,2);
    end
    % don't worry about this bit: it's legacy code
    % 
    %     fn=s(i).name
    %     fno=[fn(1:end-4) '_data_2_Mask.mat'];
    %     figure(i)
    %     [maxi,meani]=GetMaxGreenLevel(fn);
    %     if(~isfile(fno))
    %         [thresh,maxmask]=getMaskSl(maxi);
    %         save(fno,'thresh','maxi','maxmask');
    %
    %     end

    % don't worry about this bit: it's legacy code
    % analyse slices
    %      TextureSlices(fn,2)
    % get the red values
    %     TextureSlicesRed(fn,i);

    % this bit calls the function to get the masks
    TextureSliceMasks(fn,vessCh,vecadCh)
    
    % this goes through the lsm to find minimum and maximum values across 
    % the lsm which are used when displaying things
    GetDataStdThresh(fn,vecadCh);

    %         TextureSliceMasksRed(fn);
    %        GetDataStdThreshRed(fn,redCh);
end
% [d1,d2,d3,da]=GetPatches2;
% for i=4:length(da)
%     figure(i)
%     out(i,:)=AnalysePatch(da(i).dat)
% end

function TextureSliceMasks(fn,chan,vchan)

if(nargin<2)
    chan=2; % this is the channel for all the lsms in Zoomed2
end
im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
% dc=im(1).lsm.DimensionChannels;
thresh=-1;
for sl=1:nl
    fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
    %     figure(fp+ch)
    hereiam=[ sl nl]
    if(~isfile(fno))
        im=tiffread29(fn,2*sl-1);
        rim=double(cell2mat(im.data(chan)));
        figure(1)
        if(nargin<3)
            [thresh,mask]=getMaskSl(rim,thresh);
        else
            vim=double(cell2mat(im.data(vchan)));
            [thresh,mask]=getMaskSl(rim,thresh,vim);
        end
        save(fno,'thresh','rim','mask');
        figure(2)
        patches=TileImage(mask,100,100,0);
        imagesc(mask), hold on
        PlotPatches(patches,1); hold off
        %         disp('press return to continue')
        %         pause
        save(fno,'patches','-append');
    else
        load(fno)
    end
end

function GetDataStdThreshRed(fn,redCh)

im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
% vals=NaN*zeros(nl*1e5,1);
c=1;
for sl=1:nl
    fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
    clear mask
    fno3=[fn(1:end-4) '_sl' int2str(sl) '_MaskRed.mat']
    load(fno)
    %     patches=TileImage(mask,100,100);
    %     save(fno,'patches','-append');
    if(isequal(mask,-1))
        save(fno3,'mask','nl');
        maxes(sl)=NaN;
        vals(sl).vs=[];
        %         save(fno3,'rim','mask','patches','nl');
    else
        hereiam=[ sl nl]
        im=tiffread29(fn,2*sl-1);
        rim=double(cell2mat(im.data(redCh)));
        vs=rim(:).*mask(:);
        vs=vs(vs>0);
%         l=length(vs);
%         if((c+l)>nl*1e5)
%             vals=[vals;vs];
%         else
%             vals(c:c+l-1)=vs;
%         end
%         c=c+l;
        vals(sl).vs=vs';
        maxes(sl)=max(vs);
        save(fno3,'rim','mask','patches','nl');
    end
end
mamax=max(maxes);
mmax=MyMyPrctile([vals.vs],99.99);
% vs=[vals.vs];
% vs=vs(~isnan(vs));
% s=sort(vs);
% ind=round(0.9999*length(vs));
% mmax=s(ind);
save([fn(1:end-4) '_MaxesRed.mat'],'redCh','vals','maxes','mamax','mmax');


function TextureSliceMasksRed(fn,chan,vchan)

load([fn(1:end-4) '_sl1_MaskRed.mat']);
% dc=im(1).lsm.DimensionChannels;
rthresh=10;
for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_MaskRed.mat'];
    %     figure(fp+ch)
    hereiam=[ sl nl]
    load(fno)
    %     if(~isfile(fno))
    %         im=tiffread29(fn,2*sl-1);
    if(mask~=-1)
        im2=rim.*mask;
        [mm,maxc]=max(sum(im2));
        [mm,maxr]=max(im2(:,maxc));
        figure(1)
        subplot(2,2,1)
        imagesc(im2)
        title('masked red channel')
        while 1
            tim=im2>rthresh;
            subplot(2,2,2)
            imagesc(tim)
            title('threshold')
            subplot(2,2,3)
            imagesc(tim.*im2)
            title('thresholded red')
            subplot(2,2,4)
            imagesc(tim.*im2)
            axis([maxc-75 maxc+75 maxr-75 maxr+75])
            title('thresholded red zoomed')

            inp=input(['enter threshold, currently ' int2str(rthresh) '. Return if ok:  ']);
            if(isempty(inp))
                save(fno,'rthresh','-append');
                break;
            elseif(inp<0)
                %         keyboard;
                rthresh=-1;
                tim=-1;
                break;
            else
                rthresh=inp;
            end;
        end
    end
end

function TextureSlicesRed(fn,opt)

im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
load([fn(1:end-4) '_MaxesRed.mat'])
thr=round(mamax/15);
for rthresh=thr%15%[5:5:25]
    outf=[fn(1:end-4) 'SliceDataSF_Hand_Red_ThAuto.mat']
    dat=[];
    figure(1)
    for sl=1:nl

        fno=[fn(1:end-4) '_sl' int2str(sl) '_MaskRed.mat'];
        hereiam=[sl nl]
        clear mask
        load(fno)
        if(isequal(mask,-1))
        else
            clear ptype strens patches
            patches=TileImage(mask,100,100);
            ar=[patches.area];
            goods=find(ar>10);%00);

            rim=rim.*mask;
            %         if(opt==1)
            %             rthresh=10;
            %         else
            %             rthresh=23;
            %         end
            tim=double((rim>rthresh).*mask);
            mim=rim.*tim;
            for j=goods
                p_im=rim(patches(j).rs,patches(j).cs);
                t_im=tim(patches(j).rs,patches(j).cs);
                m_im=mim(patches(j).rs,patches(j).cs);
                vec=p_im(:);
                vec=vec(vec>0);
                da.area=length(vec);
                if(da.area==0)
                    da.mean=0;
                    da.meds=[0 0 0];
                else
                    da.mean=mean(vec);
                    da.meds=MyMyPrctile(vec,[50 75 95]);
                end
                da.vec=vec';

                vec=m_im(:);
                vec=vec(vec>0);
                da.nover=length(vec);
                da.pcover=100*length(vec)/da.area;
                da.veco=vec';
                if(da.nover==0)
                    da.meanOver=0;
                    da.medsOver=[0 0 0];
                else
                    da.meanOver=mean(vec);
                    da.medsOver=MyMyPrctile(vec,[50 75 95]);
                end
                if 1
%                     load(['Classified\' fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat']);
                    load([fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat']);
                    da.ptype=ptype(j);
                    da.stren=strens(j);
                    % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
                    %                       % 0 means that the patch wasn't classified
                    %  classes=[-3:-1;3:-1:1;6:-1:4
                    if(ptype(j)==1)  % active
                        cs=-3:-1;
                        if(strens(j)==32)
                            strens(j)=3;
                        elseif(~ismember(strens(j),[1:3]))
                            keyboard
                        end
                        da.class=cs(strens(j));
                    elseif(ptype(j)==2) % inhibited
                        cs=3:-1:1;
                        if(~ismember(strens(j),1:3))
                            keyboard
                        end
                        da.class=cs(strens(j));
                    elseif(ptype(j)==3)  % mixed
                        cs=6:-1:4;
                        if(~ismember(strens(j),1:3))
                            keyboard
                        end
                        da.class=cs(strens(j));
                    elseif(ptype(j)==4)   % empty
                        da.class=0;
                    elseif(ptype(j)==5)   % unsure
                        da.class=10;
                    elseif(ptype(j)==0)   % not done
                        da.class=11;
                    end
                end
                dat=[dat da];
                %                     delete(h);
            end
            save(outf,'dat','rthresh')%,'goods','patches','goods')
        end
    end

    if 0
        figure(opt+rthresh)
    clas=[-3:6]% 10 11]
    for i=1:length(clas)
        is=find([dat.class]==clas(i));
        n(i)=length(is);
        mea(i)=mean([dat(is).mean]);
        md=[dat(is).meds];
        med(i)=mean(md(1:3:end));
        pc75(i)=mean(md(2:3:end));
        pc95(i)=mean(md(3:3:end));

        meao(i)=mean([dat(is).meanOver]);
        pco(i)=mean([dat(is).pcover]);
        md=[dat(is).medsOver];
        medo(i)=mean(md(1:3:end));
        pc75o(i)=mean(md(2:3:end));
        pc95o(i)=mean(md(3:3:end));

        [y,x1]=hist([dat(is).vec],0:255);
        y1(i,:)=y./sum(y);
        [y,x1]=hist([dat(is).veco],0:255);
        y2(i,:)=y./sum(y);
    end
    x=[-3:-1 9 1:3 5:7];
    subplot(3,2,1),bar(x,n),title('# patches in each class'),axis tight
    subplot(3,2,2),bar(x,[mea;med]'),title('mean/median red in each class'),axis tight
    subplot(3,2,3),bar(x,pco),title('% red over thresh in each class'),axis tight
    subplot(3,2,4),bar(x,[meao;medo]'),title('mean red over thresh in each class'),axis tight
    subplot(3,2,6),bar(x,[pc75;pc95]'),title('75/95 red in each class'),axis tight
    subplot(3,2,5),bar(x,[pc75o;pc95o]'),title('75/95 red over thresh in each class'),axis tight
    end
end

function PlotAllRedData(lsms,inds)

load temp_allreddata
PlotRedVals(da)

% for rthresh=15%[5:5:25]
%     da=[];
% %     for j=inds
% %         fn=char(lsms(j));
% % %         TextureSlicesRed(fn);
% % %         outf=[fn(1:end-4) 'SliceDataSF_Hand_Red_Th' int2str(rthresh) '.mat'];
% %         outf=[fn(1:end-4) 'SliceDataSF_Hand_Red_ThAuto.mat'];
% % %         load([fn(1:end-4) '_MaxesRed.mat'])
% %         load(outf)
% %         figure(j)%+rthresh)
% % %         allv=[vals.vs];
% % %         hist(allv(allv>0),[1:ceil(mamax/1000):mamax])%,xlim([0 mamax/2])
% %         if(j<=3)
% %             for i=1:length(dat)
% %                 dat(i).mean=dat(i).mean*256;
% %                 dat(i).meds=dat(i).meds*256;
% %             end
% % %             save([fn(1:end-4) 'SliceDataSF_Hand_Red_ThAutoAdj.mat'],'dat')
% %         end
% %         PlotRedVals(dat)
% %         da=[da dat]
% %     end
% %     save temp_allreddata da
%     load temp_allreddata 
%     figure(j+1)%+rthresh)
%     PlotRedVals(da)
% end

function PlotRedVals(dat)
% clas=[-3:6 10 11];
% pos=[-3:-1 9 1:3 5:7]
% clas=[-3:6];
% pos=[-3:-1 5 1:3 7:9]
clas=[-3:-1 1:6];
pos=[-3:-1 1:3 5:7]
v1s=[];
vos=[];
gr1s=[];
gros=[];
meas=[];gmeas=[];meds=[];gmeds=[];pcs=[];gpcs=[];
for i=1:length(clas)
    is=find([dat.class]==clas(i));
    n(i)=length(is);
    me=[dat(is).mean];
    mea(i)=mean(me);
    smea(i)=std(me);
    meas=[meas me];
    gmeas=[gmeas ones(size(me))*clas(i)];
    
    md=[dat(is).meds];
    me=md(1:3:end);
    med(i)=mean(me);
    smed(i)=std(me);
    meds=[meds me];
    gmeds=[gmeds ones(size(me))*clas(i)];

    pc75(i)=mean(md(2:3:end));
    pc95(i)=mean(md(3:3:end));

    meao(i)=mean([dat(is).meanOver]);
    pc=[dat(is).pcover];
    pco(i)=mean(pc);
    spco(i)=std(pc);
    pcs=[pcs pc];
    gpcs=[gpcs ones(size(pc))*clas(i)];
    
    md=[dat(is).medsOver];
    medo(i)=mean(md(1:3:end));
    pc75o(i)=mean(md(2:3:end));
    pc95o(i)=mean(md(3:3:end));

%     v1=[dat(is).vec];
%     vo=[dat(is).veco];
%     [y,x1]=hist(v1,0:255);
%     y1(i,:)=y./sum(y);
%     [y,x1]=hist(vo,0:255);
%     y2(i,:)=y./sum(y);
%     v1s=[v1s v1];
%     gr1s=[gr1s ones(size(v1))*clas(i)];
%     vos=[vos vo];
%     gros=[gros ones(size(vo))*clas(i)];
end
x=pos;%[-3:-1 9 1:3 5:7];
% subplot(4,2,1),bar(x,n),title('# patches in each class'),axis tight
% subplot(4,2,2),bar(x,[mea;med]'),title('mean/median red in each class'),axis tight
% subplot(4,2,3),bar(x,pco),title('% red over thresh in each class'),axis tight
% subplot(4,2,4),bar(x,[meao;medo]'),title('mean red over thresh in each class'),axis tight
% subplot(4,2,6),bar(x,[pc75;pc95]'),title('75/95 red in each class'),axis tight
% h=boxplot(meds,gmeds,'positions',pos(n>0));title('medians');
% subplot(4,2,5),bar(x,[pc75o;pc95o]'),title('75/95 red over thresh in each class'),axis tight
% subplot(4,2,8),%plot(x1,y2'),title('red frequency over thresh each class'),axis tight
% h=boxplot(meas,gmeas,'positions',pos(n>0));title('means');
% % h=boxplot(v1s,gr1s,'positions',pos(n>0));
% % set(h(7,:),'Visible','off'); ylim([0 max(pc75)*2])
% subplot(4,2,7),%plot(x1,y1'),title('red frequency each class'),axis tight
% h=boxplot(pcs,gpcs,'positions',pos(n>0));title('% over thresh');
% h=boxplot(vos,gros,'positions',pos(n>0));
% set(h(7,:),'Visible','off'); ylim([0 max(pc75o)*2])
% figure(11)
astrall2={'strong';'medium';'weak';'weak';'medium';'strong';'weak';'medium';'strong'};
ts=[];
figure(11),clf,bar(x,n),title('# patches in each class'),axis tight
figure(12),BarErrorBar(x',mea',smea'),title('mean red in each class'),axis tight
figure(13),BarErrorBar(x',med',smed'),title('median red in each class'),axis tight
figure(14),BarErrorBar(x',pco',spco'),title('% red over thresh in each class'),axis tight
figure(15),h=boxplot(meds,gmeds,'positions',pos(n>0));title('medians');
set(h(7,~isnan(h(7,:))),'Visible','off'); ylim([0 4200])
figure(16),h=boxplot(meas,gmeas,'positions',[-3:-1 1:3 6:8]); title('means');
set(h(7,~isnan(h(7,:))),'Visible','off'); ylim([0 6500])
SetXTicks(gca,[],[],[],[-3:-1 1:3 6:8],astrall2)
xlim([-4 4]);Setbox
saveas(gcf,[ts 'boxplots_Red_Means'], 'fig');
saveas(gcf,[ts 'boxplots_Red_Means'], 'bmp');
xlim([5 9]);Setbox
saveas(gcf,[ts 'boxplots_Red_Means_Mixed'], 'fig');
saveas(gcf,[ts 'boxplots_Red_Means_Mixed'], 'bmp');

figure(17),h=boxplot(pcs,gpcs,'positions',[-3:-1 1:3 6:8]);title('% over thresh');
set(h(7,~isnan(h(7,:))),'Visible','off'); ylim([0 50])
SetXTicks(gca,[],[],[],[-3:-1 1:3 6:8],astrall2)
xlim([-4 4]);Setbox
saveas(gcf,[ts 'boxplots_Red_pcover'], 'fig');
saveas(gcf,[ts 'boxplots_Red_pcover'], 'bmp');
xlim([5 9]);Setbox
saveas(gcf,[ts 'boxplots_Red_pcover_Mixed'], 'fig');
saveas(gcf,[ts 'boxplots_Red_pcover_Mixed'], 'bmp');





function TextureSlices(fn,opt)

im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
thresh=-1;
% thfs=[1.25 1.5 2 2.5 3 4];
% sfs=[1.5:0.2:2.5];
thfs=[1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25];
sfs=[1.75 2:.5:4];
if(opt==1)
    sfs=[1000:500:3000];
elseif(opt==2)
    load(['HandThresholds\' fn(1:end-4) '_StdThreshV3.mat']);
end

if(isequal(fn(1:3),'63X'))
    [vecadCh,vessCh]=deal(2,4);
elseif(isequal(fn(1:3),'11_C'))
    [vecadCh,vessCh]=deal(3,1);
elseif(isequal(fn(1),'D'))
    [vecadCh,vessCh]=deal(1,1);
else   % Zoomed2 stuff (dapt vs dmso)
    [vecadCh,vessCh]=deal(1,2);
end

for k=1%2:4
    %     outf=[fn(1:end-4) 'SliceDataTF' x2str(thfs(k)) 'SF' x2str(sfs(k)) 'V2.mat']
    if(opt==5)
        outf=[fn(1:end-4) 'SliceDataSF_Hand_Red.mat']
    else
        outf=[fn(1:end-4) 'SliceDataSF_Hand.mat']
    end
    dat=[];

    for sl=1:nl

        %         fno=[fn(1:end-4) '_data_sl' int2str(sl) '_Mask.mat'];
        fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
        %     figure(fp+ch)
        hereiam=[k sl nl]
        if(~isfile(fno))
            im=tiffread29(fn,2*sl-1);
            rim=double(cell2mat(im.data(vessCh)));
            [thresh,mask]=getMaskSl(rim,thresh);
            save(fno,'thresh','rim','mask');
            patches=TileImage(mask,100,100);
            save(fno,'patches','-append');
        else
            clear patches mask
            load(fno)
            %             if(~exist('patches'))
            patches=TileImage(mask,100,100);
            %                 save(fno,'patches','-append');
            %             end
            if(isequal(mask,-1))
                sth1_real(sl)=NaN;
                sth2_real(sl)=NaN;
            else
                clear ptype strens
                if(opt==2)
                    load(['Classified\' fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat']);
                end
                %                 gim=double(cell2mat(im.data(vecadCh)));
                gim=rim;
                mim=mask.*gim;
                if(opt==1)
                    th1=-1;  sth1=-1;
                    th2=-1;  sth2=-1;
                elseif(opt==2)
                    th1=-1;  sth1=-1;
                    th2=-1;  sth2=-1;
                    sfs(k)=sThreshes(sl);
                    [dum,sth1_real(sl),dum,sth2_real(sl)]=GetBackThresh(gim,mask);
                else
                    [th1,sth1,th2,sth2]=GetBackThresh(gim,mask);
                end
                ar=[patches.area];
                pc=[patches.pc];
                si=[patches.size];
                goods=find(ar>10);%00);
                %                 subplot(2,2,1)
                %                 imagesc(gim);
                %                 subplot(2,2,2)
                %                 imagesc(rim);
                %                 subplot(2,2,3)
                %                 imagesc(gim>th1);
                for j=goods
                    p_im=gim(patches(j).rs,patches(j).cs);
                    m_im=mask(patches(j).rs,patches(j).cs);
                    %                     figure(1)
                    %                     subplot(2,2,2)
                    %                     hold on;
                    %                     h=PlotPatches(patches(j),1);
                    %                     hold off
                    %                     subplot(2,2,4)
                    %                     imagesc(p_im);
                    %                     figure(2)
                    da=AnalysePatch(p_im,m_im,[th1 sth2],thfs(k),sfs(k),patches(j),0);
                    da.patnum=j;
                    da.fn_mask=fno;
                    da.fn_im=fn;
                    da.sl=sl;
                    da.th1=th1;
                    da.thf=thfs(k);
                    da.thf_s=sfs(k);
                    da.m_im=m_im;
                    da.p_im=p_im;
                    da.sl=sl;
                    da.th2=th2;
                    da.th1_s=sth1;
                    da.th2_s=sth2;
                    da.patch=patches(j);
                    if(ismember(opt,[2,5]))
                        da.ptype=ptype(j);
                        da.stren=strens(j);
                        % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
                        %                       % 0 means that the patch wasn't classified
                        %  classes=[-3:-1;3:-1:1;6:-1:4
                        if(ptype(j)==1)  % active
                            cs=-3:-1;
                            if(strens(j)==32)
                                strens(j)=3;
                            elseif(~ismember(strens(j),[1:3]))
                                keyboard
                            end
                            da.class=cs(strens(j));
                        elseif(ptype(j)==2) % inhibited
                            cs=3:-1:1;
                            da.class=cs(strens(j));
                        elseif(ptype(j)==3)  % mixed
                            cs=6:-1:4;
                            da.class=cs(strens(j));
                        elseif(ptype(j)==4)   % empty
                            da.class=0;
                        elseif(ptype(j)==5)   % unsure
                            da.class=10;
                        elseif(ptype(j)==0)   % not done
                            da.class=11;
                        end
                    end
                    dat=[dat da];
                    %                     delete(h);
                end
            end
            if(opt==2)
                save(outf,'dat','sThreshes','sth1_real','sth2_real')
            else
                save(outf,'dat')%,'goods','patches','goods')
            end
        end
        %     im=double(cell2mat(im.data(1)));
        %     th=1.2*median(im(:));
        %     tim=double(im>th);
        %     mim=mask.*im;
        %     subplot(2,2,1)
        %     imagesc(im);
        %     subplot(2,2,2)
        %     imagesc(tim);
        %     subplot(2,2,4)
        %     imagesc(mim.*tim);
    end
end

function[th1,sth1,th2,sth2]=GetBackThresh(gim,mask);
oppmim=(1-mask).*gim;
vopp=oppmim(:);
th1=1.2*median(vopp(vopp>0));
oppmim=(mask).*gim;
vopp=oppmim(:);
th2=1.2*median(vopp(vopp>0));

nh=ones(3);
sim=stdfilt(gim,nh);
oppmim=(1-mask).*sim;
vopp=oppmim(:);
sth1=median(vopp(vopp>0));
oppmim=(mask).*sim;
vopp=oppmim(:);
sth2=median(vopp(vopp>0));



function[maxims,s]=GetMaxGreenLevel(fn)
% fn='DAPT_1.lsm';
im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
dc=im(1).lsm.DimensionChannels;
ch=2;
fnl=[fn(1:end-4) '_data_' int2str(ch) 'AllSmall.mat'];
if(~isfile(fnl))
    allims=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX,nl);
    maxims=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX);
    % zs=zeros(im(1).lsm.DimensionY,im(1).lsm.DimensionX);
    for i=1:nl
        i
        im=tiffread29(fn,2*i-1);
        allims(:,:,i)=cell2mat(im(1).data(ch));%nim(:,:,ch);
        maxims=max(maxims,allims(:,:,i));
    end
    s=mean(allims,3);
    %     save(fnl);
    clear allims
    %     save([fnl(1:end-4) 'Small.mat'])
    save(fnl);
else
    load(fnl)
end


function[thresh,tim]=getMaskSl(im,thresh,vim)
if((nargin<1)||thresh<0)
    thresh=1.25*median(im(:));
end

smalls=100;
sigma=1;
opt=2;
if(nargin<3)
    [m,n,p,q]=deal(2,2,3,4);
else
    [m,n,p,q]=deal(2,3,4,5);
    subplot(m,n,3)
    imagesc(vim);
    title('vecad image')
end
subplot(m,n,1)
imagesc(im),title('original image')

while 1
    if(sigma>0)
        hsize=5*sigma;
        h = fspecial('gaussian', hsize, sigma);
        s_im=imfilter(im,h,'symmetric');
    else
        s_im=im;
    end

    bw=(s_im>thresh);
    if(smalls>0)
        bwclean=bwareaopen(bw,smalls,8);
    else
        bwclean=bw;
    end

    if(opt==-1)
        bw2=imfill(bwclean,'holes');
    elseif(opt==0)
        bw2=bwclean;
    elseif(opt==2)
        SE = strel('disk', 10);%round(opt/2));
        bw2=imclose(bwclean,SE);
    else
        SE = strel('square', round(opt/2));
        %         SE2 = strel('square', opt);
        bwclean=imopen(bwclean,SE);
        %         bw2=imclose(bwclean,SE2);
        bw2=imfill(bwclean,'holes');
    end
    clean_im=s_im.*double(bw2);
    [L,num] = bwlabeln(bw2);
    if(num==0)
        thresh=-1;
        tim=-1;
        break
    else
        s=regionprops(L,'Area');
        %         [maxi,ind]=max([s.Area]);
        %         tim=double(L==ind);
        inds=find([s.Area]>250);%1e3);
        tim=double(ismember(L,inds));
    end

    subplot(m,n,2)
    imagesc(bw),title('thresholded image')
    subplot(m,n,p)
    imagesc(clean_im),title('cleaned image')
    subplot(m,n,q)
    imagesc(tim),title('mask (objects>250 from above)')%title('mask (biggest object from above)')
    if(nargin>=3)
        subplot(m,n,6)
        [B] = bwboundaries(tim);
        imagesc(vim); hold on;
        for k=1:length(B),
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'w');%,'LineWidth',2);
        end
        hold off,
        title('masked vecads')
    end
    inp=input(['enter threshold, currently ' num2str(thresh) '. -1 if bad; Return if ok:  ']);
    if(isempty(inp))
        break;
    elseif(inp<0)
        %         keyboard;
        thresh=-1;
        tim=-1;
        break;
    else
        thresh=inp;
    end;
end

function[out]=AnalysePatch(im,mask,t1,t2f,sf,patch,pl,mnum,fnum,pnum,ca)

threshB=50;
threshM=10;
% mim=im.*mask;
m=4;
n=3;

v=im(:);
if(nargin<3)
    t1=median(v);
end
if(nargin<4)
    t2f=1.25;
end
if(nargin<5)
    sf=1.5;
end

t2=t2f*t1(1);
t1im=double(im>t1(1)).*mask;

% get objects based on thresholds
t2im=double(im>t2).*mask;
% [L,objIm,num,ar,isline,lineim,ecc]=GetObjects(t2im,im,threshB);
% out.n=num;
% out.L=L;
% out.isline=isline;
% out.bigs=find(ar>threshB);
% out.nbig=sum(ar>threshB);
% out.nline=length(isline);
% out.nmeds=sum(ar>threshM);
% out.ecc=ecc;

% get objects based on std filter
nh=ones(3);
sim=stdfilt(im,nh);
sim_mask=sim.*mask;
vsim=sim_mask(:);
if(length(t1)==2)
    if(t1(2)<0)
        s_lev=sf;
        sf=1;
    else
        s_lev=t1(2);
    end
else
    s_lev=median(vsim(vsim>0));
end
s2im=double(sim_mask>(sf*s_lev));
[L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(s2im,im,threshB);

out.s_lev=s_lev;
out.t1=t1;
out.sf=sf;
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

ninmask=sum(mask(:));
pc1=round(100*sum(t1im(:))/ninmask);
pc2=round(100*sum(t2im(:))/ninmask);
pcs=round(100*sum(s2im(:))/ninmask);
out.pct1=pc1;
out.pct2=pc2;
out.pcs=pcs;
out.area=ninmask;

% br=mean(v);
% brt=mean(v(v>t1));
% sim=double(rangefilt(im,nh));
% eim=entropyfilt(im,nh);
% subplot(m,n,5)
% imagesc(rim)
% subplot(m,n,5)
% % [me,med,iq,iqt]=texthist(im,t1im),axis tight
% subplot(m,n,6)
% [me,med,iqs,iqrs]=texthist(sim,t1im),axis tight

v_im=v.*mask(:);
out.g=MyMyPrctile(v_im(v_im>0),[50 25 75])';
out.g_std=MyMyPrctile(vsim(vsim>0),[50 25 75])';

noObj=(1-t2im).*mask;
vnoObj=noObj(:).*v;
out.backG=MyPrctile(vnoObj(vnoObj>0),[50 25 75])';

noObjBig=(1-imdilate(t2im,nh)).*mask;
vnoObj=noObjBig(:).*sim(:);
out.backStd=MyPrctile(vnoObj(vnoObj>0),[50 25 75])';

noObj_s=(1-s2im).*mask;
vnoObj_s=noObj_s(:).*vsim;
vnoObj_v=noObj_s(:).*v;
out.backStd_s=MyPrctile(vnoObj_s(vnoObj_s>0),[50 25 75])';
out.backG_s=MyPrctile(vnoObj_v(vnoObj_v>0),[50 25 75])';

if (pl==1)
    subplot(m,n,1)
    imagesc(im.*mask)
    vc=caxis;
    title(['raw, th ' num2str(t1) '; %over ' int2str(pc1)])
    subplot(m,n,2)
    imagesc(objIm)
    title(['# obj=' int2str([out.n out.nmeds out.nbig]) '; th ' num2str(t2) '; % over ' int2str(pc2)])
    subplot(m,n,3)
    imagesc(lineim)
    title(['# lines' int2str([out.nline])])

    subplot(m,n,4)
    imagesc(sim_mask)
    vc_s=caxis;
    title(['std, th ' num2str(s_lev)])
    subplot(m,n,5)
    imagesc(objIm_s)
    title(['# obj=' int2str([out.n_s out.nmeds_s out.nbig_s])  '; % over ' int2str(pcs)])
    subplot(m,n,6)
    imagesc(lineim_s)
    title(['# lines' int2str([out.nline_s])])

    subplot(m,n,7)
    imagesc(noObj.*im);
    caxis(vc);
    title(['Background G=' num2str([out.backG(1)]) ...
        '; s.d.=' num2str([out.backStd(1)])])
    %     subplot(m,n,8)
    %     imagesc(noObjBig.*sim);
    subplot(m,n,8)
    imagesc(noObj_s.*sim);
    caxis(vc_s);
    title(['Background Text=' num2str([out.backG_s(1)])])

    sol1=[L.Solidity];
    sol2=[L_s.Solidity];
    subplot(m,n,9)
    bar([sol1([out.bigs]) NaN NaN sol2([out.bigs_s])])
    title(['big obj Solidity'])

    subplot(m,n,12)
    bar([ecc([out.bigs]) NaN NaN ecc_s([out.bigs_s])])
    title(['big obj eccentricity'])
elseif(pl==2)
    n=4;
    rn=(fnum-1)*n;

    subplot(mnum,n,rn+1)
    imagesc(im.*mask)
    caxis(ca)
    title(['%=' int2str(pcs) '; G=' num2str([out.backG_s(1)],4) ...
        '; sd=' num2str([out.backStd_s(1)],4)])
    ylabel(['patch ' int2str(pnum)])
    %     axis off

    subplot(mnum,n,rn+2)
    imagesc(objIm_s+(objIm_s>0)*round(0.1*out.n_s))
    title(['# obj=' int2str([out.n_s out.nmeds_s out.nbig_s]) ...
        ';lines' int2str([out.nline_s])])
    %     axis off

    area=[L_s.Area];
    sol2=[L_s.Solidity];
    js=[out.meds_s];
    ks=[out.bigs_s];
    ls=[out.isline_s];
    %     subplot(mnum,n,rn+3)
    %     semilogx(area,sol2,'bx',area(ks),sol2(ks),'ro',...
    %         area(ls),sol2(ls),'gs')
    % %     xlabel('log(area)');ylabel('Solidity')
    %     title('Area v Solidity'),axis tight

    subplot(mnum,n,rn+3)
    semilogx(area(js),ecc_s(js),'bx',area(ks),ecc_s(ks),'ro',...
        area(ls),ecc_s(ls),'gs')
    %     xlabel('log(area)');ylabel('Eccentricity')
    title('Area v Eccent') ,axis tight

    subplot(mnum,n,rn+4)
    %     bar([out.wig_s NaN ecc_s(ks)])
    d=[[out.wig_s]' [out.l_s]' [ecc_s(ks)]']
    if(isempty(d)); d=NaN; end;
    bar(d)
    %     xlabel('log(area)');ylabel('Eccentricity')
    title('Wiggliness') ,axis tight

end
% plot([s.MajorAxisLength]./[s.MinorAxisLength],[s.Area]./[s.Perimeter],'o')

% subplot(m,n,8)
% [num,meanA,medA,ts]=getObjThresh(im,10);
% plot(ts,num);
% subplot(m,n,9)
% % plot(meanA(2:end)/(max(meanA(2:end))),'r:'...
% %     ,ts(2:end),medA(2:end)/(max(medA(2:end))),'k--')
% % plot(ts(2:end),meanA(2:end),'r:' ,
% plot(ts(2:end),medA(2:end),'k--')
% axis tight
% [maxi,ind]=max(num);
% t3im=im>ts(ind);
% pc2=round(100*sum(t3im(:))/length(t3im(:)));
% [maxm,ind2]=max(medA(ind:end));
% subplot(m,n,7)
% getObjThresh(im,10,ts(ind+ind2-1));
% out=[pc1 pc2 iq iqt iqs iqrs maxi maxm];



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


% subplot(m,n,9)
% [num,meanA,medA,ts]=getObjThresh(sim,4);
% plot(ts,num./max(num),ts(2:end),meanA(2:end)/(max(meanA(2:end))),'r:'...
%     ,ts(2:end),medA(2:end)/(max(medA(2:end))),'k--')
% axis tight


function[num,meanA,medianA,ts]=getObjThresh(im,small,ts)
v=im(:);
ra=max(v)-min(v);
st=min(ra/20,50);
if(nargin<3)
    ts=min(v):st:max(v);
    pl=0;
else
    pl=1;
end
for k=1:length(ts)
    tim=im>ts(k);
    if(small>0)
        bwclean=bwareaopen(tim,small,8);
    else
        bwclean=tim;
    end
    if(sum(bwclean(:)))
        bwclean=imfill(bwclean,'holes');
        [L,num(k)] = bwlabeln(bwclean);
        s=regionprops(L,'Area','Eccentricity');
        meanA(k)=mean([s.Area]);
        medianA(k)=median([s.Area]);
        if(pl)
            imagesc(L)
            title(num2str([num(k) meanA(k) medianA(k)]))
        end
    else
        ts=ts(1:k-1);
        break;
    end
end
[m,i]=max(num);


function[met,medt,iq,iqrn]=texthist(im,tim)
rtim=im.*tim;
vrtim=rtim(:);
[y,x]=hist(im(:),100);
nz=vrtim(vrtim>0);
[y2,x2]=hist(nz,100);
plot(x,y/sum(y),x2,y2/sum(y2),'r:')
met=mean(nz);
medt=median(nz);
iq=iqr(im(:));
iqrn=iqr(nz);
title(['me=' num2str(met) ', ' num2str(medt)])




function[d1,d2,d3,da]=GetPatches2
i=imread('DAPT_DMSO_representative2.tiff');
cs=250:1570;
rs=510:1300;
w=233;
% imagesc(i(:,:,3));
i=i(rs,cs,:);
s1=double(i(100,:,3));
s2=double(i(400,:,3));
s3=double(i(700,:,3));
s4=double(i(:,200,3));
r1=find(diff(s1)<0)+1;
r2=find(diff(s2)<0)+1;
r3=find(diff(s3)<0)+1;
c1=find(diff(s4)<0)+1;
e1=r1+w;
e2=r2+w
e3=r3+w
c2=c1+w;

c1s=c1(1):c2(1);
c2s=c1(2):c2(2);
c3s=c1(3):c2(3);
for j=1:length(r1)
    d1(j).dat=double(i(c1s,r1(j):e1(j),2));
end

for j=1:length(r2)
    d2(j).dat=double(i(c2s,r2(j):e2(j),2));
end

for j=1:length(r2)
    d3(j).dat=double(i(c3s,r3(j):e3(j),2));
end
da=[d1 d2 d3];


function[dp,dm]=GetPatches1
i=imread('DAPT_DMSO_representativ.tif');
s1=double(i(50,:,3));
s2=double(i(150,:,3));
s3=double(i(:,125,3));
r1=find(diff(s1)<0)+1;
r2=find(diff(s2)<0)+1;
c1=find(diff(s3)<0)+1;
e1=r1+69;
e2=r2+69
c2=c1+69;

c1s=c1(1):c2(1);
c2s=c1(2):c2(2);
for j=1:length(r1)
    dp(j).dat=double(i(c1s,r1(j):e1(j),2));
end

for j=1:length(r2)
    dm(j).dat=double(i(c2s,r2(j):e2(j),2));
end

function[patches]=TileImage(tim,ht,wid,pl)
patches=[];
if(isequal(tim,-1))
    return
end
if(nargin<4); pl=1; end;

rs=sum(tim,2);
r1=find(rs,1,'first');
r2=find(rs(r1:end),1,'last')+r1-1;
[sl_row1,sl_row2]=getsli(r1,r2,ht);
% sl_midrow=round(0.5*(sl_row1+sl_row2))
for i=1:length(sl_row1)
    ris=sl_row1(i):sl_row2(i);
    slim=tim(ris,:);
    patches=[patches GetSlbox(wid,slim,ris)];
end
% get rid of empty ones
patches=patches([patches.area]>0);
% plot them if plotting needed
if(pl)
    subplot(2,2,1)
    imagesc(tim)
    subplot(2,2,2)
    imagesc(tim), hold on
    PlotPatches(patches,1); hold off
end


function[h]=PlotPatches(p,t,col,t2)
if(isempty(p))
    h=[];
    return;
end

if(ishold)
    ho=1;
else
    ho=0;
end

if(nargin<3); col='w'; end;
if((nargin<2)||isempty(t)); t=0; end;
if((nargin<4)||isempty(t2)); t2=0; end;

for i=1:length(p)
    by(i,:)=[p(i).rs(1) p(i).rs(1) p(i).rs(end) p(i).rs(end) p(i).rs(1)];
    bx(i,:)=[p(i).cs(1) p(i).cs(end) p(i).cs(end) p(i).cs(1) p(i).cs(1)];
end
h=plot(bx',by',col);
if(~isequal(t,0))
    hs=[];
    hold on
    for i=1:length(p)
        if(length(t)==length(p))
            g=text(p(i).cs(1)+5,p(i).rs(end)-15,int2str(t(i)),'color',col(1));
        else
            g=text(p(i).cs(1)+5,p(i).rs(end)-15,int2str(i),'color',col(1));
        end
        hs=[hs;g];
    end
    h=[h;hs];
end
if(~isequal(t2,0))
    hs=[];
    hold on
    for i=1:length(p)
        if(~isempty(t2(i).s))
            g=text(p(i).cs(end)-15,p(i).rs(end)-15,t2(i).s,'color',col(1));
            hs=[hs;g];
        end
    end
    h=[h;hs];
end
if(~ho)
    hold off;
end


function[o,ninrow]=GetSlbox(w,slim,ris)
% get start and end columns of each object
rs=sum(slim,1);
d=diff(sign(rs));
cst=find(d==1)+1;
if(isempty(cst))
    cst=1;
end
cen=find(d==-1);
if(isempty(cen))
    cen=length(rs);
end
if(cen(1)<cst(1))
    cst=[1 cst];
end
if(cst(end)>cen(end))
    cen=[cen length(rs)];
end
% for each objects, make big objects if the gap is less than 50
c=1;
while(length(cen)>c)
    if((cst(c+1)-cen(c))<(w/2))
        cst=cst([1:c (c+2):end]);
        cen=cen([1:(c-1) (c+1):end]);
    else
        c=c+1;
    end
end
o=[];
%divide the objects into 100's
for j=1:length(cst)
    [c1,c2]=getsli(cst(j),cen(j),w);
    for i=1:length(c1)
        out(i).rs=ris;
        out(i).cs=c1(i):c2(i);
        v=slim(:,out(i).cs);
        v=v(:);
        out(i).size=length(v);
        out(i).area=sum(v>0);
        out(i).pc=out(i).area/out(i).size;
    end
    o=[o out];
    clear out;
end
ninrow=length(o);

function[sl_row1,sl_row2]=getsli(r1,r2,wid)
len=(r2-r1)+1;
nsl=max(1,round(len/wid));
for i=1:nsl
    sl_row1(i)=r1+(i-1)*wid;
end
sl_row2=sl_row1-1+wid;
sl_row2(end)=r2;

function FindLines(im,t)

% GetThreshold
while 1
    tim=im>t;
    bws = bwmorph(tim,'skel',Inf);
    bwt = bwmorph(tim,'thin',Inf);
    subplot(2,2,1)
    imagesc(im);
    subplot(2,2,2)
    imagesc(tim)
    subplot(2,2,3)
    imagesc(bws);
    subplot(2,2,4)
    imagesc(bwt);

    figure(2)
    [L,num] = bwlabeln(tim);
    s=regionprops(L,'Area','Eccentricity');

    t=input(['enter threshold, currently ' num2str(t) ':  ']);
    if(isempty(t))
        break;
    end
end

function[num,e,a]=ObjectThresh(im,t)
nim=sum(im(:)>0);
tim=double(im>t);
imagesc(tim);
if 1%(opt==1)
    bwclean=bwareaopen(tim,4,8);
    %     bw=imfill(bwclean,'holes');
    [L,num] = bwlabeln(tim);
    s=regionprops(L,'Area','Eccentricity');
end
% o.a=[s.Area]';
% o.e=[s.Eccentricity]';
% o.nim=nim;
a=[s.Area];
e=[s.Eccentricity]';




function[pim,mim,pt,mt,mpim,mmim]=getmask(dapt,dmso)
[pim,mpim,ypt,xpt,pt,pot]=threshim(dapt,1);
[mim,mmim,ymt,xmt,mt,mot]=threshim(dmso,1);
subplot(2,3,1)
imagesc(pim)
subplot(2,3,4)
imagesc(mim)
subplot(2,3,2)
imagesc(mpim)
subplot(2,3,5)
imagesc(mmim)
subplot(2,3,3)
plot(xpt,ypt/sum(ypt),xmt,ymt/sum(ymt),'r:');
axis tight;
subplot(2,3,6)
vals=[pot;mot];
grs=[ones(size(pot));ones(size(mot))*2];
h=boxplot(vals,grs,'positions',[1 2]);
set(h(7,:),'Visible','off')
SetXTicks(gca,[],[],[],[],{'DAPT';'DMSO'})
ylim([0 MyPrctile(vals,95)*1.1])


function show_ims(dapt,dmso,opt)
[pim,mpim,ypt,xpt,pt,pot]=threshim(dapt,opt);
[mim,mmim,ymt,xmt,mt,mot]=threshim(dmso,opt);
subplot(2,3,1)
imagesc(dapt)
subplot(2,3,4)
imagesc(dmso)
subplot(2,3,2)
imagesc(pim)
subplot(2,3,5)
imagesc(mim)
subplot(2,3,3)
plot(xpt,ypt/sum(ypt),xmt,ymt/sum(ymt),'r:');
axis tight;
subplot(2,3,6)
vals=[pot;mot];
grs=[ones(size(pot));ones(size(mot))*2];
h=boxplot(vals,grs,'positions',[1 2]);
set(h(7,:),'Visible','off')
SetXTicks(gca,[],[],[],[],{'DAPT';'DMSO'})
ylim([0 MyPrctile(vals,95)*1.1])

function[tim,im,yt,xt,t,vot]=threshim(im,opt)
if(opt==2)
    t=0;
else
    t=median(double(im(:)))*1.5;
end
tim=double(im>t);
if(opt==1)
    bwclean=bwareaopen(tim,500,8);
    bw=imfill(bwclean,'holes');
    [L,num] = bwlabeln(bw);
    s=regionprops(L,'Area');
    [m,ind]=max([s.Area]);
    tim=double(L==ind);
end
imagesc(im)
im=double(im).*tim;
vs=im(:);
vot=double(vs(vs>t));
n=max(min(floor(length(vot)/10),100),10);
[yt,xt]=hist(vot,n);

function[dapt,dmso]=GetImSlice(i1,i2)
dapts=dir('dapt*.lsm');
dmsos=dir('dmso*.lsm');
dapt=imread(daptl(i1).name);
dmso=imread(dmsol(i2).name);
dapt=dapt(:,:,2);
dmso=dmso(:,:,2);

function[dapt,dmso]=GetIm(i1,i2)
daptl=dir('dapt*.tif');
dmsol=dir('dmso*.tif');
dapt=imread(daptl(i1).name);
dmso=imread(dmsol(i2).name);
dapt=dapt(:,:,2);
dmso=dmso(:,:,2);
