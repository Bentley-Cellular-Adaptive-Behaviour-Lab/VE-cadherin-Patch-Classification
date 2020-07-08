% function[im]=MyAviRead(ff,i,vObj)
%
% function returns frame i from filename ff
% it defaults to using mmread. However, it can be made to use aviread (for
% speed: think aviread is a bit quicker but haven't checked recently if
% nf=1 and if line 9 is changed

function[im]=MyAviRead(ff,i,vObj)
if(nargin==3)
    if(isequal(vObj,3))
        % force it to use mmread
        k=mmread(ff,i);
        if(isempty(k.frames))
            im=[];
        else
            im=k.frames.cdata;
        end
    elseif(~isempty(vObj))
        im = read(vObj, i);
    else
        fb=ff(1:end-4);
        of=[fb '/' fb 'Fr' int2str(i) '.mat'];
        if(isfile(of))
            load(of)
        else
            if(~exist(ff,'file'))
                disp(['File ' ff ' not found']);
                im=[];
            else
                k=mmread(ff,i);
                if(isempty(k.frames))
                    im=[];
                else
                    im=k.frames.cdata;
                end
            end
        end
    end
else
    fb=ff(1:end-4);
    of=[fb '/' fb 'Fr' int2str(i) '.mat'];
    if(isfile(of))
        load(of)
    else
        k=mmread(ff,i);
        im=k.frames.cdata;
    end
end