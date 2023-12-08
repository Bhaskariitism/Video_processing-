clear all, close all, clc;

X = imread("lena_color_512.tif");
%% Compress
[cr0, bpp0] = wcompress('c',X,'comp_lena.jpg','stw');
[cr,bpp] = wcompress('c',X,'comp_lena1.jpg','spiht','maxloop',12);
[cr1,bpp1] = wcompress('c',X,'comp_lena1.jpg','ezw','maxloop',12);
[cr2,bpp2] = wcompress('c',X,'comp_lena1.jpg','wdr','maxloop',12);
[cr3,bpp3] = wcompress('c',X,'comp_lena1.jpg','aswdr','maxloop',12);
[cr4,bpp4] = wcompress('c',X,'comp_lena1.jpg','spiht_3d','maxloop',12);
%% Uncompress
wcompress('u','comp_lena.jpg','step');

     

Xc = wcompress('u', 'comp_lena1.jpg');
delete('comp_lena.jpg');

%% MSE and PSNR calculation
D = abs(X-Xc).^2;
mse  = sum(D(:))/numel(X);
psnr = 10*log10(255*255/mse);