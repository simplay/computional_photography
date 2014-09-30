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
   
%% Assignement 2.3
figure(5)
img = imread('imgs/interior.jpg');
img = im2double(img);
img = grayWorld(img);
imshow(img);
title('color balancing: gray world assumption');

figure(6)
img = imread('imgs/interior.jpg');
img = im2double(img);
img = manualWhiteBalance(img, [155, 200]);
imshow(img);
title('color balancing: manual white balancing');

%% Assignement 2.4
figure(7)
img = imread('imgs/castle.jpg');
img = im2double(img);
img = linearContrast(img, 0.2, 0.8);
imshow(img);
title('linear color contrast scaling');

%% Bonus
