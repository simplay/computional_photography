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
numberOfFrames = 60;
fileName = 'uglification2';
% target = imread('imgs/p5/dude.jpg');
% target = im2double(target);

% source = imread('imgs/p5/pig.jpg');
% source = im2double(source);
% source = imresize(source, [size(target,1),size(target,2)]);

source = imread('imgs/p5/from.png');
source = imresize(source, 0.5);
source = im2double(source);
target = imread('imgs/p5/to.png');
target = imresize(target, 0.5);
target = im2double(target);

makeMorphingVideo(source, target, numberOfFrames, fileName)   

%% Task 2: Rectification using Homography
img2Rectify = imread('imgs/p5/skewed_church.jpg');
img2Rectify = im2double(img2Rectify);
img2Rectify = imresize(img2Rectify, 0.25);

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
disp('please select 4 points in the following order:');
disp('1. The top left position');
disp('2. The bottom left position');
disp('3. The top right position');
disp('4. The bottom right position');
disp('Note: Positions are not allowed to overlap.');

% let the user crop the image.
[x,y] = ginput(2);
croppedRect = imcrop(out,[min(x),min(y),max(x)-min(x),max(y)-min(y)]);
figure('name', 'cropped rectificated image')
imshow(croppedRect)

% Display user selection
figure('name', 'User selection (blue points) in distorted image,')
imshow(img2Rectify)
hold on
plot([p_xs(1), p_xs(2)], [p_ys(1), p_ys(2)], 'r');
plot([p_xs(3), p_xs(4)], [p_ys(3), p_ys(4)], 'r');
plot([p_xs(1), p_xs(3)], [p_ys(1), p_ys(3)], 'r');
plot([p_xs(2), p_xs(4)], [p_ys(2), p_ys(4)], 'r');
plot(p_xs(1),p_ys(1),'.b');
plot(p_xs(2),p_ys(2),'.b');
plot(p_xs(3),p_ys(3),'.b');
plot(p_xs(4),p_ys(4),'.b');

%% Task 3: Panorama Stitching
% We assume that the left and the right image have the same dimensionality.
left = imread('imgs/p5/panorama_left_1.jpg');
left = im2double(left);
left = imresize(left, 0.25);
right = imread('imgs/p5/panorama_right_1.jpg');

right = im2double(right);
right = imresize(right, 0.25);
panorama = panoramaStitching(left, right);
disp('Please specify two points in order to crop the stiched image.');
figure('name', 'stitched img raw');
imshow(panorama);
[x,y] = ginput(2);
panorama = imcrop(panorama,[min(x),min(y),max(x)-min(x),max(y)-min(y)]);
figure('name', 'panorama')
imshow(panorama)
