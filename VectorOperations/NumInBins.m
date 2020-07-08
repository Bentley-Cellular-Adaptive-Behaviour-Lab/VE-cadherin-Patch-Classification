function[FilledBins,Bins]=NumInBins(a,b,NumBins,Values)

Bins=a:(b-a)/(NumBins-2):b
FilledBins(1)=NumInRange(Values,-inf,a);
for i=2:NumBins-1
   FilledBins(i)=NumInRange(Values,Bins(i-1),Bins(i));
end
FilledBins(NumBins)=NumInRange(Values,b,inf);