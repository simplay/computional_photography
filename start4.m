% Computational Photography Project 4
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;
addpath('util/');
addpath('p4/');

%% task 1
img = imread('imgs/rock.png');
img = im2double(img);
yuvImg = rgb2yuv(img);
yImg = yuvImg(:,:,1);

[dx, dy] = mat2gradfield(yImg);
