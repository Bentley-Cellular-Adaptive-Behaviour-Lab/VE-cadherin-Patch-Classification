function LSM_Images

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
% lsmlist6={'1_front.lsm';'1_internal.lsm';...
%     '2_front.lsm';'2_internal.lsm'};
lsmlist6={'5_K_M2B_VEcad_Baiap2_63X_1.lsm'};
out=GetResults(lsmlist6,1);
% out=GetResults;

meanall=out.mean_pc_all
stdall=out.std_pc_all
pcall=out.pctot_all

mean_nonmixed=out.mean_pc
std_nonmixed=out.std_pc
pcnonmixed=out.pctot


function[out]=GetResults(lsmlist,inds)
if(nargin<1)
    lsmlist=dir('*.lsm');
    inds=1:length(lsmlist);
end
% sfn={'1';'2';'3a';'4a'};
% cstrs={'unclassified';'active';'inhibited';'mixed';...
%     'empty';'unsure'};
figure(1)
np=length(inds);
pca=[];
pcanm=[];
sfa=[];
sfanm=[];
for k=1:np
    if(nargin<1)
        fn=char(lsmlist(k).name)
    else
        fn=char(lsmlist(inds(k)))
    end
    CheckTypeV2s(fn);
    [pcs,pcnm,sf,sfnm]=ResClassifyPatches(fn);
    pca=[pca;pcs];
    pcanm=[pcanm;pcnm];
    sfa=[sfa;sf];
    sfanm=[sfanm;sfnm];
    subplot(np,2,k*2-1)
    bar([-3:-1 1:3],pcnm)
    title([fn(1:end-4) '; not mixed'])
    subplot(np,2,k*2)
    bar([-3:-1 1:3 5:7],pcs)
    title([fn(1:end-4) '; all'])
end
out.mean_pc_all=mean(pca,1);
out.std_pc_all=std(pca,0,1);
out.mean_pc=mean(pcanm,1);
out.std_pc=std(pcanm,0,1);
s=sum(sfanm,1);
out.pctot=100*s(1:6)/sum(s(1:6));
s=sum(sfa,1);
out.pctot_all=100*s(1:9)/sum(s(1:9));
figure(2)
subplot(2,2,1)
bar([-3:-1 1:3],out.mean_pc)
title('mean %ages across lsms; mixed incorporated')
subplot(2,2,2)
bar([-3:-1 1:3 5:7],out.mean_pc_all)
title('mean %ages across lsms; all')
subplot(2,2,3)
bar([-3:-1 1:3],out.pctot)
title('total %age over lsms;  mixed incorporated')
subplot(2,2,4)
bar([-3:-1 1:3 5:7],out.pctot_all)
title('total %age over lsms; all')


function[pcs,pcnm,sf,sfnm]=ResClassifyPatches(fn)

slist=dir([fn(1:end-4) '_*_TypeV3.mat']);
load(slist(1).name);
freqs=[];
freqsnm=[];
freqsall=[];
allclasses=[];
for sl=1:length(slist)%nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_TypeV3.mat'];
    if(isfile(fno))
        load(fno)
        for j=1:length(ptype)
            classes(j).ptype=ptype(j);
            classes(j).stren=strens(j);

            % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
            % 0 means that the patch wasn't classified
            %  classes=[-3:-1;3:-1:1;6:-1:4
            % strength is 1:3 where 1=high, 2=med,  3=low and is used for
            % classes 1-3

            if(ptype(j)==1)  % active
                cs=-3:-1;
                classes(j).class=cs(strens(j));
            elseif(ptype(j)==2) % inhibited
                cs=3:-1:1;
                classes(j).class=cs(strens(j));
            elseif(ptype(j)==3)  % mixed
                cs=6:-1:4;
                classes(j).class=cs(strens(j));
            elseif(ptype(j)==4)   % empty
                classes(j).class=0;
            elseif(ptype(j)==-2)   % small ** classed empty in non-random version)
                classes(j).class=0;
            elseif(ptype(j)==5)   % unsure
                classes(j).class=7;
            elseif(ptype(j)==0)   % not done
                classes(j).class=8;
            else
                classes(j).class=0;
            end
        end
        [f,fnm,fa]=GetFreqs([classes.class]);
        freqs=[freqs;f];
        freqsnm=[freqsnm;fnm];
        freqsall=[freqsall;fa];
        allclasses=[allclasses classes];
        clear classes
    end
end
sf=sum(freqs,1);
pcs=100*sf(1:9)/sum(sf(1:9));
pcall=100*sf/sum(sf);
sfnm=sum(freqsnm,1);
pcnm=100*sfnm(1:6)/sum(sfnm(1:6));
fno=[fn(1:end-4) '_TypeV3_All.mat'];
save(fno,'freqs*','allclasses','pc*','sf','sfnm')


function[NewFs,NewFsNonMixed,Fs]=GetFreqs(cs)
Fs=Frequencies(cs,-3:8);
% get all the active mixed and inhibited
NewFs=Fs([1:3 5:10]);
% get all the empty and stick on the end
NewFs(10)=sum(Fs([4 11 12]));
% get the non mixed added in
NewFsNonMixed=NewFs([1:6 10]);
NewFsNonMixed(1:6)=NewFsNonMixed(1:6)+NewFs([9 8 7 7:9])*0.5;

function CheckTypeV2s(fn)

slist=dir([fn(1:end-4) '_*_TypeV2.mat']);
% fno=[fn(1:end-4) '_sl1_Mask.mat'];
% load(fno);
for sl=1:length(slist)%nl
%     fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    fnout=[fn(1:end-4) '_sl' int2str(sl) '_TypeV3.mat'];
    if(~isfile(fnout))
        disp(['Checking slice ' int2str(sl) ]);
%         load(fno)
%         if(~isequal(mask,-1))
            clear ptype strens
            %         fno2=['Classified\' fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
            fno2=[fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
%             load(fno2)
            load(slist(sl).name)
            for j=1:length(ptype)
                if(ismember(ptype(j),1:3))
                    while(~ismember(strens(j),1:3))
                        disp(['Current class is: ' int2str(ptype(j)) ', strength is: ' int2str(strens(j))])
                        strens(j)=input('enter strength, 1=high, 2=med,  3=low:  ');
                    end
                    p_str(j).s=num2str(strens(j));
                end
            end
            save(fnout,'ptype','strens','p_str')%,'nl');
%         end
    end
end

