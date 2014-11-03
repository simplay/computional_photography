function [ out ] = gradientMixing( target, source, mask)
%GRADIENTMIXING Summary of this function goes here
%   Detailed explanation goes here

    M = size(target,1); N = size(target,2);
    out = zeros(M,N,3);

    gradFieldTarget = img2gradfield(target);
    gradFieldSource = img2gradfield(source);
    gradField = max(gradFieldTarget, gradFieldSource);
    
    tic
    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), ...
                                   gradField(:,:,:,k), mask(:,:,k), 1E-3);
    end
    toc
    
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));
end

