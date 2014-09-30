function [ out ] = gammaTransformation( img, gamma )
%GAMMATRANSFORMATION Perform gamma correction. 
%   changes contrast of img by applying a gamma transformation.
%   @param img is assumed to be a (m x n x 3) double img in rgb colorspace.
%   @param gamma is assumed to be a natural number.
%   @return out be a (m x n x 3) double img in rgb colorspace
    
    % transform rgb image to yuv the colorspace.
    yuvImg = rgb2yuv(img);
    
    % retrieve Y channel which corresponds to the illumination of the img.
    Y = yuvImg(:,:,1);
    
    % Apply gamma correction: raise each element in Y to the power of
    % gamma. Then update Y channel of yuv colors.
    yuvImg(:,:,1) = Y.^gamma;
    
    % transform updated yuv back to rgb colors.
    out = yuv2rgb(yuvImg);

end

