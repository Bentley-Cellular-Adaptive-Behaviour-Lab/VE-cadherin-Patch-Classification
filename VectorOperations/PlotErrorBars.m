% function PlotErrorBars(DataValues, StdDevs, XLabels, Ylabel, PrintFontSize, PrintFontName, PrintFaceColour, PrintLineStyle, PrintLineWidth)
%
% Plots bar chart of data with errors (std deviation)
% Also plots title and x- and y-labels (requires XLabels as {'A' 'B' 'C'} list)
% Also plots correct fonts, and line styles/widths

function[BarHndls] = PlotErrorBars(DataValues, StdDevs, XLabels, Ylabel, PrintFontSize, PrintFontName, PrintFaceColour, PrintLineStyle, PrintLineWidth)

Width = 0.25;

BarHndls=bar(DataValues);
hold on;
grid on;

set(BarHndls, 'FaceColor', PrintFaceColour);
set(gca, 'FontSize', PrintFontSize);
set(gca, 'FontName', PrintFontName);
set(gca, 'XTickLabel', XLabels);
ylabel(Ylabel);

for i=1:length(DataValues)
   plot ([i, i], [DataValues(i),DataValues(i) + StdDevs(i)], PrintLineStyle, 'LineWidth', PrintLineWidth);
   plot ([i - Width/2, i + Width/2],[DataValues(i)+StdDevs(i),DataValues(i)+StdDevs(i)], PrintLineStyle, 'LineWidth', PrintLineWidth);
end

hold off;
