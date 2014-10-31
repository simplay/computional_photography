function [ out ] = simpleautoToneAdjustment( baseImg,  awesomeImg)
%SIMPLEAUTOTONEADJUSTMENT Summary of this function goes here
%   Detailed explanation goes here
yuv_base = rgb2yuv(baseImg);
yuv_awesome = rgb2yuv(awesomeImg);

hist_lc_model = imhist(yuv_awesome(:,:,1));
J = histeq(yuv_base(:,:,1), hist_lc_model);
out = yuv2rgb(mat2Img(J, yuv_base(:,:,2), yuv_base(:,:,3)));

end

