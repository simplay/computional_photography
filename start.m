% Computational Photography Project 1
% Turned in by <Name>

%% Assignement 1

img = imread('imgs/castle.jpg');
img = im2double(img);

[grey, inverted] = spanishCastle(img);

% Please show your images with imshow (instead of imwrite) and add titles
% to the (sub)figures if there are more then one.
figure(1);
imshow(grey);
title('Greyscale image');

figure(2)
imshow(inverted);
title('Inverted image');


%% Assignement 2.1
img = imread('imgs/foliage raw.tiff');
img = double(img) / 4096.0;
final_img = demosaicBayer(img);

figure(3)
imshow(final_img);
title('demosaiced img linear filtered');

%% Assignement 2.2
img = imread('imgs/black and white raw.tif');
img = double(img) / 255.0;

img = medianFilteredDemosaic(img);

figure(4)
imshow(img)
title('demosaiced img bayer filtered');
   
% %red part
% red_known = rgb2yuv_transform(2:end, 2:end);
% red_v = rgb2yuv_transform(2:end, 1);
% 
% green_known = rgb2yuv_transform(2:end, 1:2:end);
% green_v = rgb2yuv_transform(2:end, 2);
% 
% blue_known = rgb2yuv_transform(2:end, 1:end-1);
% blue_v = rgb2yuv_transform(2:end, 3);
% 
% [a1,b1] = foobarize(final_img(:,:,1), red_known, medU, medV, red_v, red_mask);
% [a2,b2] = foobarize(final_img(:,:,2), green_known, medU, medV, green_v, green_mask);
% [a3,b3] = foobarize(final_img(:,:,3), blue_known, medU, medV, blue_v, blue_mask);
% 
% 
% serializedMask = red_mask(:)';
% r_c = final_img(:,:,1);
% maskedMedCol1 = [r_c(:)'.*serializedMask; a1; b1];
% red = reshape(maskedMedCol1', m, n, 3);
% 
% serializedMask = green_mask(:)';
% g_c = final_img(:,:,2);
% maskedMedCol1 = [a2; g_c(:)'.*serializedMask; b2];
% green = reshape(maskedMedCol1', m, n, 3);
% 
% serializedMask = blue_mask(:)';
% b_c = final_img(:,:,3);
% maskedMedCol1 = [a3; b3; b_c(:)'.*serializedMask; ];
% blue = reshape(maskedMedCol1', m, n, 3);
% 
% final_cor = red + green + blue;
% 
% imshow(final_cor)



% generalize this for other channels
% sum up
% reshape
%% Assignement 2.3


%% Assignement 2.4


%% Bonus
