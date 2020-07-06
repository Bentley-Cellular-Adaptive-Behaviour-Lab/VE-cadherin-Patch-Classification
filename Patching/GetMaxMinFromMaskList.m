% this function gets the maximum and minimum value across sets of mask
% files in flist
% 
% it saves the max and the min across vecad channel and also across coloc 
% (if it exists) in the mask files and also returns them as variables
function[mamax,mimin,colmax,colmin]=GetMaxMinFromMaskList(flist)

amins=[];
amaxs=[];
cmins=[];
cmaxs=[];
iscol=zeros(1,length(flist));
for i=1:length(flist)
    clear colim;
    load(flist(i).name);
    if(~isequal(mask,-1))
        amins=[amins mmin];
        amaxs=[amaxs mmax];

        if(~isempty(colim))
            iscol(i)=1;
            % this is the way max is done for the main channel
            % not sure this is the way it should be done for the
            % colocalised images. Need to check
%             vals=mask.*colim;
%             vals=vals(:);
%             vals=vals(vals>0);
%             s=sort(vals);
%             ind=round(0.9999*length(vals));
%             mmax=s(ind);
            v=colim(:);
            cmins=[cmins min(v)];
            cmaxs=[cmaxs max(v)];
        end
    end
end
mamax=max(amaxs);
mimin=min(amins);
colmax=max(cmaxs);
colmin=min(cmins);
for i=1:length(flist)
    if(iscol(i))
        save(flist(i).name,'mamax','mimin','colmax','colmin','-append');
    else
        save(flist(i).name,'mamax','mimin','-append');
    end
end