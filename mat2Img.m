function [ img ] = mat2Img( A, B, C )
%MAT2IMG takes 3 (m x n) Matrices and reshapes them to an (m x n x 3) Image.
%   A, B, and C are (m x n) matrices. 
%   Possible application: Conversion from R, G and B color channels to an image.
    
    % get dimensions [m, n]
    [m, n] = size(A);
    
    % reshape from 3(m x n) to (m x n x 3)
    img = reshape([A,B,C], m, n, 3);
end

