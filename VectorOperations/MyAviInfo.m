function[dat,NFs]=MyAviInfo(ff,vObj)

fb=ff(1:end-4);
of=[fb '/AviFileData.mat'];

if(nargin<2)
    vObj=[];
end
   
if(~isempty(vObj))
    % this should be the correct option.
    % however, pparently the number of frames is an estimate (!) so could
    % be wrong. mmread is more correct but potentially could break in time
    % 2 solutions if necessary: do a 'try-catch' on reading last frames
    % backwards and forwards and/or do a 'try-catch on mmread
    dat=vObj;
    NFs=dat.NumberOfFrames;
    if(exist(ff,'file'))
        dat=mmread(ff,1);
        NFs=min(NFs,1-dat.nrFramesTotal);
    end
elseif(exist(ff,'file'))
    dat=mmread(ff,1);
    NFs=1-dat.nrFramesTotal;
else
    load(of)
    dat=[];
    NFs=nfr;
end
% NFs=round((dat.totalDuration)/0.04);