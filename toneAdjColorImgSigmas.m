function [ out ] = toneAdjColorImgSigmas( baseImg, awesomeImg, scaleF, sigma_s_seq, sigma_r_seq )
%TONEADJCOLORIMGSIGMAS Summary of this function goes here
%   Detailed explanation goes here

    yuv_base = rgb2yuv(baseImg);
    yuv_awesome = rgb2yuv(awesomeImg);
    
    sigma_pairs = arrays2pairs(sigma_s_seq, sigma_r_seq);
    len_sig_s = length(sigma_s_seq);
    len_sig_r = length(sigma_r_seq);
    
    [m,n] = size(yuv_base(:,:,1));
    
    out = zeros(m,n, 3, len_sig_s*len_sig_r);
    for k=1:len_sig_s*len_sig_r,
        sigmas = sigma_pairs(k, :);
        toneAdjustedY = automatedToneAdjustment(yuv_base(:,:,1), ...
                                            yuv_awesome(:,:,1), scaleF, ...
                                            sigmas(1), sigmas(2));
        out(:,:,:,k) = yuv2rgb(mat2Img(toneAdjustedY, yuv_base(:,:,2), yuv_base(:,:,3)));                     
    end
    

end

