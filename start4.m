% Computational Photography Project 4
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;
addpath('util/');
addpath('src/p4/');


%% task 1.2 Seamless Cloning

% determines boundary
mask = imread('imgs/p4/seamless_cloning/mask.png');
mask = im2double(mask);

% patch we place into target
source = imread('imgs/p4/seamless_cloning/source.png');
source = im2double(source);

% image that gets modified
target = imread('imgs/p4/seamless_cloning/target.png');
target = im2double(target);

figure('Position', [100, 100, 1024, 800], ...
       'name', 'Seamless Cloning: Input')
g = subplot(1,3, 1);
subimage(target)
fig_title = strcat('Target');
xlabelHandler = get(g,'XLabel');
set( xlabelHandler, 'String', fig_title); 
set(gca,'xtick',[],'ytick',[]);

g = subplot(1,3, 2);
subimage(source)
fig_title = strcat('Source');
xlabelHandler = get(g,'XLabel');
set( xlabelHandler, 'String', fig_title); 
set(gca,'xtick',[],'ytick',[]);

g = subplot(1,3, 3);
subimage(mask)
fig_title = strcat('Mask');
xlabelHandler = get(g,'XLabel');
set( xlabelHandler, 'String', fig_title); 
set(gca,'xtick',[],'ytick',[]);

out = seamlessCloning(target, source, mask);
figure('Position', [100, 100, 1024, 800], ...
       'name', 'Seamless Cloning: Output')
imshow(out)


%% task 1.3: Gradient Mixing.
source = imread('imgs/p4/gradient_mixing/i1.png');
source = im2double(source);

target = imread('imgs/p4/gradient_mixing/i2.png');
target = im2double(target);

M = size(target, 1); N = size(target, 2);

mask = zeros(M,N);
mask(1:end, 1) = 1;
mask(1:end, end) = 1;
mask(1, 1:end) = 1;
mask(end, 1:end) = 1;
mask = mat2Img(mask(:,:), mask(:,:), mask(:,:));
out = gradientMixing(target, source, mask);
figure('name', 'Gradient Mixing: Output')
imshow(out)


%% task 1.4: Highligh Removal
alpha = 1.2;

target = imread('imgs/orange.jpg');
target = im2double(target);
mask = imread('imgs/orange_mask.jpg');
mask = im2double(mask);

out = highlightRemoval(target, mask, alpha);
figure('name', strcat('highlight removal using alpha= ', num2str(alpha) ))
imshow(out)

%% task 2.1
