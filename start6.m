% Computational Photography Project 6
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;

addpath('util/');
addpath('src/p6/');

lightFieldData = readLightFieldData('data/p6/trees');

%% task 1.1
[M,N,~,numFrames] = size(lightFieldData);
showLightFieldMovie(lightFieldData);

%% task 1.2 && task 1.3
randomRowselectCount = 4;
[epiImages, selectedLineNrs] = computeEPI(lightFieldData, M, ...
                                          randomRowselectCount, numFrames);
showEPI(lightFieldData, epiImages, selectedLineNrs);    

                                      