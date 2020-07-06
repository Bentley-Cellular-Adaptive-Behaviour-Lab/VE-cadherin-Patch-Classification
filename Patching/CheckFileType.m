%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [FileOpt]=CheckFileType(fn)
% 
% This gets the filetype
%
% if it's an lsm   FileOpt.type=3; 
%
% if it's individual images in single files  FileOpt.type=1;
%
% if it's a stacked tif where there's only one channel per frame
% FileOpt.type=1 and you need to specify the number of channels which is
% stored in FileOpt.nChan
% 
% if it's a stacked tif where each frame has many channels
% FileOpt.type=3, number of channels FileOpt.nChan is set automatically
% 
% for the other types, FileOpt.nChan=-1;
% 
% if it's a tif it prompts you to check it's ok

function[fnOpt]=CheckFileType(fn)
outf=[fn(1:end-4) 'FileType.mat'];
if(exist(outf,'file'))
    load(outf);
    fstrs={'individual images';'stacked tif with one channel/frame'; ...
        'lsm stack';'stacked tif with several channels/frame'};
    s1=char(fstrs(fnOpt.type+1));
    %TODO: the below line was printing out files processed as individual images with -1channels
%     disp(['files processed as ' s1 ' with ' int2str(fnOpt.nChan) 'channels'])
    return
end

if(isequal(fn((end-2):end),'tif'))
    in=imfinfo(fn);
    disp(' ')
    if(length(in)>1)
        fnOpt.type=1;
        disp('Files will be processed as stacks of images.')
    else
        fnOpt.type=0;
        disp('Files will be processed as individual images.')
    end
    
    % check if this is ok
    inp=ForceNumericInput('Press return if this is ok or 0 to process as stacks of images: ',0,1);
    if(isequal(inp,0))
        fnOpt.type=mod(fnOpt.type+1,2);
    end
        
    % enter the number of channels
    if(fnOpt.type==1)
        im=imread(fn,1);
        if(size(im,3)==1)
            disp(' ')
            disp('Only 1 channel in each frame. RETURN if this is ok')
            disp('if different channels are in subsequent tiff frames') 
            nch=ForceNumericInput('enter number of channels: ',0,1);
            disp(' ')
            if(isempty(nch))
                fnOpt.type=3;
                fnOpt.nChan=size(im,3);
            else
                fnOpt.nChan=nch;
            end
        else
            fnOpt.type=3;
            fnOpt.nChan=size(im,3);
        end 
    else
        fnOpt.nChan=-1;
    end
    
elseif(isequal(fn((end-2):end),'lsm'))
    % it;s an lsm type file
    % nChan = -1 means numbre of channels will be derived from the file
    fnOpt.type=2;
    fnOpt.nChan=-1;
else
    % default is to have each slice in one file
    fnOpt.type=0;
    fnOpt.nChan=-1;
end
save(outf,'fnOpt')
