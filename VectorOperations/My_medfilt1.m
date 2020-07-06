% function[mx]=My_medfilt1(x,len,padopt)
% 
% my version of medfilt1 which uses medfilt2
% see help medfilt 2 for options but it meidan filters x with a mdian
% filter of length len returning the output in mx
% padopt sets the padding. it assumes symmetric padding if no input
% help mdefilt2 for options
% if x is a matrix you should really use medfilt2 so it ggives a wraning 
% and then applies a 1xlen filter to each row (ie medfilt2(x[1,len])
% 
% USAGE:
% median filtering witha length 3 with symetric padding
% mx = My_medfilt1(x,3) 

function[mx]=My_medfilt1(x,len,padopt)
if(nargin<3)
    padopt='symmetric';
end

[h,w]=size(x);
filt=[1,len];
if(min([h,w])==1)
    if(w==1)
        filt=[len,1];
    end
else
    disp('**not a vector**')
    disp(['applying a 1x' int2str(len) ' filter to each row'])
    disp('ie as medfilt2 (which should be used instead')
end
mx=medfilt2(x,filt,padopt);