function[f, Deld] = DeleteFileIsFile(fns,fn)
Deld=0;
f=fns;
for i=1:size(fns,1)
    if(strcmp(deblank(fns(i,:)),fn))
        f=[fns(1:i-1,:);fns(i+1:end,:)];
        Deld=1;
        fprintf('file %s deleted; \n',fn);
        return;
    end
end
