function[nl]=GetNumSlices(fn,fnOpt)
if(fnOpt.type==2)
    % lsm
    im=tiffread29(fn,1);
    nl=im(1).lsm.DimensionZ;
elseif(ismember(fnOpt.type,[1 3]))
    % stacked tiff    
    info=imfinfo(fn);
    NumIms=length(info);
    if(fnOpt.type==1)
        nl=floor(NumIms/fnOpt.nChan);
    else
        nl=NumIms;
    end
else
    % single image in each file
    nl=1;
end