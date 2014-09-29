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

imshow(final_img);


% conv2 image by same ones(3)

% Proceed similarly...

%% Assignement 2.2
% we are interested in red green and blue green differences
% thus
% transform into y u v colors space
img = imread('imgs/black and white raw.tif');
img = double(img) / 255.0;

[final_img, red_c, green_c, blue_c] = demosaicBayer(img);
yuv_final = rgb2yuv(final_img);

% median filtered imgs
medU = medfilt2(yuv_final(:,:,2));
medV = medfilt2(yuv_final(:,:,3));

rgb2yuv_transform = [0.299 0.587 0.114; 
                     -0.14713 -0.28886 0.436; 
                      0.615 -0.51499 -0.10001];
                  
                  

    [m, n, c] = size(yuv_final);
    blue_mask = zeros(m, n);
    blue_mask(2:2:end, 2:2:end) = 1;

    green_mask = zeros(m, n);
    green_mask(2:2:end, 1:2:end) = 1;
    green_mask(1:2:end, 2:2:end) = 1;

    red_mask = zeros(m, n);
    red_mask(1:2:end, 1:2:end) = 1;
    
%red part
red_known = rgb2yuv_transform(2:end, 2:end);
red_v = rgb2yuv_transform(2:end, 1);

green_known = rgb2yuv_transform(2:end, 1:2:end);
green_v = rgb2yuv_transform(2:end, 2);

blue_known = rgb2yuv_transform(2:end, 1:end-1);
blue_v = rgb2yuv_transform(2:end, 3);

[a1,b1] = foobarize(final_img(:,:,1), red_known, medU, medV, red_v, red_mask);
[a2,b2] = foobarize(final_img(:,:,2), green_known, medU, medV, green_v, green_mask);
[a3,b3] = foobarize(final_img(:,:,3), blue_known, medU, medV, blue_v, blue_mask);


serializedMask = red_mask(:)';
maskedMedCol1 = [final_img(:,:,1)'.*serializedMask; a1; b1];
red = reshape(maskedMedCol1', m, n, 3);

serializedMask = green_mask(:)';
maskedMedCol1 = [a2; final_img(:,:,2).*serializedMask; b2];
green = reshape(maskedMedCol1', m, n, 3);

serializedMask = blue_mask(:)';
maskedMedCol1 = [a3; b3, final_img(:,:,3).*serializedMask; ];
blue = reshape(maskedMedCol1', m, n, 3);

final_cor = red + green + blue;

imshow(final_cor)



% generalize this for other channels
% sum up
% reshape
%% Assignement 2.3


%% Assignement 2.4


%% Bonus
