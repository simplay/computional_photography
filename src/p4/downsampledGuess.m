function [ out ] = downsampledGuess( target, source, mask)
%INITIALGUESS Summary of this function goes here
%   Detailed explanation goes here
    M = size(target,1); N = size(target,2);
    gradField = img2gradfield(imresize(source, 0.5));
    tar = imresize(target, 0.5);    
    ma = imresize(mask, 0.5);
    
    out = zeros(M,N,3);
    parfor k=1:3
        currK = poissonSolver(tar(:,:,k), gradField(:,:,:,k), ma(:,:,k), 1E-6);
        out(:,:,k) = imresize(currK, 2)
    end
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));

end

