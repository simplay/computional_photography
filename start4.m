% Computational Photography Project 4
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;
addpath('util/');
addpath('src/p4/');

% 50,550

%% task 1
source = imread('imgs/airplane.jpg');
source = im2double(source);
source = imresize(source, 0.10);
m = size(source,1); n = size(source,2);

target = imread('imgs/landsacpe.jpg');
target = im2double(target);


S = zeros(1000,1600,3);
S(101:200, 701:860,:) = source(:,:,:);

%yuvImg = rgb2yuv(S);
%yImg = yuvImg(:,:,1);

mask = ones(1000,1600);
mask(100:200, 700:860) = 0;

out = zeros(1000,1600,3);

[dx, dy] = mat2gradfield(S(:,:,1));
gradField(:,:,1,1) = [dx;zeros(1,1600)];
gradField(:,:,2,1) = [dy, zeros(1000,1)];

[dx, dy] = mat2gradfield(S(:,:,2));
gradField(:,:,1,2) = [dx;zeros(1,1600)];
gradField(:,:,2,2) = [dy, zeros(1000,1)];
    
[dx, dy] = mat2gradfield(S(:,:,3));
gradField(:,:,1,3) = [dx;zeros(1,1600)];
gradField(:,:,2,3) = [dy, zeros(1000,1)];
    
gf(:,:,:,1) = (imfilter(S, [-1,1], 'same'));    
gf(:,:,:,2) = (imfilter(S, [-1,1], 'same')); 

    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), gradField(:,:,:,k), mask);
    end
%out(:,:,1) = poissonSolver(target(:,:,1), gradField, mask);
%out(:,:,2) = poissonSolver(target(:,:,2), gradField, mask);
%out(:,:,3) = poissonSolver(target(:,:,3), gradField, mask);

daImg = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));
figure
imshow(daImg)
