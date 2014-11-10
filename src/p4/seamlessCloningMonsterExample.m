function seamlessCloningMonsterExample
%SEAMLESSCLONINGMONSTEREXAMPLE Summary of this function goes here
%   Detailed explanation goes here


clc
clear all;
close all;

% load dependencies
addpath('util/');
addpath('src/p4/');
addpath('lib/GCMex/');



    baseX=1000;
    baseY=1000;

    source = imread('imgs/p4/monster2.jpg');
    source = im2double(source);
    

    
    source = imresize(source, 0.6);
    m = size(source,1); n = size(source,2);

    target = imread('imgs/p4/wide_grass.jpg');
    target = im2double(target);

    M = size(target,1); N = size(target,2);

    % image mask    
    mask = zeros(size(source,1),size(source,2));
    [I,J] = find(abs(source(:,:,1)-1) < 0.01);
    for k=1:length(J),
        mm = I(k);
        nn = J(k);
        mask(mm,nn) = 1; 
    end
    mask = mat2Img(mask(:,:),mask(:,:),mask(:,:));
    %mask = imresize(mask, [40,40]);
    Ma = ones(M,N,3);
    Ma((baseX+1+8):(baseX+m+8), (baseY+1+8):(baseY+n+8),:) = mask(:,:,:);
    
 
    source = imresize(source, 1.1);
    m = size(source,1); n = size(source,2);
    % zero-pad source image. Keep source in S at position where mask is
    % selecting.
    S = ones(M,N,3);
    S((baseX+1):(baseX+m), (baseY+1):(baseY+n),:) = source(:,:,:);

    % running 
    % seamlessCloning(target, S, mask, 1);
    % will compute an initial guess based on downsampling
    out = seamlessCloning(target, S, Ma);
    figure('name', 'Seamless Cloning')
    imshow(out)

end

