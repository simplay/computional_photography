function [ red_mask, green_mask, blue_mask ] = getMasks( m, n )
%GETMASKS Bayer color filters as n x m matrices.
    % @param m, n are natural numbers > 0.
    blue_mask = zeros(m, n);
    blue_mask(2:2:end, 2:2:end) = 1;

    green_mask = zeros(m, n);
    green_mask(2:2:end, 1:2:end) = 1;
    green_mask(1:2:end, 2:2:end) = 1;

    red_mask = zeros(m, n);
    red_mask(1:2:end, 1:2:end) = 1;
end

