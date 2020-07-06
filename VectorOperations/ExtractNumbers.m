% function[nums,inds]=ExtractNumbers(s)
%
% function ti get numbers from strings
%
% nums is the numbers in the string
% inds is a 2xlength(nums) column vector holding 
% start and end of the number
%
% NEEDS DEBUGGING to sort out special cases (-ve, i, j etc)

function[nums,inds]=ExtractNumbers(s)

ls=length(s);
ce=1;
cs=1;
n=1;
nums=[];
inds=[];
wasnum=0;
while(ce<=ls)
    is=cs:ce;
    sn=str2double(s(is));
    if(~isequal(s(is(end)),'i')&&~isequal(s(is(end)),'j')&&~isnan(sn))
        % if it's a number, store it and try to add the next char to it
        nums(n)=sn;
        inds(n,:)=[cs ce];
        ce=ce+1;
        wasnum=1;
    elseif((cs==ce)&&isequal(s(is),'.'))
        % if it's a . but hasn't any preceding numbers, check the next char
        ce=ce+1;
        wasnum=0;
    else
        % if it's not a number, but last was, store and move on else start
        % again
        if(wasnum)
            n=n+1;
            % if there's been a space before a number: NEEDS DEBUGGING!!!
            if(~isnan(s(ce)))
                ce=ce-1;
            end
        end
        wasnum=0;
        cs=ce+1;
        ce=cs;
    end
end