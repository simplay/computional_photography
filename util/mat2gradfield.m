function [ dx, dy ] = mat2gradfield( matrix )
%MAT2GRADFIELD compute the gradient field along each direction dx, dy of a
%matrix.
%   @param matrix is a [m x n] matrix
%   @return dx a [(m-1) x n] matrix
%   @return dy a [m x (n-1)] matrix

    dx = matrix(:, 2:end) - matrix(:, 1:end-1);
    dx = [matrix(:, end),dx];
    dy = matrix(2:end,:) - matrix(1:end-1,:);
    dy = [dy; matrix(end,:)];
    
end

