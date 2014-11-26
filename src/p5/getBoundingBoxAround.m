function [ boundingBoxIndices, left, right, top, bottom ] = getBoundingBoxAround( fragment )
%GETBOUNDINGBOXAROUND Summary of this function goes here
%   @param fragment
    
% triangulated image With boundaries Right, Top, Bottom, Left.
% (L,T)----- a--b ---(R,T)
%   |        | /       |
%   |        c         | 
%   |                  |
% (L,B)--------------(R,B)
% find box envelopping the triangle a-b-c.

    % l x1--------x2 r
    left = floor(min(fragment(1,:)));
    right = ceil(max(fragment(1,:)));
    
    % t x1--------x2 b
    top = floor(min(fragment(2,:)));
    bottom = ceil(max(fragment(2,:)));
    
    % get all (x,y) pair combinations
    boundingBoxIndices = arrays2pairs(left:right, top:bottom)';
end

