function [ out ] = manColBalGui( img , idx)
%MANCOLBALGUI Summary of this function goes here
%   Detailed explanation goes here
    [x,y]=ginput(1);
    x = round(x);
    y = round(y);
    out = manualWhiteBalance(img, [x,y]);
end

