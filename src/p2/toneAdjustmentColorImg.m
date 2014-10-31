function [ out ] = toneAdjustmentColorImg( baseImg, awesomeImg, scaleF )
%TONEADJUSTMENTCOLORIMG Summary of this function goes here
%   Detailed explanation goes here
    yuv_base = rgb2yuv(baseImg);
    yuv_awesome = rgb2yuv(awesomeImg);
    
    toneAdjustedY = automatedToneAdjustment(yuv_base(:,:,1), ...
                                            yuv_awesome(:,:,1), scaleF, ...
                                            2, 0.12);
    
    % temporary workaround
    out = yuv2rgb(mat2Img(toneAdjustedY, yuv_base(:,:,2), yuv_base(:,:,3)));
end

