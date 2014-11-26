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
numberOfFrames = 3;

target = imread('imgs/p5/dude.jpg');
target = im2double(target);

source = imread('imgs/p5/pig.jpg');
source = im2double(source);
source = imresize(source, [size(target,1),size(target,2)]);
    
makeMorphingVideo(source, target, numberOfFrames)   

%% Task 2


%% Task 3

