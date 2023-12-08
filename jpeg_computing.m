function [ ratio ] = jpeg_computing( input_image, q)
n = 8; % size of blocks
dim1 = size(input_image,1); % image width
dim2 = size(input_image,2); % image height
dim3 = size(input_image,3); % number of channels
if (dim3 > 1)
    ycbcrmap = rgb2ycbcr(im2double(input_image)); % mapping, need double for DCT
else
    ycbcrmap = im2double(input_image);
end
% here you can (should) also paste downsampling of chroma components
output_image = zeros(size(input_image), 'double');
compressed_vector = 0;
[qY, qC] = get_quantization(q); % get quantization matrices
T = dctmtx(n); % DCT matrix
scale = 255; % need because DCT values of YCbCr are too small to be quantized
% Block processing functions
dct = @(block_struct) T * block_struct.data * T';
invdct = @(block_struct) T' * block_struct.data * T;
quantY = @(block_struct) round( block_struct.data./qY);
dequantY = @(block_struct) block_struct.data.*qY;
quantC = @(block_struct) round( block_struct.data./qC);
dequantC = @(block_struct) block_struct.data.*qC;
entropy_proc = @(block_struct) entropy_cod(block_struct.data, n);
%---------------------------
for ch=1:dim3
    % encoding ---------------------------
    channel = ycbcrmap(:,:,ch); % get channel
    % compute scaled forward DCT
    channel_dct = blockproc(channel, [n n], dct, 'PadPartialBlocks', true).*scale; 
    % quantization
    if (ch == 1)
        channel_q = blockproc(channel_dct,[n n], quantY);  % quantization for luma
    else
        channel_q = blockproc(channel_dct,[n n], quantC);  % quantization for colors
    end
    entropy_out = blockproc(channel_q,[n n], entropy_proc); % compute entropy code for the whole channel
    entropy_code = get_entropy(entropy_out, n, dim1, dim2); % get entropy code without zeros on the end
    %print(entropy_code)
    [comp, dict] = huffman_cod(entropy_code); % huffman encoding
    
    cc=comp'
    disp(cc)
    l = length(comp);
    compressed_vector = cat(1, compressed_vector, comp); % add to output

    %disp('entropy_code');
    %disp(entropy_code);
    disp(l);
    seq = randperm(l);
    new_comp = comp(seq);
    [new_comp, dict1] = huffman_cod(entropy_code);
    %% Reorder compress vector

    % [row, col] = size(compressed_vector);
    % disp("-------------------------------->")
    % disp(row)
    % disp(col)
    % seq = randperm(row);
    % 
    % shuffled_comp_vector = compressed_vector(seq);

    %% Reorder comp

    %[row1, col1] = size(comp);
    %seq1 = randperm(row1);

    %shuffled_comp = comp(seq1);

    
    % decoding ---------------------------
    dsig = reshape(huffmandeco(new_comp, dict1), size(entropy_code)); % huffman decoding (takes a long time)
    if (isequal(entropy_code,dsig) ~= 1) % check if decoding is correct
        input('error in huffmandeco')
    end
    % put entropy decoding here
    % dequantization
    if (ch == 1)
        channel_q = blockproc(channel_q,[n n], dequantY);
    else
        channel_q = blockproc(channel_q,[n n], dequantC);
    end
    output_data = blockproc(channel_q./scale,[n n],invdct); % inverse DCT, scale back
    output_image(:,:,ch) = output_data(1:dim1, 1:dim2); % set output
end
%---------------------------
%shuffled_comp_vector = shuffled_comp_vector(2:length(shuffled_comp_vector)); % remove first symbol
if (dim3 > 1)
    output_image = im2uint8(ycbcr2rgb(output_image)); % back to rgb uint8
else
    output_image = im2uint8(output_image); % back to rgb uint8
end
% compute compression ratio
% compressed_vector is binary, input image has one byte per pixel
ratio = (dim1 * dim2 * dim3)*8 / length(compressed_vector) ; % size of huffman dicitonary  is missed
subplot(1,2,1), imshow(input_image) % show results
subplot(1,2,2), imshow(output_image) % show results
disp(ratio);
end


function [entropy_code] = get_entropy (entropy_raw_matrix, n, dim1, dim2)
% go by tiles in loops to extract shortened entropy codes (without
% zeros on the end)
step = n-1; % poor stuff for entropy coding iterations, should be avoided
tile = entropy_raw_matrix(1:1+step, 1:1+step);
entropy_code = tile(1:find(tile(:),1,'last'));
for i=step+2:step+1:dim1-step
    for j=step+2:step+1:dim2-step
        tile = entropy_raw_matrix(i:i+step, j:j+step);
        entropy_code = cat(2, entropy_code, tile(1:find(tile(:),1,'last')));
    end
end
end



