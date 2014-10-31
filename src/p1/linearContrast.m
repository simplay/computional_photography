function [ out ] = linearContrast( img, toMin, toMax )
%UNTITLED changes contrast by linearly scaling image brightness
%   transforms applies for each y in Y: f(y) = (y-min)/delta(min,max) 
%   assuming the pixels of img are in [0,1]^3.
%   @param img is a (m x n x 3) double valued color img in rgb colorspace
%   @param toMin min tolerated Y value real+ valued.
%   @param toMax max tolerated Y value real+ valued.
%   @return out linear contrast adjusted input img.
    
    % transform img into yuv color space
    yuvImg = rgb2yuv(img);
    
    % scale and shift the Y channel such that
    Y = yuvImg(:,:,1);
    transformedY = (Y-toMin)/(toMax - toMin);
    % toMin maps to 0 and toMax to 1.
    
    %tranfrom back to rgb
    yuvImg(:,:,1) = transformedY;
    out = yuv2rgb(yuvImg);

end

