function [grey inverted] = spanishCastle(img)
%SPANISHCASTLE creates the greyscale and inverted image of the input
%   Input
%   - img: an RGB color image
%   Output
%   - grey: the greyscale image of the inupt image
%   - inverted: the invertet color image of the input


% replace the following example code with yours!
disp('spanishCastle was called');

% fetch image dimensions.
dims = size(img);
m = dims(1);
n = dims(2);

% Convert the RGB colors to YUV color space.
img_yuv = rgb2yuv( img );

% get Y channel from yuv img
Y = img_yuv(:,:,1);

% Use the input Y channel in order to form a mxnx3 grayscale-image.
grey = reshape(repmat(Y, 1, 3), m, n, 3);

% set the Y channel to 0.6 for all pixels.
img_yuv(:,:,1) = ones(m, n).*0.6;

% invert the RGB colors by taking one minus the RGB values.
inverted = 1 - yuv2rgb(img_yuv);
end