% Computational Photography Project 5
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;

% load dependencies
addpath('util/');
addpath('src/p5/');


fileName = 'data/p5/morph1.mat';
selectNewPoints = false;


% load target and source images used for morphing
target = imread('imgs/p5/dude.jpg');
target = im2double(target);

source = imread('imgs/p5/pig.jpg');
source = im2double(source);

source = imresize(source, [size(target,1),size(target,2)]);


% Start Control Point Selection tool with images and control points 
% stored in variables in the workspace.
[M,N,~] = size(source);

if exist(fileName,'file') && ~selectNewPoints
    load(fileName)
else
    % (x,y) points i.e. (column-idx,row-idx)
    sourcePoints = [1,1; N,1; 1,M; N,M];
    targetPoints = [1,1; N,1; 1,M; N,M];

    % Ask cpselect to wait for you to pick some more points
    
    % If set to FALSE (the default) you can
    % run cpselect at the same time as you run other 
    % programs in MATLAB.
    [sourcePoints, targetPoints] = cpselect(source, target, ...
                                            sourcePoints, targetPoints, ...
                                            'Wait', true);
    % save points
    save(fileName,'sourcePoints','targetPoints');
end

