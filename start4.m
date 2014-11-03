% Computational Photography Project 4
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;
addpath('util/');
addpath('src/p4/');


%% task 1.2: seamless cloning
baseX=550;
baseY=850;

source = imread('imgs/airplane.jpg');
source = im2double(source);
source = imresize(source, 0.05);
m = size(source,1); n = size(source,2);

target = imread('imgs/landsacpe.jpg');
target = im2double(target);

M = size(target,1); N = size(target,2);

% image mask
mask = ones(M,N);
mask((baseX+1):(baseX+m), (baseY+1):(baseY+n)) = 0;

% zero-pad source image. Keep source in S at position where mask is
% selecting.
S = zeros(M,1600,3);
S((baseX+1):(baseX+m), (baseY+1):(baseY+n),:) = source(:,:,:);


out = seamlessCloning(target,S,mask);
figure('name', 'Seamless Cloning')
imshow(out)

%% task 1.3:  gradient mixing.

%% task 1.4: highligh removal
alpha = 1.2;

img = imread('imgs/orange.jpg');
img = im2double(img);
mask = imread('imgs/orange_mask.jpg');
mask = im2double(mask);

out = highlightRemoval(img,mask, alpha);
figure('name', strcat('highlight removal using alpha= ', num2str(alpha) ))
imshow(out)