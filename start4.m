clc
clear all;
close all;
addpath('util/');
addpath('p4/');

img = imread('imgs/rock.png');
img = im2double(img);
yuvImg = rgb2yuv(img);
yImg = yuvImg(:,:,1);
dy = yImg(:, 2:end) - yImg(:, 1:end-1);
dx = yImg(2:end,:) - yImg(1:end-1,:);