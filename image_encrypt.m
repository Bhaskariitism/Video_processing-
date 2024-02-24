close all, clear all,  clc;

        
        frame = imread("lena.tif");
        ycbcr =  rgb2ycbcr(frame);
        Y = ycbcr(:,:,1);
        CB = ycbcr(:,:,2);
        Cb = CB(1:2:end,1:2:end);
        CR = ycbcr(:,:,3);
        Cr = CR(1:2:end,1:2:end);
        %% Y component
        [Y_SVD, YUT, YST, YVT, minYUV, maxYUV, minYST, maxYST] = svdcompression(Y, 8);
        % YUT
        [rowY, colY] = size(YUT);
           for j = 1:rowY
                for k = 1:colY
                    B = YUT{j,k};
                    [row,col] = size(B);
                    permYUT{j,k} = randperm(row*col);
                    B_row = B(:)';
                    shuflled_B = B_row(permYUT{j,k});
                    shuflled_B_reshape = reshape(shuflled_B, row, col);
                    encrYUT{j,k} = randi([1,8], 8,8);
                    dnaY = n_dnaEncode(shuflled_B_reshape, encrYUT{j,k});
                    dnaYUT{j,k} = dnaY;
                    matYUT{j,k} = uint8(randi([0,255],8,2));
                    dnaKeyYUT{j,k} = n_dnaEncode(matYUT{j,k}, encrYUT{j,k});
                    xordna_Y = n_dnaOperate(dnaYUT{j,k}, dnaKeyYUT{j,k}, encrYUT{j,k});
                    cipher_Y = n_dnaDecode(xordna_Y, encrYUT{j,k});
                    cipher_YUT{j,k} = cipher_Y;
                    % decryption
                    Cipher = cipher_YUT{j,k};
                    cipher_dnaY = n_dnaEncode(Cipher, encrYUT{j,k});
                    cipher_xordna_Y = n_dnaOperate(cipher_dnaY, dnaKeyYUT{j,k}, encrYUT{j,k});
                    decipher_Y = n_dnaDecode(cipher_xordna_Y , encrYUT{j,k});
                    decipher_Y = decipher_Y(:);
                    reshuffle_YUT(permYUT{j,k}) = decipher_Y;
                    decryptY =  reshape(reshuffle_YUT, row, col);
                    decrypt_YUT{j,k} = decryptY;
                end
            end
        %YST
        for j = 1:rowY
            for k = 1:colY
                B = YST{j,k};
                [row,col] = size(B);
                permYST{j,k} = randperm(row*col);
                B_row = B(:)';
                shuflled_B = B_row(permYST{j,k});
                shuflled_B_reshape = reshape(shuflled_B, row, col);
                encrYST{j,k} = randi([1,8], 2,4);
                dnaYST = n_dnaEncode(shuflled_B_reshape, encrYST{j,k});
                dna_YST{j,k} = dnaYST;
                matYST{j,k} = uint8(randi([0,255],2,1));
                dnaYSTKey{j,k} = n_dnaEncode(matYST{j,k}, encrYST{j,k});
                xordna_Y = n_dnaOperate(dna_YST{j,k}, dnaYSTKey{j,k}, encrYST{j,k});
                cipher_Y = n_dnaDecode(xordna_Y, encrYST{j,k});
                cipher_YST{j,k} = cipher_Y;
                % decryption
                Cipher = cipher_YST{j,k};
                Cipher_dnaY = n_dnaEncode(Cipher, encrYST{j,k});
                Cipher_xordna_Y = n_dnaOperate(Cipher_dnaY, dnaYSTKey{j,k}, encrYST{j,k});
                decipher_Y = n_dnaDecode(Cipher_xordna_Y , encrYST{j,k});
                decipher_Y = decipher_Y(:);
                reshuffle_YST(permYST{j,k}) = decipher_Y;
                decryptY =  reshape(reshuffle_YST, row, col);
                decrypt_YST{j,k} = decryptY;
            end
        end
        % YVT
        for j = 1:rowY
            for k = 1:colY
                B = YVT{j,k};
                [row,col] = size(B);
                permYVT{j,k} = randperm(row*col);
                B_row = B(:)';
                shuflled_B = B_row(permYVT{j,k});
                shuflled_B_reshape = reshape(shuflled_B, row, col);
                encrYVT{j,k} = randi([1,8], 8,8);
                dnaY = n_dnaEncode(shuflled_B_reshape, encrYVT{j,k});
                dnaYVT{j,k} = dnaY;
                matYVT{j,k} = uint8(randi([0,255],8,2));
                dnaKeyYVT{j,k} = n_dnaEncode(matYVT{j,k}, encrYVT{j,k});
                xordna_Y = n_dnaOperate(dnaYVT{j,k}, dnaKeyYVT{j,k}, encrYVT{j,k});
                cipher_Y = n_dnaDecode(xordna_Y, encrYVT{j,k});
                cipher_YVT{j,k} = cipher_Y;
                % decryption
                Cipher = cipher_YVT{j,k};
                cipher_dnaY = n_dnaEncode(Cipher, encrYVT{j,k});
                cipher_xordna_Y = n_dnaOperate(cipher_dnaY, dnaKeyYVT{j,k}, encrYVT{j,k});
                decipher_Y = n_dnaDecode(cipher_xordna_Y , encrYVT{j,k});
                decipher_Y = decipher_Y(:);
                reshuffle_YVT(permYVT{j,k}) = decipher_Y;
                decryptY =  reshape(reshuffle_YVT, row, col);
                decrypt_YVT{j,k} = decryptY;
        
            end
        end
     %% CB compoenent
    [Cb_SVD, CbUT, CbST, CbVT, minCbUV, maxCbUV, minCbST, maxCbST] = svdcompression(Cb, 8);
    [rowCb, colCb] = size(CbUT);
    for j = 1:rowCb
        for k = 1:colCb
            B = CbUT{j,k};
            [row,col] = size(B);
            permCbUT{j,k} = randperm(row*col);
            B_row = B(:)';
            shuflled_B = B_row(permCbUT{j,k});
            shuflled_B_reshape = reshape(shuflled_B, row, col);
            encrCbUT{j,k} = randi([1,8], 8,8);
            dnaCb = n_dnaEncode(shuflled_B_reshape, encrCbUT{j,k});
            dnaCbUT{j,k} = dnaCb;
            matCbUT{j,k} = uint8(randi([0,255],8,2));
            dnaKeyCbUT{j,k} = n_dnaEncode(matCbUT{j,k}, encrCbUT{j,k});
            xordna_Cb = n_dnaOperate(dnaCbUT{j,k}, dnaKeyCbUT{j,k}, encrCbUT{j,k});
            cipher_Cb = n_dnaDecode(xordna_Cb, encrCbUT{j,k});
            cipher_CbUT{j,k} = cipher_Cb;
            % decryption
            Cipher = cipher_CbUT{j,k};
            cipher_dnaCb = n_dnaEncode(Cipher, encrCbUT{j,k});
            cipher_xordna_Cb = n_dnaOperate(cipher_dnaCb, dnaKeyCbUT{j,k}, encrCbUT{j,k});
            decipher_Cb = n_dnaDecode(cipher_xordna_Cb , encrCbUT{j,k});
            decipher_Cb = decipher_Cb(:);
            reshuffle_CbUT(permCbUT{j,k}) = decipher_Cb;
            decryptCb =  reshape(reshuffle_CbUT, row, col);
            decrypt_CbUT{j,k} = decryptCb;
        end
    end
                    
    %Cb_ST
    for j = 1:rowCb
        for k = 1:colCb
            B = CbST{j,k};
            [row,col] = size(B);
            permCbST{j,k} = randperm(row*col);
            B_row = B(:)';
            shuflled_B = B_row(permCbST{j,k});
            shuflled_B_reshape = reshape(shuflled_B, row, col);
            encrCbST{j,k} = randi([1,8], 2,4);
            dnaCbST = n_dnaEncode(shuflled_B_reshape, encrCbST{j,k});
            dna_CbST{j,k} = dnaCbST;
            matCbST{j,k} = uint8(randi([0,255],2,1));
            dnaCbSTKey{j,k} = n_dnaEncode(matCbST{j,k}, encrCbST{j,k});
            xordna_Cb = n_dnaOperate(dna_CbST{j,k}, dnaCbSTKey{j,k}, encrCbST{j,k});
            cipher_Cb = n_dnaDecode(xordna_Cb, encrCbST{j,k});
            cipher_CbST{j,k} = cipher_Cb;
            % decryption
            Cipher = cipher_CbST{j,k};
            Cipher_dnaCb = n_dnaEncode(Cipher, encrCbST{j,k});
            Cipher_xordna_Cb = n_dnaOperate(Cipher_dnaCb, dnaCbSTKey{j,k}, encrCbST{j,k});
            decipher_Cb = n_dnaDecode(Cipher_xordna_Cb , encrCbST{j,k});
            decipher_Cb = decipher_Cb(:);
            reshuffle_CbST(permCbST{j,k}) = decipher_Cb;
            decryptCb =  reshape(reshuffle_CbST, row, col);
            decrypt_CbST{j,k} = decryptCb;
        end
    end
        % CbVT
    for j = 1:rowCb
        for k = 1:colCb
           B = CbVT{j,k};
            [row,col] = size(B);
            permCbVT{j,k} = randperm(row*col);
            B_row = B(:)';
            shuflled_B = B_row(permCbVT{j,k});
            shuflled_B_reshape = reshape(shuflled_B, row, col);
            encrCbVT{j,k} = randi([1,8], 8,8);
            dnaCb = n_dnaEncode(shuflled_B_reshape, encrCbVT{j,k});
            dnaCbVT{j,k} = dnaCb;
            matCbVT{j,k} = uint8(randi([0,255],8,2));
            dnaKeyCbVT{j,k} = n_dnaEncode(matCbVT{j,k}, encrCbVT{j,k});
            xordna_Cb = n_dnaOperate(dnaCbVT{j,k}, dnaKeyCbVT{j,k}, encrCbVT{j,k});
            cipher_Cb = n_dnaDecode(xordna_Cb, encrCbVT{j,k});
            cipher_CbVT{j,k} = cipher_Cb;
            % decryption
            Cipher = cipher_CbVT{j,k};
            cipher_dnaCb = n_dnaEncode(Cipher, encrCbVT{j,k});
            cipher_xordna_Cb = n_dnaOperate(cipher_dnaCb, dnaKeyCbVT{j,k}, encrCbVT{j,k});
            decipher_Cb = n_dnaDecode(cipher_xordna_Cb , encrCbVT{j,k});
            decipher_Cb = decipher_Cb(:);
            reshuffle_CbVT(permCbVT{j,k}) = decipher_Cb;
            decryptCb =  reshape(reshuffle_CbVT, row, col);
            decrypt_CbVT{j,k} = decryptCb;
        end
    end
    %  %% CR components
    % 
     [Cr_SVD, CrUT, CrST, CrVT, minCrUV, maxCrUV, minCrST, maxCrST] = svdcompression(Cr, 8);
     %Cr_UT
              for j = 1:rowCb
                 for k = 1:colCb
                     B = CrUT{j,k};
                     [row,col] = size(B);
                     permCrUT{j,k} = randperm(row*col);
                     B_row = B(:)';
                     shuflled_B = B_row(permCrUT{j,k});
                     shuflled_B_reshape = reshape(shuflled_B, row, col);
                     encrCrUT{j,k} = randi([1,8], 8,8);
                     dnaCr = n_dnaEncode(shuflled_B_reshape, encrCrUT{j,k});
                     dnaCrUT{j,k} = dnaCr;
                     matCrUT{j,k} = uint8(randi([0,255],8,2));
                     dnaKeyCrUT{j,k} = n_dnaEncode(matCrUT{j,k}, encrCrUT{j,k});
                     xordna_Cr = n_dnaOperate(dnaCrUT{j,k}, dnaKeyCrUT{j,k}, encrCrUT{j,k});
                     cipher_Cr = n_dnaDecode(xordna_Cr, encrCrUT{j,k});
                     cipher_CrUT{j,k} = cipher_Cr;
                     % decryption
                     Cipher = cipher_CrUT{j,k};
                     cipher_dnaCr = n_dnaEncode(Cipher, encrCrUT{j,k});
                     cipher_xordna_Cr = n_dnaOperate(cipher_dnaCr, dnaKeyCrUT{j,k}, encrCrUT{j,k});
                     decipher_Cr = n_dnaDecode(cipher_xordna_Cr , encrCrUT{j,k});
                     decipher_Cr = decipher_Cr(:);
                     reshuffle_CrUT(permCrUT{j,k}) = decipher_Cr;
                     decryptCr =  reshape(reshuffle_CrUT, row, col);
                     decrypt_CrUT{j,k} = decryptCr;
                 end
             end
        %Cr_ST
        for j = 1:rowCb
            for k = 1:colCb
                B = CrST{j,k};
                [row,col] = size(B);
                permCrST{j,k} = randperm(row*col);
                B_row = B(:)';
                shuflled_B = B_row(permCrST{j,k});
                shuflled_B_reshape = reshape(shuflled_B, row, col);
                encrCrST{j,k} = randi([1,8], 2,4);
                dnaCrST = n_dnaEncode(shuflled_B_reshape, encrCrST{j,k});
                dna_CrST{j,k} = dnaCrST;
                matCrST{j,k} = uint8(randi([0,255],2,1));
                dnaCrSTKey{j,k} = n_dnaEncode(matCrST{j,k}, encrCrST{j,k});
                xordna_Cr = n_dnaOperate(dna_CrST{j,k}, dnaCrSTKey{j,k}, encrCrST{j,k});
                cipher_Cr = n_dnaDecode(xordna_Cr, encrCrST{j,k});
                cipher_CrST{j,k} = cipher_Cr;
                % decryption
                Cipher = cipher_CrST{j,k};
                Cipher_dnaCr = n_dnaEncode(Cipher, encrCrST{j,k});
                Cipher_xordna_Cr = n_dnaOperate(Cipher_dnaCr, dnaCrSTKey{j,k}, encrCrST{j,k});
                decipher_Cr = n_dnaDecode(Cipher_xordna_Cr , encrCrST{j,k});
                decipher_Cr = decipher_Cr(:);
                reshuffle_CrST(permCrST{j,k}) = decipher_Cr;
                decryptCr =  reshape(reshuffle_CrST, row, col);
                decrypt_CrST{j,k} = decryptCr;
            end
        end
        % Cr_VT
        for j = 1:rowCb
            for k = 1:colCb
               B = CrVT{j,k};
                [row,col] = size(B);
                permCrVT{j,k} = randperm(row*col);
                B_row = B(:)';
                shuflled_B = B_row(permCrVT{j,k});
                shuflled_B_reshape = reshape(shuflled_B, row, col);
                encrCrVT{j,k} = randi([1,8], 8,8);
                dnaCr = n_dnaEncode(shuflled_B_reshape, encrCrVT{j,k});
                dnaCrVT{j,k} = dnaCr;
                matCrVT{j,k} = uint8(randi([0,255],8,2));
                dnaKeyCrVT{j,k} = n_dnaEncode(matCrVT{j,k}, encrCrVT{j,k});
                xordna_Cr = n_dnaOperate(dnaCrVT{j,k}, dnaKeyCrVT{j,k}, encrCrVT{j,k});
                cipher_Cr = n_dnaDecode(xordna_Cr, encrCrVT{j,k});
                cipher_CrVT{j,k} = cipher_Cr;
                % decryption
                Cipher = cipher_CrVT{j,k};
                cipher_dnaCr = n_dnaEncode(Cipher, encrCrVT{j,k});
                cipher_xordna_Cr = n_dnaOperate(cipher_dnaCr, dnaKeyCrVT{j,k}, encrCrVT{j,k});
                decipher_Cr = n_dnaDecode(cipher_xordna_Cr , encrCrVT{j,k});
                decipher_Cr = decipher_Cr(:);
                reshuffle_CrVT(permCrVT{j,k}) = decipher_Cr;
                decryptCr =  reshape(reshuffle_CrVT, row, col);
                decrypt_CrVT{j,k} = decryptCr;

            end
        end

    encrY = reconstruct_image(cipher_YUT, cipher_YST, cipher_YVT, minYUV, maxYUV, minYST, maxYST, 8);
    encrCb = reconstruct_image(cipher_CbUT, cipher_CbST, cipher_CbVT, minCbUV, maxCbUV, minCbST, maxCbST, 8);
    encrCr = reconstruct_image(cipher_CrUT, cipher_CrST, cipher_CrVT, minCrUV, maxCrUV, minCrST, maxCrST, 8);
    encrCB = imresize(encrCb,2);
    encrCR = imresize(encrCr,2);
    encryptedFrame = ycbcr2rgb(cat(3,encrY,encrCB,encrCR));

    decrY = reconstruct_image(decrypt_YUT, decrypt_YST, decrypt_YVT, minYUV, maxYUV, minYST, maxYST, 8);
    decrCb = reconstruct_image(decrypt_CbUT, decrypt_CbST, decrypt_CbVT, minCbUV, maxCbUV, minCbST, maxCbST, 8);
    decrCr = reconstruct_image(decrypt_CrUT, decrypt_CrST, decrypt_CrVT, minCrUV, maxCrUV, minCrST, maxCrST, 8);
    decrCB = imresize(decrCb,2);
    decrCR = imresize(decrCr,2);
    decryptedFrame = ycbcr2rgb(cat(3,decrY,decrCB,decrCR));

  
    figure, subplot(1,3,1),imshow(frame), title('Orriginal I-Frame');
    subplot(1,3,2),imshow(encryptedFrame), title('Encrypted I-Frame');
    subplot(1,3,3),imshow(decryptedFrame), title('Decrypted I-Frame');
    
    