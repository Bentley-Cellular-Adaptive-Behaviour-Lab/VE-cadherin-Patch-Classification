% function[maxv]=MaxVecFilter(v)
% 
% function which starts at the beginning of the vector v but makes v = to
% the last highest value if v goes down. Might be srt of 1d watershed
function[maxv]=MaxVecFilter(v)
maxv=v;
for i=2:length(v)
    if(v(i)<maxv(i-1))
        maxv(i)=maxv(i-1);
    end
end