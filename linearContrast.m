function [ out ] = linearContrast( img, toMin, toMax )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % assuming the pixels of img are in [0,1]^3.
    
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

