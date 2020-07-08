function[RealLastFrame,lastIm,vobj]=GetLastFrame(fn,vobj,RealLastFrame,lmn)
% lastFr=lastFr-5;

if((nargin<2)||isempty(vobj))
    [~,vobj]=VideoReaderType(fn);
end
if((nargin<3)||isempty(RealLastFrame))
    [~,RealLastFrame]=MyAviInfo(fn);
end
while 1
    try
        lastIm=MyAviRead(fn,RealLastFrame,vobj);
    catch ME
        lastIm=[];
    end
    if(isempty(lastIm))
        RealLastFrame=RealLastFrame-1;
    else
        % next read the last but one frame and see if it is the same
        if(RealLastFrame==1)
            break;
        else
            try
                tmpIm=MyAviRead(fn,RealLastFrame-1,vobj);
            catch ME
                tmpIm=[];
            end
            if(isequal(tmpIm,lastIm))
                RealLastFrame=RealLastFrame-1;
            elseif(isempty(tmpIm))
                RealLastFrame=RealLastFrame-2;
            else
                break
            end
        end
    end
end
if(nargin>3)
    % this shows it's been checked
    if(exist(lmn,'file'))
        save(lmn,'RealLastFrame','-append');
    else
        save(lmn,'RealLastFrame');
    end
end
