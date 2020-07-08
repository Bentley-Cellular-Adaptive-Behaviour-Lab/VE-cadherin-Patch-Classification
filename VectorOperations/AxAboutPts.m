function[AxX]=AxAboutPts(pts,w)
mi=min(pts);
ma=max(pts);
AxX=[mi(1)-w ma(1)+w mi(2)-w ma(2)+w];
axis(AxX);