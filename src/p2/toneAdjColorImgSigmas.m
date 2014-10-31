function [ out ] = toneAdjColorImgSigmas( baseImg, awesomeImg, scaleF, sigma_s_seq, sigma_r_seq )
%TONEADJCOLORIMGSIGMAS tone mapping using a bilateral filter
%   for a series of sigma values. also applying a detail scale factor.
%   the tone of the baseImg is matched to the tone histogram of the awesome
%   img.
%   @return tensor containing all computed color images.
    
    % colorspace transformation into yuv space.
    yuv_base = rgb2yuv(baseImg);
    yuv_awesome = rgb2yuv(awesomeImg);
    
    % form all sigma pairs
    sigma_pairs = arrays2pairs(sigma_s_seq, sigma_r_seq);
    
    % get dimensions and lengths of paramter spaces.
    len_sig_s = length(sigma_s_seq);
    len_sig_r = length(sigma_r_seq);
    [m,n] = size(yuv_base(:,:,1));
    
    % prepare output tensor:
    % there are len_sig_s*len_sig_r (m x n) color images (i.e. 3 channels).
    out = zeros(m, n, 3, len_sig_s*len_sig_r);
    
    % perform computation for each sigma pair
    for k=1:len_sig_s*len_sig_r,
        sigmas = sigma_pairs(k, :);
        toneAdjustedY = automatedToneAdjustment(yuv_base(:,:,1), ...
                                            yuv_awesome(:,:,1), scaleF, ...
                                            sigmas(1), sigmas(2));
        out(:,:,:,k) = yuv2rgb(mat2Img(toneAdjustedY, yuv_base(:,:,2), yuv_base(:,:,3)));                     
    end
    
end

