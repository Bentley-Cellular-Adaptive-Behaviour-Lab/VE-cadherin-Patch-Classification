function renameFilesKate2

% if(~isdir('HandClassified'))
%     mkdir('HandClassified')
% end
% str='HandClassified\';
flist=dir([str '*HandClassRnd.mat']);
for i=1:length(flist)
    fn=flist(i).name;
    load(fn);
    if(isequal(fn(1),'1'))
        save(['ctrl' fn],'ptype','strens','p_str')
    elseif(isequal(fn(1),'2'))
        save(['ctrl' fn],'ptype','strens','p_str')
    end
%     cd HandClassified
%     save(fn((length(str)+1):end),'ptype','strens','p_str');
%     cd ..
end