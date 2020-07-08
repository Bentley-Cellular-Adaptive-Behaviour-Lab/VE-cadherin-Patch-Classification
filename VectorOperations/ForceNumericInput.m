% function[n]=ForceNumericInput(str,notempty,vallen,vals)
%
% function uses input but forces the user to put a numeric value or vector
%
% if notempty =1 (default 0) make sure input is not empty
% 
% % vallen (default 0) specifies how long the vector should be ie 
% if vallen =1 make sure input is a single value not a vector
% if it is 0 or empty then don't specify the length
% 
% if vals is used (default not, ie vals =[]) the input must be a 
% single number and a member of vals which is a vector. Thus if vals is
% specified,  notempty=1 and vallen = 1 
% 
% only issue is what to do about i/j ie imaginary; currently not a number

function[n]=ForceNumericInput(str,notempty,vallen,vals)

if(nargin<2)
    notempty=0;
end
if((nargin<3)||isempty(vallen))
    vallen=0;
end
if(nargin<4)
    vals=[];
elseif(~isempty(vals))
    vallen=1;
end

vstrs={'enter single numbers only';['enter a vector with ' int2str(vallen) ' elements']};

while 1
    s=input(str,'s');
    if(isempty(s))
        if(notempty==1)
            disp('empty input not accepted')
        else
            n=[];
            break;
        end
    elseif(isequal(s,'i'))
        disp('letter i not accepted')
        % ignore i
    elseif(isequal(s,'j'))
        disp('letter j not accepted')
        % ignore i
    else
        n=str2num(s);
        if(isempty(n))
            if(vallen) 
                disp(char(vstrs(min(vallen,2))));
            else
                disp('enter numbers vectors/matrices only eg 1, 1:3, [1 4], [1;7]')
            end
        else
            if(vallen) 
                sz=size(n);
                if(isequal(sz,vallen)||((sz(1)==vallen)&&(sz(2)==1))||((sz(2)==vallen)&&(sz(1)==1)))
                    if(isempty(vals))
                        break;
                    elseif(ismember(n,vals))
                        break;
                    else
                        if(length(vals)<10)
                            disp(['number not a member of ' num2str(vals)])
                        else
                            disp('number not a valid option')
                        end
                    end
                else
                    disp(char(vstrs(min(vallen,2))));
                end
            else
                break;
            end
        end
    end
end