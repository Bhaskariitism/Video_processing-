close all, clear all, clc;
originalImage = imread('lena.tif');
blockSize = 8;  
[numRows, numCols, ~] = size(originalImage);
%% Shuffling
blocks = mat2cell(originalImage, blockSize * ones(1, numRows/blockSize), blockSize * ones(1, numCols/blockSize), size(originalImage, 3));
flattenedBlocks = reshape(blocks, 1, []);
l = length(flattenedBlocks);
shuffledIndices = randperm(l);
shuffledBlocks = flattenedBlocks(shuffledIndices);
shuffledBlocksReshaped = reshape(shuffledBlocks, size(blocks));
shuffledImage = cell2mat(shuffledBlocksReshaped);
%% De-shuffilng
blocks_new = mat2cell(shuffledImage, blockSize * ones(1, numRows/blockSize), blockSize * ones(1, numCols/blockSize), size(shuffledImage, 3));
flattenedBlocks_new = reshape(blocks_new, 1, []);
re_shuffledBlocks(shuffledIndices) = flattenedBlocks_new;
re_shuffledBlocksReshaped = reshape(re_shuffledBlocks, size(blocks));
re_shuffledImage = cell2mat(re_shuffledBlocksReshaped);

figure;
subplot(1,3,1),imshow(originalImage);title('Original Image');
subplot(1,3,2),imshow(shuffledImage);title('Shuffled Image');
subplot(1,3,3),imshow(re_shuffledImage);title('Re-Shuffled Image');