% Computational Photography Project 5
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;

% load dependencies
% uncomment the next code line in case you have not installed vlfeat yet.
% run lib/vlfeat-0.9.19/toolbox/vl_setup 

addpath('util/');
addpath('lib/');
addpath('src/p5/');

%% Task 1: Morphing

% load target and source images used for morphing
numberOfFrames = 20;
fileName = 'morph1';
target = imread('imgs/p5/dude.jpg');
target = im2double(target);

source = imread('imgs/p5/pig.jpg');
source = im2double(source);
source = imresize(source, [size(target,1),size(target,2)]);
    
makeMorphingVideo(source, target, numberOfFrames, fileName)   

%% Task 2: Rectification using Homography
img2Rectify = imread('imgs/p5/tower.jpg');
img2Rectify = im2double(img2Rectify);

[M,N,~] = size(img2Rectify);
figure('name', 'Image to Rectify')
imshow(img2Rectify);
[p_xs, p_ys] = ginput(4);
selectedSourceHomogPoints = [p_xs, p_ys, ones(4,1)]';
cornerHomogPoints = [arrays2pairs([1,N],[1,M])';ones(1,4)];
% performs Rectification
out = homographicRectification(img2Rectify, selectedSourceHomogPoints, cornerHomogPoints);
figure('name', 'Rectificated image')
imshow(out);
[x,y] = ginput(2);
croppedRect = imcrop(out,[min(x),min(y),max(x)-min(x),max(y)-min(y)]);
figure('name', 'cropped rectificated image')
imshow(croppedRect)


%% Task 3: Panorama Stitching
% We assume that the left and the right image have the same dimensionality.
left = imread('imgs/p5/panorama_left_1.jpg');
left = im2double(left);
left = imresize(left, 0.25);
right = imread('imgs/p5/panorama_right_1.jpg');

right = im2double(right);
right = imresize(right, 0.25);
panorama = panoramaStitching(left, right);
figure('name', 'stitched img raw');
imshow(panorama);
[x,y] = ginput(2);
panorama = imcrop(panorama,[min(x),min(y),max(x)-min(x),max(y)-min(y)]);
figure('name', 'panorama')
imshow(panorama)


