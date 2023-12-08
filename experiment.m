% x = randi(10,10,1);
% [comp, dict] = huffman_cod(x);
% l = length(comp);
% seq = randperm(l);
% comp_new = comp(seq);
% result = huffmandeco(comp_new,dict);

im = imread("lena_gray.tif");
[ratio] = jpeg_computing_edit(im,50);