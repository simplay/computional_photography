% Computational Photography Project 2
% Turned in by <Michael Single>
% Legi: 08-917-445
%
% Info:
% I have implemented the following functions
%
% bilateral filtering functions:
% demoBilateralFilter
% bfilt - 1d imgs
% bfiltImg3 - 3d imgs (color imgs)
% bilateralFilter - automatically determining img dim

% tone mapping functions:
% genToneMapping - series of different sigma values
% hdrToneMapping - also non hdr imgs using a bilat. filter
% hdrToneMappingGaussian - also non hdr imgs using a gaussian kernel

% tone adjustment functions:
% automatedToneAdjustment - generalized helper
% simpleautooneAdjustment - directly matching histograms
% toneAdjColChanWise - match each color channel 
% toneAdjColorImgSigmas - hist matching for a series of sigma values
% toneAdjustmentColorImg - for color images
%
% util functions:
% arrays2pairs - get all pair combinations of two vectors
% getRanges - get neighborhood from given input

clc;
clear all;
close all;

addpath('util/');
addpath('src/p2');

%% Task2
% bilateral filter
img = imread('imgs/Bigel11.jpg');
%img = imread('imgs/rock.png');
img2 = double(img)/255;

sigma_s = [2, 6, 18];
sigma_r = [0.1, 0.25, 10000];
% red channel of rocks imgs
demoBilateralFilter(img2(:,:,1), sigma_s, sigma_r);

% bilat. filter luminance channel of rocks. 
yuvImg = rgb2yuv(img2);
demoBilateralFilter(yuvImg(:,:,1), sigma_s, sigma_r);

img = imread('imgs/castle.jpg');
img2 = double(img)/255;
figure
% blurry castle
imshow(bilateralFilter(img2, 2, 4))
%figure(1)
%imshow(img3)

% tone mapping task
hdrImg = hdrread('imgs/dani_belgium_oC65.hdr');

% tone mapping gaussian
figure(2345)
imshow(hdrToneMappingGaussian(hdrImg,30))

% tone mapping bilat. filter
figure(1337)
imshow(hdrToneMapping(hdrImg,30))

%% bonus task 2
% please show all images by your own by using 
% imshow(imgs(:,:,:,idx)) where idx denotes the index of interest.
% E.g imshow(imgs(:,:,:,8)) shows the 8th img in imgs.
imgs = genToneMapping(hdrImg, 30, [2,4,8], [0.12, 0.25, 100]);

%% task 3
% tone adjustment - awesomification
awesomeImg = imread('imgs/winterstorm.png');
awesomeImg = double(awesomeImg)/255;
baseImg = imread('imgs/rock.png');
baseImg = double(baseImg)/255;

advOut = toneAdjustmentColorImg(baseImg, awesomeImg, 1);
simpleOut = simpleautoToneAdjustment(baseImg, awesomeImg);

figure(1000)
imshow(advOut)

figure(1001)
imshow(simpleOut)

%% bonus tasks
% bonus task 2a) tone mappings for a series of sigmas
% E.g imshow(imgs(:,:,:,8)) shows the 8th img in imgs.
imgs1 = genToneMapping(hdrImg, 30, [2,4,8], [0.12, 0.25, 100]);

% bonus task 2b) tone adjustment for a series of sigmaas
% E.g imshow(imgs(:,:,:,8)) shows the 8th img in imgs.
imgs2 = toneAdjColorImgSigmas(baseImg, awesomeImg, 1, [2,4,8], [0.12, 0.25, 100]);


% bonus task 4)
figure
img = toneAdjColChanWise(baseImg,awesomeImg,2.5);
imshow(img)