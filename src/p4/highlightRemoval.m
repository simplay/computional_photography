function [ out ] = highlightRemoval(target, mask, alpha)
%HIGHLIGHTREMOVAL remove highlights in a given target image by applying
%alpha compression on the gradients of the target image.
%   @param target image that contains a certain spot/area
%          which is supposed to be too bright (e.g. specular spot).
%          this spot is windowed by the mask and its brightness is adjusted
%          by applying alpha compression.
%   @param mask determines the boundary for the unknown pixels which should
%          be solved for using our poisson solver.
%   @param alpha real number determing the compression factor used for
%          alpha compression.
%   @return out image with adjusted brightness.
%   Detailed explanation goes here

    gradField = img2gradfield(target);
    
    % gradients can be negative valued. When taking the power to a rational
    % number the result may become complex valued. thus take only their real part.
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

