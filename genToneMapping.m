function [ out ] = genToneMapping( hdrImg, output_range, sigma_s_seq, sigma_r_seq )
%GENTONEMAPPING Summary of this function goes here
%   Detailed explanation goes here

    % form all sigma pairs
    sigma_pairs = arrays2pairs(sigma_s_seq, sigma_r_seq);
    
    % get dimensions and lengths of paramter spaces.
    len_sig_s = length(sigma_s_seq);
    len_sig_r = length(sigma_r_seq);
    [m,n] = size(hdrImg(:,:,1));
    
    % prepare output tensor:
    % there are len_sig_s*len_sig_r (m x n) color images (i.e. 3 channels).
    out = zeros(m, n, 3, len_sig_s*len_sig_r);

    eps = 0.0001;
    R = hdrImg(:,:,1);
    G = hdrImg(:,:,2);
    B = hdrImg(:,:,3);
    
    intensities = (R*20 + G*40 + B)/61;
    intensities = max(intensities, eps);
    
    r = (R ./ intensities);
    g = (G ./ intensities);
    b = (B ./ intensities);
    
    log_intensities = log(intensities);
    
    % hook in
    for k=1:len_sig_s*len_sig_r,
        sigmas = sigma_pairs(k, :);
        
        % 
        log_base = bfilt(log_intensities, sigmas(1), sigmas(2));
        log_detail = log_intensities - log_base;
    
        compressionF = log(output_range)/(max(log_base(:))-min(log_base(:)));
        log_offset = -max(log_base(:))*compressionF;
    
        log_output_intensitiy = log_base*compressionF + log_offset+log_detail;
    
        R_output = r .* exp(log_output_intensitiy);
        G_output = g .* exp(log_output_intensitiy);
        B_output = b .* exp(log_output_intensitiy);
   
       % 
       out(:,:,:,k) = mat2Img(R_output, G_output, B_output );
    end
    
end

