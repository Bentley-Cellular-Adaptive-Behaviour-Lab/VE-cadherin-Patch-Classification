% from https://docs.openmicroscopy.org/bio-formats/5.7.1/developers/matlab-dev.html

% data = bfopen('/path/to/data/file');

% This function returns an n-by-4 cell array, where n is the number of series in the dataset. If s is the series index between 1 and n:
% 
% The data{s, 1} element is an m-by-2 cell array, where m is the number of planes in the s-th series. If t is the plane index between 1 and m:
% The data{s, 1}{t, 1} element contains the pixel data for the t-th plane in the s-th series.
% The data{s, 1}{t, 2} element contains the label for the t-th plane in the s-th series.
% The data{s, 2} element contains original metadata key/value pairs that apply to the s-th series.
% The data{s, 3} element contains color lookup tables for each plane in the s-th series.
% The data{s, 4} element contains a standardized OME metadata structure, which is the same regardless of the input file format, and contains common metadata values such as physical pixel sizes - see OME metadata below for examples.

% seriesCount = size(data, 1);
% series1 = data{1, 1};
% series2 = data{2, 1};
% series3 = data{3, 1};
% metadataList = data{1, 2};
% % etc
% series1_planeCount = size(series1, 1);
% series1_plane1 = series1{1, 1};
% series1_label1 = series1{1, 2};
% series1_plane2 = series1{2, 1};
% series1_label2 = series1{2, 2};
% series1_plane3 = series1{3, 1};
% series1_label3 = series1{3, 2};
% 
% series1_colorMaps = data{1, 3};
% figure('Name', series1_label1);
% if (isempty(series1_colorMaps{1}))
%   colormap(gray);
% else
%   colormap(series1_colorMaps{1}(1,:));
% end
% imagesc(series1_plane1);

% my stuff
data = bfopen('Ctl_2_mouse_2b_8tile.czi');
series1 = data{4, 1};
series1_planeCount = size(series1, 1);
series1_label1 = series1{1, 2}
nChan=str2double(series1_label1(end))
nSl=round(series1_planeCount/nChan);

cmaps=series1_colorMaps(1,:);
% for i=1:3
%     cmap(i).cmap=cell2mat(cmaps{i});
% end

for j=1:nChan
    maxproj(j).max=zeros(size(im));
    maxproj(j).sum=zeros(size(im));
end
for i=1:nSl
    sp=nChan*(i-1);
    for j=1:nChan
        sln=sp+j;
        im = double(series1{sln, 1}); 
        maxproj(j).max=max(maxproj(j).max,im);
        maxproj(j).sum=maxproj(j).sum+im;
        figure(13)
        subplot(2,2,j)
        imagesc(maxproj(j).max)
        axis equal
        colormap(cmaps{sln})
        title(['slice ' int2str(i) ', channel ' int2str(j)])
        figure(14)
        subplot(2,2,j)
        imagesc(maxproj(j).sum)
        axis equal
        colormap(cmaps{sln})
        title(['slice ' int2str(i) ', channel ' int2str(j)])
    end
%         pause
end