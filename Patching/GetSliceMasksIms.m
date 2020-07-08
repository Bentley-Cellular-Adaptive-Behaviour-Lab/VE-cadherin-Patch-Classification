% this function takes a list of filenames fnlist and then generates the masks
% it first asks the user to input the mask channel and the classification
% channel, which it retyrns as outputs
%
% In the original functions it replaces the functions TexturePatches and
% TextureSliceMasks
function[maskchan,claschan]=GetSliceMasksIms(fnlist,SizeParams)

% if it's a tiff, check whether it's a stack or not
fnOpt=CheckFileType(fnlist(1).name);

% read in the image from the first file
% this function is just to show you what one might do as a general version
[im,nChan]=SliceReadIm(fnlist(1).name,fnOpt);

% plot all the channels:
clf
for i=1:nChan
    subplot(ceil(nChan/2),2,i)
    imagesc(im(:,:,i))
    axis equal
    axis tight
    title(['channel ' int2str(i)])
end

% get the user to input the mask channel
maskchan=ForceNumericInput(['enter the mask channel, max ' ...
    int2str(nChan) ': '],1,1,1:nChan);
subplot(ceil(nChan/2),2,maskchan)
title(['mask channel is ' int2str(maskchan)])

% get the user to input the mask channel
claschan=ForceNumericInput(['enter the channel to classify on, max ' ...
    int2str(nChan) ': '],1,1,1:nChan);
subplot(ceil(nChan/2),2,claschan)
title(['channel to classify is ' int2str(claschan)])

% get the user to input the colocalised channel
inp=ForceNumericInput('do you want a colocalised channel? 1=yes; return no: ',0,1);
if(isequal(inp,1))
    colchan=ForceNumericInput(['enter colocalised channel, max ' ...
        int2str(nChan) ': '],1,1,1:nChan);
    subplot(ceil(nChan/2),2,colchan)
    title(['colocalised channel is ' int2str(colchan)])
else
    colchan=0;
end

% now use these inputs to get the masks from all the files in fnlist
TextureSliceMasksIm(fnlist,maskchan,claschan,colchan,fnOpt,SizeParams)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this function makes individual files for each patch to make the patching
% process compatible with random presentation of images as in
% TextureAnalysisTiff
%
% it takes a mask, the vessel image, the collocalised image
% the patches and a filename

function OutputPatchesAsData(mask,vim,patches,fn,colim,params)
% if the slice/image is bad return
if(isequal(mask,-1))
    return
end
%
for patchnum=1:length(patches)
    % output file name
    fno=[fn(1:end-4) '_Patch' int2str(patchnum) '.mat'];
    
    % get the patch of the mask and the original image
    pat=patches(patchnum);
    im_patch=vim(pat.rs,pat.cs);
    mask_patch=mask(pat.rs,pat.cs);
    
    % check if a colocalised image is needed and save the data
    if(isempty(colim))
        col_patch=[];
    else
        col_patch=colim(pat.rs,pat.cs);
    end
    save(fno,'mask_patch','im_patch','col_patch','patchnum','pat','params');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this is the overall function which reads in images from each file in fnlist
% gets the mask from the data in maskchan, then patches the data in
% claschan and the colocalised channel colchan if this is not 0
%
% there is an lsm version of this too, TextureSliceMasksLSM
% It does the same but goes through each slice in the LSM
% I think they could both be combined if one was clever than me!

function TextureSliceMasksIm(fnlist,maskchan,claschan,colchan,fnOpt,SizeParams)

% this sets the patch size: should be set via the gui.
patchsize=SizeParams.PatchSize; %should be 100 as in NCB 2014

% sets how many files there are to be done
nFile=length(fnlist);

% This sets an inital threshold value as a negative so the function knows it
% hasn't been done before. The reason for this was more to do with masking
% LSMs as once a threshold was set for one slice, it was likely that it
% could be used for the next slice so I wanted to keep using the previous
% thresh value. This probably won't be the case for a list of files though
% there's usually some relation between files named similar things so we'll
% go with it and see what happens
thresh=-1;

% go through each file.
for i=1:nFile
    
    % get the filename
    fn=char(fnlist(i).name);
    
    % get the number of slices based on the different filetypes
    nl=GetNumSlices(fn,fnOpt);
    for sl=1:nl
        
        % this has been generalised as some files have only one image 
        % while LSMs and stacked tiffs have multiple
        if(fnOpt.type==0)
            fno=[fn(1:end-4) '_Mask.mat']
            fn2=fn; 
        else
            fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
            fn2=[fn(1:end-4) '_sl' int2str(sl) '.mat']; 
            % keeping this in for future debugging
            %         TextureSliceMasksLSM(fn,maskchan,claschan,colchan,patchsize)
        end
        
        % check if the Mask file exists: ie this file has already been
        % processed; if it hasn't generate a new mask
        % this allows the user to stop doing the masking half way through
        if(~isfile(fno))
            
            % read in the image file and get the data from maskchan rim and
            % the data from claschan vim
            im=SliceReadIm(fn,fnOpt,sl);
            rim=double(im(:,:,maskchan));
            vim=double(im(:,:,claschan));
            % do the colocalised channel if it is needed
            if(colchan>0)
                colim=double(im(:,:,colchan));
            else
                colim=[];
            end
            figure(1)
            
            % get the threshold and mask for this image
            [thresh,mask,params]=getMaskSl(rim,thresh,vim);
            
            % Now patch the image and plot the mask and patches in another figure
            figure(2)
            clf
            % this makes the patches
            patches=TileImage(mask,patchsize,patchsize,0);
            imagesc(mask)
            hold on
            % this plots the patches
            PlotPatches(patches,1);
            hold off
            
            %    Get the maximum and minimum for the slice. This is used
            %    for plotting the patches
            vals=mask.*vim;
            vals=vals(:);
            vals=vals(vals>0);
            s=sort(vals);
            ind=round(0.9999*length(vals));
            if(isempty(vals))
                mmax=0;
                mmin=0;
            else
                mmax=s(ind);
                mmin=min(vim(:));
            end
            
            % tidy the params
            params.maskchan=maskchan;
            params.claschan=claschan;
            params.colchan=colchan;
            
            % save the thresholds, the data and the patches
            save(fno,'nl','thresh','rim','vim','colim','mask','patches',...
                'maskchan','claschan','colchan','mmin','mmax','params');
            
            % Now output each patch as a file
            OutputPatchesAsData(mask,vim,patches,fn2,colim,params);
        else
            % if the mask file does exist load the threshold from it
            % As stated earlier, this was more for the lsm version
            % but could work here too
            disp(['file ' fno ' already exists; delete it to redo'])
            load(fno,'thresh')
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the LSM version of the function above. I leave it in here to show
% the difference but is currently not used. It might also need some 
% updating if the above version has changed a lot
function TextureSliceMasksLSM(fn,maskchan,claschan,colchan,patchsize,fnOpt)

im=tiffread29(fn,1);
nl=im(1).lsm.DimensionZ;
thresh=-1;
for sl=1:nl
    fno=[fn(1:end-4) '_sl' int2str(sl) '_Mask.mat'];
    
    if(~isfile(fno))
        % read in the image file and get the data from maskchan rim and
        % the data from claschan vim
        im=SliceReadIm(fn,fnOpt,sl);
        rim=double(im(:,:,maskchan));
        vim=double(im(:,:,claschan));
        % do the colocalised channel if it is needed
        if(colchan>0)
            colim=double(im(:,:,colchan));
        else
            colim=[];
        end
        
        figure(1)
        [thresh,mask,params]=getMaskSl(rim,thresh,vim);
        figure(2)
        patches=TileImage(mask,patchsize,patchsize,0);
        imagesc(mask);
        hold on
        PlotPatches(patches,1);
        hold off
        
        %    Get the maximum and minimum for the slice. This is used
        %    for plotting the patches
        vals=mask.*vim;
        vals=vals(:);
        vals=vals(vals>0);
        s=sort(vals);
        ind=round(0.9999*length(vals));
        mmax=s(ind);
        mmin=min(vim(:));
        
        % tidy the params
        params.maskchan=maskchan;
        params.claschan=claschan;
        params.colchan=colchan;
        % save the thresholds, the data and the patches
        save(fno,'nl','thresh','rim','vim','colim','mask','patches',...
            'mmin','mmax','params');
        
        % Now output each patch as a file
        fn2=[fn(1:end-4) '_sl' int2str(sl) '.mat'];
        OutputPatchesAsData(mask,vim,patches,fn2,colim,params);
    else
        % if the mask file does exist load the threshold from it
        % As stated earlier, this works best for the lsm/stacked version
        load(fno,'thresh')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the one that does the actual threshold picking
% it takes inputs:
%
% im: a  matrix which is the data to mask on
%
% thresh: initial threshold value. this is optional but usually used
% if  left out or < 0  it estimates a threshold
%
% vim: a matrix with data to be classified so you can check the mask output
% this is also optional but usually used.
%
% it returns the threshold value used, thresh, the mask, tim, and image
% processing parameters in params

function[thresh,tim,params]=getMaskSl(im,thresh,vim)

% estimate a threshold based on the bacground if thresh left out or < 0
if((nargin<2)||thresh<0)
    thresh=1.25*median(im(:));
end

% these area a variety of image parameters used to get the mask
% I hand-coded these but they should be paramters entered in the GUI
% they are also saved to the mask so that we have a record of parameters

% the order of image processing is:
% 1. Smooth the image (using params.sigma)
% 2. Threshold (using thresh)
% 3. Remove noise (using params.smalls)
% 4. re-Smooth the image more 'cleverly' (using params.opt)
% 5. Make  mask from either biggest object, or all with area > small_obj_size

% 1. How much to smooth. if 0, no smoothing. could be on a slider
params.sigma=5;

% 3. Objects smaller than this will be removed as noise. This is done
% before the 'cleverer' smoothing. It could be overkill given we have
% step 5 and small_obj_size but there is a subtle difference between them
% this could be on a slider
params.smalls=100;

% 4. 'Clever' re-smooth. see stage 4 below for the different options
% we tended to use option 2
params.opt=2;

% if this is 1, the mask is only the biggest object
params.only_biggest_obj=0;

% objects smaller than this area will be removed from the image unless
% only_biggest_obj=1 in which case the largest object is retained
% this could be on a slider
params.small_obj_size=250;

% this sets up the image output windows depending on whather you also want
% to show the vessel image
if(nargin<3)
    [m,n,p,q]=deal(2,2,3,4);
else
    [m,n,p,q]=deal(2,3,4,5);
    subplot(m,n,3)
    imagesc(vim);
    title('image to be patched')
end
% show the original image
subplot(m,n,1)
imagesc(im),
title('original image')

while 1
    % 1.  gaussian smoothing
    if((params.sigma)>0)
        h = fspecial('gaussian', params.sigma, params.sigma);
        s_im=imfilter(im,h,'symmetric');
    else
        s_im=im;
    end
    
    % 2. threshold the image
    bw=(s_im>thresh);
    
    % 3. get rid of small objects
    if(params.smalls>0)
        bwclean=bwareaopen(bw,params.smalls,8);
    else
        bwclean=bw;
    end
    
    % 4 do a cleverer smoothing
    if(params.opt==-1)
        % fill in 'holes' in the objects
        bw2=imfill(bwclean,'holes');
    elseif(params.opt==0)
        % leave as is
        bw2=bwclean;
    elseif(params.opt==2)
        % peform morphological closure with a disk shaped mask
        % this was the one I generally used if mask=vessel image
        SE = strel('disk', 10);
        bw2=imclose(bwclean,SE);
    else
        % peform morphological opening with a square mask then fill holes
        % various other things tried here
        SE = strel('square', round(params.opt/2));
        %         SE2 = strel('square', opt);
        bwclean=imopen(bwclean,SE);
        %         bw2=imclose(bwclean,SE2);
        bw2=imfill(bwclean,'holes');
    end
    
    % recreate the masked image smoothed image and get all the objects
    clean_im=s_im.*double(bw2);
    [L,num] = bwlabeln(bw2);
    
    
    % 5. Remove the smaller objects and set the mask, tim
    %
    % This also checks there are  over-threshold points in the mask
    % if not set no_obj_flag=1 which makes the user enter a lower threshold
    if(num>0)
        
        % get areas of all the objects
        s=regionprops(L,'Area');
        
        % either take the largest object in the mask
        % or take all objects over a certain size
        if(params.only_biggest_obj==1)
            [maxi,ind]=max([s.Area]);
            tim=double(L==ind);
        else
            inds=find([s.Area]>(params.small_obj_size));%1e3);
            tim=double(ismember(L,inds));
        end
        no_obj_flag=0;
    else
        % if no above threshold flags display a warning and set a flag
        disp('NO OVER THRESHOLD POINTS IN MASK')
        disp('ENTER LOWER THRESHOLD OR -1')
        tim=double(L);
        no_obj_flag=1;
    end
    
    % plot the various images
    subplot(m,n,2)
    imagesc(bw),title('thresholded image')
    subplot(m,n,p)
    imagesc(clean_im),title('cleaned image')
    subplot(m,n,q)
    imagesc(tim)
    if((params.only_biggest_obj)==1)
        title('mask (biggest object from im above)')
    else
        title(['mask (objects>' int2str(params.small_obj_size) ' from im above)'])
    end
    
    % if showing patched channel plot it and object boundaries
    if(nargin>=3)
        subplot(m,n,6)
        [B] = bwboundaries(tim);
        imagesc(vim); hold on;
        for k=1:length(B),
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'w');%,'LineWidth',2);
        end
        hold off,
        title('masked image to be patched')
    end
    
    % get user to enter the threshold value
    disp(['Threshold is currently set to ' ...
        num2str(thresh) ])
    disp('Press return if ok')
    disp('Or enter a new threshold value')
    inp=ForceNumericInput(['Or enter -1 to ignore this slice:'],0,1);
    
    if(isempty(inp))
        % if return is pressed and there are no objects in the mask
        if(no_obj_flag~=1)
            break;
        end
    elseif(inp==-1)
        % if return is pressed and there are objects in the mask
        thresh=-1;
        tim=-1;
        break;
    else
        % else set the new threshold
        thresh=inp;
    end;
end
params.thresh=thresh;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this function is a stab at a general function that can read either an
% lsm or a tiff or whatever. This could be based on the file extension
% or it could be based on the number of input arguments. I've gone for the
% former
%
% the idea is that it reads an image from file fn
% it then returns the image in im, the number of channels in nChan and
% some flag filetype which could be used later.
%
% As the lsms contain multiple slices, it needs a sceond argument sl
% However, I'm still not entirely sure we can do something entirely general
% but you get the idea
function[im,nChan,fnOpt]=SliceReadIm(fn,fnOpt,sl)

% if no slice is specified, get the middle one
if(nargin<3)
    nsl=GetNumSlices(fn,fnOpt);
    sl=round(0.5*nsl);
end

% Check what file type it is
% if it's not a 1 (stacked tiffs) check the extension
if(fnOpt.type==1)
    nChan=fnOpt.nChan;
    info=imfinfo(fn);
    im=zeros(info(1).Height,info(1).Width,nChan);
    for i=1:nChan
        im(:,:,i)=imread(fn,(sl-1)*nChan+i);
    end
    im=double(im);
elseif(fnOpt.type==3)
    im=imread(fn,sl);
    im=double(im);
    nChan=size(im,3);
    
elseif(fnOpt.type==2)
    
    % Read in the sl'th slice bearing in mind that only every other one is
    % actually data
    im=tiffread29(fn,2*sl-1);
    % from this read in the channels
    % currently just reads the 1st channel as the MyCell2mat would need
    % some debugging to get all the channels
    [im,nChan]=MyCell2mat(im);
    
else
    % read in an image file and make it into a double (saves hassle
    % elsewhere)
    im=double(imread(fn));
    nChan=size(im,3);
end
fnOpt.nChan=nChan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this is another helper function which was needed because when I read in
% some lsms they were in cells, and in some they were not ... Much fun
%
% Currently this takes a slice im read from tiffread29, and outputs the
% data in channel chan
%
% It needs updating to return a matrix with all the channels
% it also needs debugging to make sure nchan will work
function[rim,nchan] = MyCell2mat(im)

% check if it's a cell. If so, read it as a cell or, if not, as a matrix
if(iscell(im.data))
    nchan=size(im.data,2);
    for i=1:nchan
        rim(:,:,i)=double(cell2mat(im.data(i)));
    end
else
    % hthis should work but needs to be checked
    rim=double(im.data);%(:,:,chan));
    nchan=size(im.data,3);
end

