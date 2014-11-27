function mask = computeBlendingMask( M, N )
%COMPUTEBLENDINGMASK as described in the slides
%   @param M positive integer first dimension of image
%   @param N positive integer 2nd dimension of image
%   @return corresponding bleeding mask

    mask = zeros(M,N);
    
    % top boundary is one
    mask(1, :) = 1;
    
    % bottom boundary is one
    mask(end, :) = 1;
    
    % left boundary is one
    mask(:, 1) = 1;
    
    % right boundary is one
    mask(:, end) = 1;
    
    % computes the Euclidean distance transform of the mask: For each pixel in BW, the distance transform assigns
    % a number that is the distance between that pixel and the nearest nonzero pixel in the mask.
    mask = bwdist(mask);
    
    % formulate image blending mask from slide 64:
    mask = mask .* mask;
    mask = mask ./ max(max(mask));
end

