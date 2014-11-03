function [ out ] = highlightRemoval(target, mask, alpha)
%HIGHLIGHTREMOVAL Summary of this function goes here
%   Detailed explanation goes here

    gradField = img2gradfield(target);
    gradField = real(gradField.^alpha);
    
    M = size(target,1); N = size(target,2);
    out = zeros(M,N,3);
    tic
    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), gradField(:,:,:,k), mask(:,:,k));
    end
    toc
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));

end

