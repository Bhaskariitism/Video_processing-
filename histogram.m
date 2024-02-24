% Load an RGB image
a = imread('F:\Third Work_video\I-frames-virat\Iframe11.jpg');
numBars = size(a, 1) * size(a, 2);
randomColors = rand(numBars, 3);
h = bar3(a(:,:,1));
for i = 1:length(h)
    set(h(i), 'FaceColor', randomColors(i, :));
end
set(h,'EdgeColor', 'none');
title('Original I-frame')
axis([0 260 0 260 0 300]);
set(gca, 'xlabel', text('String', 'x', 'FontSize', 12));
set(gca, 'ylabel', text('String', 'y', 'FontSize', 12));
set(gca, 'zlabel', text('String', 'P(x,y)', 'FontSize', 12));