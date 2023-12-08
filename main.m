close all, clear all, clc;
im = imread("lena.tif");
for i=1:size(im,3)
%im1  = rgb2gray(im);
binaryStream = reshape(dec2bin(im(:,:,i), 8).', 1, []);
%% Key genration
alpha = 1.75325; 
r = 3.9; 
x0 = 0.01;
num_iterations = length(binaryStream);
reduced_iterations=((num_iterations-mod(num_iterations,32))/32)+(mod(num_iterations,32)>0);
[key_bit] = generateBitstream(alpha, r, reduced_iterations, x0);
Actualkey_bits=key_bit(1:num_iterations);
%% Encryption
bitstream1 = logical(binaryStream - '0');
result = xor(bitstream1, Actualkey_bits);
segments = reshape(result, 8, []).';
decimalValue = bi2de(segments, 'left-msb');
image(:,:,i) = uint8(reshape(decimalValue,512,512));
%% Decryption
binaryStream_encrypted = reshape(dec2bin(image(:,:,i), 8).', 1, []);
bitstream_encrypted= double(binaryStream_encrypted) - 48;
result_decrypted = xor(bitstream_encrypted, Actualkey_bits);
segments_decrypted = reshape(result_decrypted, 8, []).';
decimalValue_decrypted = bi2de(segments_decrypted, 'left-msb');
image_decrypted(:,:,i) = uint8(reshape(decimalValue_decrypted,512,512));
end
figure,
subplot(1,3,1), imshow(im), title('Original Image');
subplot(1,3,2), imshow(image), title('Encrypted Image');
subplot(1,3,3), imshow(image_decrypted), title('Decrypted Image');