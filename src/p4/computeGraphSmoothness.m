function [ pairwise ] = computeGraphSmoothness( img, colors )
% a P x P sparse matrix specifiying the graph structure and cost for each
% link between nodes in the graph. Stores the smoothness term in this
% matrix. For each pair of intersecting pixels, this matrix contains the
% penalty if the labels of the pixels do not agree. 
% @param img
% @param colors
% return colors

% paramters for the penalty term
beta = getBetaFromColorVar(colors);
gamma = 5;

% Global indices
M = size(img, 1);
N = size(img, 2);
pixelCount = M*N;

% initializations components of spare matrix
A_value = zeros(8*pixelCount, 1);
A_i = zeros(8*pixelCount, 1);
A_j = zeros(8*pixelCount, 1);

% local helper indices
index = 0;
rowIndex = 0;
pixelIdx = 0;

% traverse the pixels in the image column-wise from top to bottom.
for n=1:N
    for m=1:M
        pixelIdx = pixelIdx + 1;

        % create the equations for the pixel (x,y) and it's 8 neighbors
        rowIndex = rowIndex + 1;
        img_mn = img(m,n);

        if hasTopLeftN(m,n) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n-1));    
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx - M - 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasLeftN(m) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m,n-1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx - M;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasBotLeftN(m,n,N) == 1
           index = index+1;
           dist2 = computeDist2(img_mn, img(m+1,n-1));
           A_i(index) = rowIndex;
           A_j(index) = pixelIdx - M + 1;
           A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasTopN(n) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx - 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasBotN(n,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m+1,n));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasTopRightN(m,n,M,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n+1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + M - 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasRightN(m,M) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m,n+1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + M;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasBotRightN(m,n,M,N) == 1
            index = index+1;
            dist2 = computeDist2(img_mn, img(m+1,m+1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + M + 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

    end
end

% resize the vector since too much memory was allocated
A_i = A_i(1:index);
A_j = A_j(1:index);
A_value = A_value(1:index);

% create the sparse matrix pairwise
pairwise = sparse(A_i, A_j, A_value, pixelCount, pixelCount);

end

% Neighborhood labels for a given pixel p.
% ===============
% | tl | t | tr |
% |  l | p |  r |
% | bl | b | br |
% ===============

% Neighborhood queries.

function has = hasLeftN(m)
% @return has is there a left neighbor [l]?
    has = m > 1;
end

function has = hasRightN(m, M)
% @return has is there a right neighbor [r]?
    has = (m < M);
end

function has = hasTopN(n)
% @return has is there a top neighbor [t]?
    has = (n > 1);
end

function has = hasBotN(n, N)
% @return has is there a bottom neighbor [b]?
    has = (n < N);
end

function has = hasTopLeftN(m, n)
% @return has is there a top left neighbor [tl]?
    has = hasTopN(n) && hasLeftN(m);
end

function has = hasBotLeftN(m, n, N)
% @return has is there a bottom left neighbor [bl]?
    has = hasLeftN(m) && hasBotN(n, N);
end

function has = hasTopRightN(m, n, M, N)
% @return has is there a top right neighbor [tr]?
    has = hasTop(n, N) && hasRightN(m, M);
end

function has = hasBotRightN(m, n, M, N)
% @return has is there a bottom right neighbor [br]?
    has = hasBotN(n, N) && hasRightN(m, M);
end

function dist2 = computeDist2(a, b)
% @param a base pixel
% @param b neighbor pixel
% @return compute squared distances of two given pixels
    dist2 = (a - b)^2;
end

function beta = getBetaFromColorVar(colors)
% @returns beta one half oth the color variance of the whole image
    avg = sum(colors,2)/size(colors,2);
    beta = sum(sum( (colors-repmat(avg,1,size(colors,2))).* ...
           (colors-repmat(avg,1,size(colors,2))) )) / size(colors,2);
    beta = 1/(2*beta);
end

function penalty = penaltyTerm(beta, gamma, distSqrd)
%   compute the penalty if the labels of the pixels do not agree.
%   @param beta penalty paramter real number. Hlaf of color variance over
%   whole image.
%   @param gamma penalty paramter real number balance contribution of the
%   data and smoothness term.
%   @param distSqrd ||c_p - c_q||^2 for color indices p and neighbor q.
%   @param penalty.
    penalty = gamma*exp(-beta*distSqrd);
end

