function [ out ] = gradientMixing( target, source, mask)
%GRADIENTMIXING Perform gradient mixing: Combine properties the properties
%of a given images on top of another image (for example add details to a
%texture).
%   We assume that all given images are of the same dimensionality.
%   @param target is background image (3 color channels)
%          on top of this image the gradient will be plotted.
%   @param source is supposed to be an image representing some detailed
%          that should be mixed on top of the given target image.
%   @param mask boundary condition: border is one, rest is zero.
%   @return out image with adjusted gradient field according to
%   description.

    M = size(target,1); N = size(target,2);
    out = zeros(M,N,3);
    
    % compute gradient field of both images, source and target
    gradFieldTarget = img2gradfield(target);
    gradFieldSource = img2gradfield(source);
    
    % compute combined gradient field for gradient mixing
    % v_pq := [abs(f_p - f_q) > abs(g_p - g_q)] ? (f_p - p_q) 
    %                                           : (g_p - g_q)
    gf = zeros(M,N,2,3);
    for m=1:M,
        for n=1:N,
            for c=1:3,
                % get gradient of current pixels for current color channel
                gfT = gradFieldTarget(m,n,:,c);
                gfS = gradFieldSource(m,n,:,c);
                
                % determine max dx
                if abs(gfT(:,:,1,:)) > abs(gfS(:,:,1,:))
                    gf(m,n,1,c) = gfT(:,:,1,:);
                else
                    gf(m,n,1,c) = gfS(:,:,1,:);
                end
                
                % determine max dy
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

