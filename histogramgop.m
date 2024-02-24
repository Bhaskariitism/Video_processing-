% Load an image
directoryPath = './Testvideo data/';
files = dir(fullfile(directoryPath, '*I*.jpg'));
outputDirectory = './output_figures2/';

% Create the output directory if it doesn't exist
if ~exist(outputDirectory, 'dir')
    mkdir(outputDirectory);
end
for i = 191:200
    filePath = fullfile(directoryPath, files(i).name);
    image = imread(filePath);
    % Convert the image to grayscale if it's a color image
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    
    % Calculate the histogram
    histValues = imhist(image);
    
    % Plot the histogram
    figure;
    bar(histValues, 'FaceColor', 'blue');
    xlabel('Pixel Value');
    ylabel('Frequency');
    title('Enrypted frame Histogram');
    
    % Display the plot
    grid on;
    pdfFileName = sprintf('Histogram_Image_%d.jpg', i);
    pdfFilePath = fullfile(outputDirectory, pdfFileName);
    saveas(gcf, pdfFilePath, 'jpg');
    
    % Close the figure
    close(gcf);
end