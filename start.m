% Computational Photography Project 1
% Turned in by <Michael Single>
% Legi: 08-917-445

%% Assignement 1
clc;
clear all;
close all;

addpath('util/');
addpath('src/p1');


% spanish castle illusion.
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

% linear interpolated demosaiced img.
img = imread('imgs/foliage raw.tiff');
img = double(img) / 4096.0;
final_img = demosaicBayer(img);
figure(3)
imshow(final_img);
title('demosaiced img linear filtered');

%% Assignement 2.2

% median filtered demosaiced img
img = imread('imgs/black and white raw.tif');
img = double(img) / 255.0;
img = medianFilteredDemosaic(img);
figure(4)
imshow(img)
title('demosaiced img bayer filtered');
   
%% Assignement 2.3

% color balancing based on the gray world assimption.
figure(5)
img = imread('imgs/interior.jpg');
img = im2double(img);
img2 = grayWorld(img, 1);
imshow(img2);
title('color balancing: gray world assumption green norm');

figure(135)
img2 = grayWorld(img, 0);
imshow(img2);
title('color balancing: gray world assumption without green norm');

% manual color balancing task
figure(6)
img = imread('imgs/interior.jpg');
img = im2double(img);
img = manualWhiteBalance(img, [155, 200]);
imshow(img);
title('color balancing: manual white balancing');

%% Assignement 2.4

% linear contrast correction task.
figure(7)
img = imread('imgs/castle.jpg');
img = im2double(img);
img = linearContrast(img, 0.2, 0.8);
imshow(img);
title('linear color contrast scaling');

% gamma correction task.
figure(8)
img = imread('imgs/airport.jpg');
img = im2double(img);
img = mat2Img(img, img, img);
img = gammaTransformation(img, 4.0);
imshow(img);
title('gamma correction');

% Show various gamma plots for a given input img
figure(1337)
img = imread('imgs/airport.jpg');
img = im2double(img);
img = mat2Img(img, img, img);
plotSeries(img, 0, 8);

%% Bonus

sRGBAdobe = [2.3642, -0.8964, -0.4680;
            -0.5151, 1.4262, 0.0887;
             0.0052, -0.0144, 1.0090];

% demosaiced img using adobe sRGB with gamma correction + color balancing.
img = imread('imgs/foliage raw.tiff');
img = double(img) / 4096.0;
img = demosaicBayer(img);
img = gammaTransformation(transformImg3(grayWorld(img,1),sRGBAdobe), 1/1.2);

figure(33)
imshow(img);
title('gamma and white balanced correcte demosaiced img using Adobe sRGB colors');


%% gui stuff

% let a user select a target pixel for manual white balancing.
t = figure(9);
img = imread('imgs/interior.jpg');
img = im2double(img);
imshow(img)
img = manColBalGui(img, t);
imshow(img);
title('user sel');

% load gamma correction GUI - user may choose different gamma correction levels.
simpleGammaCorrectionGui



