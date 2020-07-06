function renameFilesKate

if(~isdir('HandClassified'))
    mkdir('HandClassified')
end
str='HandClassified\';
flist=dir([str '*HandClassRnd.mat']);
for i=1:length(flist)
    fn=flist(i).name;
    load(fn);
    cd HandClassified
    save(fn((length(str)+1):end),'ptype','strens','p_str');
    cd ..
end