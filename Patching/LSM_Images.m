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
MakeImages(lsmlist6,1,1)


function MakeImages(lsmlist,inds,opt)
for i=inds
    fn=char(lsmlist(i));

    if(opt==-1)
        AssignClassToPatch(fn,-1);
%     elseif(opt==2)
%         ClassifyPatches(fn,2);
    else
        CheckTypeV2s(fn)
        AssignClassToPatch(fn);
    end
end

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

function AssignClassToPatch(fn)

[cmap,cmapw]=ColMap;
fno=[fn(1:end-4) '_sl1_Mask.mat'];
load(fno);
cim=-1;
for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    fnout=[fn(1:end-4) '_sl' int2str(sl) '_ColIm.mat'];
    imout=[fn(1:end-4) '_Im_sl_' int2str(sl) '.tiff'];
    load(fno)
    if(isequal(mask,-1))
        save(fnout,'cim','nl');
    else
%         fno2=['Classified\' fn(1:end-4) '_sl' int2str(sl) '_TypeV2.mat'];
        fno2=[fn(1:end-4) '_sl' int2str(sl) '_TypeV3.mat'];
        load(fno2)
        for j=1:length(patches)
            patches(j).ptype=ptype(j);
            patches(j).stren=strens(j);
            
            % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
            % 0 means that the patch wasn't classified
            %  classes=[-3:-1;3:-1:1;6:-1:4
            % strength is 1:3 where 1=high, 2=med,  3=low and is used for
            % classes 1-3
            
            if(ptype(j)==1)  % active
                cs=-3:-1;
                patches(j).class=cs(strens(j));
            elseif(ptype(j)==2) % inhibited
                cs=3:-1:1;
                patches(j).class=cs(strens(j));
            elseif(ptype(j)==3)  % mixed
                cs=6:-1:4;
                patches(j).class=cs(strens(j));
            elseif(ptype(j)==4)   % empty
                patches(j).class=0;
            elseif(ptype(j)==-2)   % small ** classed empty in non-random version)
                patches(j).class=0;
            elseif(ptype(j)==5)   % unsure
                patches(j).class=7;
            elseif(ptype(j)==0)   % not done
                patches(j).class=8;
            else
                patches(j).class=8;                
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
        subplot(2,2,1),figure(1)
        imagesc(cim);
        caxis([-3 8]), colormap(cmapw)
        subplot(2,2,2),
        imagesc(vim)
        caxis([-3 8]),colormap(cmapw)
        subplot(2,2,3),
        imagesc(rim>thl)
        subplot(2,2,4),
        imagesc(rim)
%         inp=input(['slice ' int2str(sl) '/' int2str(nl) '; threshold = return to continue']);
        disp(['slice ' int2str(sl) '/' int2str(nl) '; return to continue']);
        pause;
        clf;
        imagesc(vim)
        caxis([-3 8]),colormap(cmapw)
        axis equal;
        axis off;
        set(gca,'Position',[0 0 1 1],'Box','off','TickLength',[0 0])
        print(imout,'-dtiffn');
        save(fnout,'rim','cmap','cmapw','cim','patches','nl','vim','thl');
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