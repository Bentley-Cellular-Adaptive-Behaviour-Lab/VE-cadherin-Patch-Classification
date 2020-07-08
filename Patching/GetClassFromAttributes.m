% this function takes a list of patches from a slice and given whether it 
% is active or inhibited etc and the strength outputs a class label as used
% in Reconstruct_Images.m
% 
% it takes the filename of the hand classified patch and the patch area
% It also updates the patch attributes and it
% returns both the clas and the updated patch

function[clas,ptype,stren]=GetClassFromAttributes(fn,are,strens)

% if it's got 3 variables set it from a non file
if(nargin>2)
    ptype=fn;
% check if the file with class data exists. If not, enter NaNs and ouput a
% warning
elseif(~isfile(fn))
    disp(['Patch ' fn ' has not been classified; Set class to NaN'])
    ptype=NaN;
    stren=NaN;
    clas=NaN;
    return;
else
    % load the hand classified file. it contains the type
    % of patch type of patch in ptype, the strength in strens
    load(fn)
end
% if is not a small one
% this is not currently needed as a file isn;t generated if it's under
% 10 in area but I leave it in for illustration
if(are>10)
    
    % update the patch attributes with type and strength
    ptype=ptype;
    stren=strens;
    
    % 1=active; 2=inhibited; 3=mixed; 4=empty; 5=not sure
    % 0 means that the patch wasn't classified
    %  classes=[-3:-1;3:-1:1;6:-1:4
    % strength is 1:3 where 1=high, 2=med,  3=low and is used for
    % classes 1-3. Have to average for the mixed
    if(ptype==1)  % active
        cs=-3:-1;
        clas=cs(strens);
    elseif(ptype==2) % inhibited
        cs=3:-1:1;
        clas=cs(strens);
    elseif(ptype==3)  % mixed
        cs=6:-1:4;
        % if it's mixed, in the new version this does an average of the
        % strengths of the inhibited and active. In the old version it just
        % does the strength. However other options are aobviously possible
        clas=cs(round(mean(strens)));
    elseif(ptype==4)   % empty
        clas=0;
    elseif(ptype==5)   % unsure
        clas=7;
    elseif(ptype==0)   % not done
        clas=8;
    else
        clas=8;
    end
else
    % small classed as empty
    ptype=-2;
    stren=0;
    clas=0;
end