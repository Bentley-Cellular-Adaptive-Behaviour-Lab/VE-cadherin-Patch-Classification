% this function is a helper function which gets round the issue of the lsms
% being in slices and having a filename per slice while the images do not
% 
% given an flist it checks if it's an lsm then returns a list of all the
% slices with a .mat at the end of them. It also returns a flag saying if
% it's an lsm file or not
%
% if randflag=1 then randomise the order within the lsm
function[flist,lsmflag]=GetLsmSliceMaskList(fl,randflag,flnonrand)

fnOpt=CheckFileType(flnonrand(1).name);

% if it's an lsm then get the list for each slice. 
if(ismember(fnOpt.type,[1:3]))
    lsmflag=1;
    flist=[];
    for i=1:length(fl)
        fn=fl(i).name(1:end-4);
        out=dir([fn '_sl*Mask.mat']);
        % randomise the order within the lsm if randflag is selected but  
        if(randflag)
            out=out(randperm(length(out)));
        end
        flist=[flist;out];
    end
    % get rid of the _Mask from the filenames
    for i=1:length(flist)
        flist(i).name=flist(i).name([1:end-9 end-3:end]);
        % use this if I want to include the overall filename.
        % should do but can't be bothered to debug now
%         fn_nomask=flist(i).name([1:end-9 end-3:end]);
%         flist(i).name=fn_nomask;
    end    
else
    flist=fl;
    lsmflag=0;
%     imflist=fl;
%     sliceNum=zeros(1,length(flist));
end