function demoBilateralFilter( img, sigma_s_seq, sigma_r_seq )
%DEMOBILATERALFILTER Summary of this function goes here
%   Detailed explanation goes here

    % used for later for loop in order to generate the figures.
    len_sig_s = length(sigma_s_seq);
    len_sig_r = length(sigma_r_seq);
    
    
    sigma_pairs = arrays2pairs(sigma_s_seq, sigma_r_seq);
    
    hold on
    idx = 1;
    for k_s=1 : len_sig_s,
        for k_r=1 : len_sig_r,
            sigmas = sigma_pairs(idx, :);
            img = bilateralFilter(img, sigmas(1), sigmas(2));
            subplot(len_sig_s,len_sig_r, idx), subimage(img)
            idx = idx + 1;
        end
    end


end

