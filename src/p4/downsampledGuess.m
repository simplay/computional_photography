function [ out ] = downsampledGuess( target, source, mask)
%INITIALGUESS Summary of this function goes here
%   Detailed explanation goes here
    M = size(target,1); N = size(target,2);
    reso = ceil([M,N]/2);
    gradField = img2gradfield(imresize(source, reso));
    tar = imresize(target, reso);    
    ma = imresize(mask, reso);
    
    out = zeros(M,N,3);
    parfor k=1:3
        currK = poissonSolver(tar(:,:,k), gradField(:,:,:,k), ma(:,:,k), 1E-6);
        out(:,:,k) = imresize(currK, [M,N])
    end
    antiMask = (1-mask);
    
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));
    out = (mask .* target)+(out .* antiMask);
end

