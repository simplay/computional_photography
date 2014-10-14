function [ out ] = bilateralFilter( img, sigma_s, sigma_r )
%BILATERALFILTER apply appropriate bilateral filter depending on imgs dims
%   if we passed a color image,i.e. has 3 color channels, then apply bifiltImg3
%   otherwise apply bfilt (in case we have a gray scale imgs or just any (m x n) matrix).

    dimLength = length(size(img));
    
    if dimLength == 3,
        out = bfiltImg3(img, sigma_s, sigma_r);
    else
        out = bfilt(img, sigma_s, sigma_r);
    end
    
end

