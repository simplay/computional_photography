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
med_U = medfilt2(yuv_final(:,:,2));
med_V = medfilt2(yuv_final(:,:,3));

rgb2yuv_transform = [0.299 0.587 0.114; 
                     -0.14713 -0.28886 0.436; 
                      0.615 -0.51499 -0.10001];
                  
                  

                  
%red part
red_known = rgb2yuv_transform(2:end, 2:end);
red_v = rgb2yuv_transform(2:end, 1);
red = red_c;%final_img(:,:,1);
U_red = red_v(1)*red;
V_red = red_v(2)*red;

del_U = med_U-U_red;
del_V = med_V-V_red;
A = reshape([del_U(:),del_V(:)], 1000, 500)';
rr = red_known\[del_U(:),del_V(:)]';
% mask it for red channel

serialized_red_mask = red_mask(:)';

abc = [red(:)'.*serialized_red_mask; rr(1,:).*serialized_red_mask; rr(2,:).*serialized_red_mask];
ttt = reshape(abc', 500, 500, 3);


%blue
red = blue_c;%final_img(:,:,3);
red_known = rgb2yuv_transform(2:end, 1:end-1);
red_v = rgb2yuv_transform(2:end, 3);

U_red = red_v(1)*red;
V_red = red_v(2)*red;

del_U = med_U-U_red;
del_V = med_V-V_red;
A = reshape([del_U(:),del_V(:)], 1000, 500)';
rr = red_known\[del_U(:),del_V(:)]';
% mask it for red channel
    blue_mask = zeros(500, 500);
    blue_mask(2:2:end, 2:2:end) = 1;
serialized_red_mask = blue_mask(:)';



abc = [red(:)'.*serialized_red_mask; rr(1,:).*serialized_red_mask; rr(2,:).*serialized_red_mask];
ttt = ttt + reshape(abc', 500, 500, 3);



% green
red = green_c;%final_img(:,:,2);
red_known = rgb2yuv_transform(2:end, 1:2:end);
red_v = rgb2yuv_transform(2:end, 2);

U_red = red_v(1)*red;
V_red = red_v(2)*red;

del_U = med_U-U_red;
del_V = med_V-V_red;
A = reshape([del_U(:),del_V(:)], 1000, 500)';
rr = red_known\[del_U(:),del_V(:)]';
% mask it for red channel
    green_mask = zeros(500, 500);
    green_mask(2:2:end, 1:2:end) = 1;
    green_mask(1:2:end, 2:2:end) = 1;
serialized_red_mask = green_mask(:)';



abc = [red(:)'.*serialized_red_mask; rr(1,:).*serialized_red_mask; rr(2,:).*serialized_red_mask];
ttt = ttt + reshape(abc', 500, 500, 3);























imshow(ttt)
% generalize this for other channels
% sum up
% reshape
%% Assignement 2.3


%% Assignement 2.4


%% Bonus
