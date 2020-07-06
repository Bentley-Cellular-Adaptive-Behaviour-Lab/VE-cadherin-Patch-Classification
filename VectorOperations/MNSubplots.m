% function[m,n]=MNSubplots(nPl,nInCol)
%
% Given a number of plots to plot nPl and the maximum number in any column
% this function returns the correct number of subplots in m and n
% USAGE
% 
% nInCol = 3;
% [m,n]=MNSubplots(nPl,nInCol)
% for i=1:nPl
%     subplot(m,n,i)
%     plot(rand(1,10),rand(1,10))
% end

function[m,n]=MNSubplots(nPl,nInCol)

m=min(nInCol,nPl);
n=ceil(nPl/m);