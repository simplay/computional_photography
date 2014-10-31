function [ pairs ] = arrays2pairs( left, right )
%ARRAYS2PAIRS get all pair combinations of the vectors left and right. 
%   @param left row vector
%   @param right row vector
%   @return gives us a (m*n x 2) matrix representing 
%       the cartesian product of the given two vectors left and right.
%       i.e. all possible pair combinations of the two provided vectors.
%       the first column (i.e. the left column) contains ordered values
%       (successive) from the first vector left, similarly the 2nd column
%       (right) which contains only values (successive) from the 2nd vector
%       right.
%
% E.g. given left = [1, 2, 3]
%             right = [4, 5] 
% arrays2pairs(left, right)
% ans =
%     1     4
%     1     5
%     2     4
%     2     5
%     3     4
%     3     5

    [p,q] = meshgrid(left, right);
    pairs = [p(:) q(:)];
end