% this get's the objects and various properties. Not entirely sure im is
% needed but it was in AutoClassifyLSM.m so I've kept it in
function[out]=AnalysePatchIm(threshim,im,SizeParams,out)

threshB=SizeParams.BigObject;  
threshM=SizeParams.MedObject;

v_im=threshim(:);
% get objects based on thresholds or std filter
[L_s,objIm_s,num_s,ar_s,isline_s,lineim_s,ecc_s]=GetObjects(threshim,im,SizeParams);
% out.s_lev=s_lev;
% out.t1=t1;
% out.sf=sf;
out.g=MyPrctile(v_im(v_im>0),[50 25 75])';
out.n_s=num_s;
out.L_s=L_s;
out.isline_s=isline_s;
out.bigs_s=find(ar_s>threshB);
out.nbig_s=sum(ar_s>threshB);
out.nline_s=length(isline_s);
out.nmeds_s=sum(ar_s>threshM);
out.meds_s=find(ar_s>threshM);
out.ecc_s=ecc_s;
[out.wig_s,out.l_s,out.wid_s]=objWiggliness(objIm_s,L_s,out.bigs_s);

function[s,L,num,ar,isline,lineim,ecc]=GetObjects(t2im,im,SizeParams)
  
[L,num] = bwlabeln(t2im);
s=regionprops(L,im,'Area','Eccentricity',...
    'MajorAxisLength','MinorAxisLength',...
    'Perimeter','MeanIntensity','Solidity','Orientation');
minax=[s.MinorAxisLength];
majax=[s.MajorAxisLength];
meanint=[s.MeanIntensity];
ecc=[s.MajorAxisLength]./minax;
per=2*([s.MajorAxisLength]+minax);
ar=[s.Area];
arovlength=ar./majax;
sol=[s.Solidity];

isline=find((ecc>SizeParams.IsLine)&([s.Area]>SizeParams.BigObject));
lineim=zeros(size(im));
for j=1:length(isline)
    lineim=lineim+double(L==isline(j))*j;
end

function[w,l,mw]=objWiggliness(im,S,is)
w=[];
l=[];
mw=[];
for i=1:length(is)
    num=is(i);
    nim=(im==num);
    [w(i),l(i),mw(i)]=Wiggliness(nim,S(num).Orientation);
end

function[w,l,mw] = Wiggliness(im,ang)
newim=imrotate(im,90-ang);
rs=sum(newim,2);
r1=find(rs,1,'first');
r2=find(rs(r1:end),1,'last')+r1-1;
rows=r1:r2;
for i=1:length(rows)
    wid(i)=sum(newim(rows(i),:));
end
w=iqr(wid);
l=std(wid);%r2-r1+1;
mw=median(wid);
