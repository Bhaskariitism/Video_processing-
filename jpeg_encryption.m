clear all;
close all;
clc;

im = imread('lena.tif');

%% Subsampling
ycbcr = rgb2ycbcr(im);
Y = ycbcr(:,:,1);
Cb = ycbcr(:,:,2);
Cb_subsampled = Cb(1:2:end, 1:2:end);
Cr = ycbcr(:,:,3);
Cr_subsampled = Cr(1:2:end, 1:2:end);
%% DCT
Y_dct = blockproc(Y, [8, 8], @(block_struct) dct2(block_struct.data));
Cb_dct = blockproc(Cb_subsampled, [8, 8], @(block_struct) dct2(block_struct.data));
Cr_dct = blockproc(Cr_subsampled, [8, 8], @(block_struct) dct2(block_struct.data));

%% Quantization
 quantization_matrix = get_quantization(50);
 Y_quantized = blockproc(Y_dct, [8, 8], @(block_struct) round(block_struct.data ./ quantization_matrix));
 Cb_quantized = blockproc(Cb_dct, [8, 8], @(block_struct) round(block_struct.data ./ quantization_matrix));
 Cr_quantized = blockproc(Cr_dct, [8, 8], @(block_struct) round(block_struct.data ./ quantization_matrix));

 %% zigzag scanning
 Y_zigzag = zigzag(Y_quantized);
 Cb_zigzag = zigzag(Cb_quantized);
 Cr_zigzag = zigzag(Cr_quantized);


%% Huffman encoding
     [Y_comp, Y_dict] = huffman_cod( Y_zigzag);
     [Cb_comp, Cb_dict] = huffman_cod( Cb_zigzag);
     [Cr_comp, Cr_dict] = huffman_cod( Cr_zigzag);
%% Encryption
alpha = 1.75325; 
r = 3.9; 
x0 = 0.01;
num_iterations = length(Y_comp);
reduced_iterations=((num_iterations-mod(num_iterations,32))/32)+(mod(num_iterations,32)>0);
[key_bit_Y] = generateBitstream(alpha, r, reduced_iterations, x0);
Actualkey_bits_Y=key_bit_Y(1:num_iterations);

num_iterations = length(Cb_comp);
reduced_iterations=((num_iterations-mod(num_iterations,32))/32)+(mod(num_iterations,32)>0);
[key_bit_Cb] = generateBitstream(alpha, r, reduced_iterations, x0);
Actualkey_bits_Cb=key_bit_Cb(1:num_iterations);

num_iterations = length(Cr_comp);
reduced_iterations=((num_iterations-mod(num_iterations,32))/32)+(mod(num_iterations,32)>0);
[key_bit_Cr] = generateBitstream(alpha, r, reduced_iterations, x0);
Actualkey_bits_Cr=key_bit_Cr(1:num_iterations);

bitstream_Y = logical(Y_comp - '0');
bitstream_Cb = logical(Cb_comp - '0');
bitstream_Cr = logical(Cr_comp - '0');

result_Y = xor(bitstream_Y, Actualkey_bits_Y');

result_Cb = xor(bitstream_Cb, Actualkey_bits_Cb');
result_Cr = xor(bitstream_Cr, Actualkey_bits_Cr');

new_Y_comp = double(result_Y);
new_Cb_comp = double(result_Cb);
new_Cr_comp = double(result_Cr);




%% JPEG decoding    


 %% Huffman Decoding
 Y_decoded = huffmandeco(Y_comp, Y_dict);
 Cb_decoded = huffmandeco(Cb_comp, Cb_dict);
 Cr_decoded = huffmandeco(Cr_comp, Cr_dict);
    
 %% Inverse zigzag

 Y_invzigzag = izigzag(Y_decoded,512,512);
 Cb_invzigzag = izigzag(Cb_decoded,256,256);
 Cr_invzigzag = izigzag(Cr_decoded,256,256);

%% Dequantization
    quantization_matrix = get_quantization(50);
    Y_dequantized = blockproc(Y_invzigzag, [8, 8], @(block_struct) block_struct.data .* quantization_matrix());
    Cb_dequantized = blockproc(Cb_invzigzag, [8, 8], @(block_struct) block_struct.data .* quantization_matrix());
    Cr_dequantized = blockproc(Cr_invzigzag, [8, 8], @(block_struct) block_struct.data .* quantization_matrix());

    %% Inverse DCT
    Y_idct = blockproc(Y_dequantized, [8, 8], @(block_struct) idct2(block_struct.data));
    Cb_idct = blockproc(Cb_dequantized, [8, 8], @(block_struct) idct2(block_struct.data));
    Cr_idct = blockproc(Cr_dequantized, [8, 8], @(block_struct) idct2(block_struct.data));

    %% Combine the Y, Cb, and Cr components
    Cb_new = imresize(Cb_idct,2);
    Cr_new = imresize(Cr_idct,2);
    reconstructed_image_ycbcr = uint8(cat(3, Y_idct, Cb_new, Cr_new));

    %% Convert back to RGB color space
    reconstructed_image_rgb = ycbcr2rgb(reconstructed_image_ycbcr);

    


figure,
subplot(1,2,1), imshow(im), title('Original image');
subplot(1,2,2), imshow(reconstructed_image_rgb), title('Reconstructed image');