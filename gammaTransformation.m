function [ out ] = gammaTransformation( img, gamma )
%GAMMATRANSFORMATION Summary of this function goes here
%   Detailed explanation goes here
    
    yuvImg = rgb2yuv(img);
    Y = yuvImg(:,:,1);
    yuvImg(:,:,1) = Y.^gamma;
    out = yuv2rgb(yuvImg);

end

