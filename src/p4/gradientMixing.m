function [ out ] = gradientMixing( target, source, mask)
%GRADIENTMIXING Summary of this function goes here
%   @param target is background image
%          on top of this image the gradient will be plotted.

    M = size(target,1); N = size(target,2);
    out = zeros(M,N,3);

    gradFieldTarget = img2gradfield(target);
    gradFieldSource = img2gradfield(source);
    
    gf = zeros(M,N,2,3);
    for m=1:M,
        for n=1:N,
            for c=1:3,
                gfT = gradFieldTarget(m,n,:,c);
                gfS = gradFieldSource(m,n,:,c);
                
                if abs(gfT(:,:,1,:)) > abs(gfS(:,:,1,:))
                    gf(m,n,1,c) = gfT(:,:,1,:);
                else
                    gf(m,n,1,c) = gfS(:,:,1,:);
                end
                
                if abs(gfT(:,:,2,:)) > abs(gfS(:,:,2,:))
                    gf(m,n,2,c) = gfT(:,:,2,:);
                else
                    gf(m,n,2,c) = gfS(:,:,2,:);
                end
                
            end
        end
    end
    
    % this gives a nice relief effect along the gradient.
    %gradField = max(abs(gradFieldTarget), abs(gradFieldSource));
    
    
    tic
    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), ...
                                   gf(:,:,:,k), mask(:,:,k), 1E-1);
    end
    toc
    
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));
end

