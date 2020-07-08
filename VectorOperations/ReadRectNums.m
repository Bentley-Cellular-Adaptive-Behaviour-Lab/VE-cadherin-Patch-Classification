function[x]=ReadRectNums(fn,TopLeft,BottRight,MSize)
if(nargin<2) TopLeft=[1,1]; end    
if(nargin<3) BottRight=[-1,-1]; end
if(nargin<4) x=[]; else x=zeros(MSize); end;

r1=TopLeft(1);c1=TopLeft(2);
r2=BottRight(1);c2=BottRight(2);

% open file
if(~isfile(fn)) 
    disp('File not found. Fool')
    x=[];
    return;
else
    [fid,msg]=fopen(fn);
    if(fid==-1) 
        disp(msg);
        x=[];
        return;
    end;
end

% skip 1st r-1 rows
for i=1:r1-1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
end

% if r2 defined then read rows r1:r2 otherwise go to end of file
if(r1<=r2) 
    for i=r1:r2
        if(mod(i,100)==0) disp(['Reading line ' int2str(i)]); end;
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        Nums = str2num(tline);
        
        % if c2 defined, put in selected columns, otherwise take all
        if(nargin<4)
            if(c2>=c1) x=[x;Nums(c1:c2)]; 
            else x=[x;Nums(c1:end)]; 
            end
        else
            if(c2>=c1) x(i-r1+1,:)=Nums(c1:c2); 
            else x(i-r1+1,:)=Nums(c1:end); 
            end
        end
    end
else
    i=1;
    while 1
        if(mod(i,100)==0) disp(['Reading line ' int2str(i)]); end;
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        Nums = str2num(tline);
        % if c2 defined, put in selected columns, otherwise take all
        if(nargin<4)
            if(c2>=c1) x=[x;Nums(c1:c2)]; 
            else x=[x;Nums(c1:end)]; 
            end
        else
            if(c2>=c1) x(i,:)=Nums(c1:c2); 
            else x(i,:)=Nums(c1:end); 
            end
        end
        i=i+1;
    end
end
fclose(fid);