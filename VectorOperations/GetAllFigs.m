%------------------------------------------------
function h = GetAllFigs%(closeForce, closeAll, closeHidden)
% Copied from safegetchildren from 'close'
% 
% find all the figure children off root and filter out handles that
% based on application data or handle visibility.
% if closeHidden || closeForce
%     h = allchild(0);
%     if ~closeAll && ~isempty(h)
%         h = h(1);
%     end
% elseif closeAll
%     h = get(0,'Children');
% else
%     h = get(0,'CurrentFigure');
% end

h = get(0,'Children');
if isempty(h)
    return;
end

specialTags = {
    'SFCHART', ...
    'DEFAULT_SFCHART', ...
    'SFEXPLR', ...
    'SF_DEBUGGER', ...
    'SF_SAFEHOUSE', ...
    'SF_SNR', ...
    'SIMULINK_SIMSCOPE_FIGURE'
    };
filterFigs = [];
for j = 1:length(specialTags)
    filterFigs = [filterFigs; findobj(h,'flat','tag',specialTags{j})]; %#ok
end
h = setdiff(h,filterFigs);

% If any of these figs have IgnoreCloseAll set to 1, they would
% override closeAll only. If it is set to 2, they would override
% closeAll and closeForce.

% IgnoreCloseAll  []      1        2
% closeAll      close   filter   filter
% closeHidden   close   filter   filter
% closeForce    close   close    filter
filterFigs = [];
for i =1:length(h)
    if ~isappdata(h(i), 'IgnoreCloseAll');
        continue;
    end
    ignoreFlag = getappdata(h(i), 'IgnoreCloseAll');
    if isempty(ignoreFlag) || ~isscalar(ignoreFlag) || ~isnumeric(ignoreFlag)
        warning('MATLAB:close','Unrecognized value for IgnoreCloseAll - valid values are 1 or 2')
        continue;
    end
    switch ignoreFlag
        case 2
            filterFigs = [filterFigs; h(i)]; %#ok
        case 1
            if ~closeForce
                filterFigs = [filterFigs; h(i)]; %#ok
            end
        otherwise
            warning('MATLAB:close','Unrecognized value for IgnoreCloseAll - valid values are 1 or 2')
            % do nothing - unrecognized app data
    end
end
h = setdiff(h,filterFigs);