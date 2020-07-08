function[iq]= nanIqr(x,dim)

if nargin == 1
    y = prctile(x, [25,75]);
    iq=diff(y);
else
    y = prctile(x, [25,75],dim);
    iq=diff(y,[],dim);
end