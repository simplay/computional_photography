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

        if hasTopLeftDiagN(m,n) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n-1));    
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx - M - 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasLeftN(m,n,M,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m,n-1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx - M;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasBotLeftDiagN(m,n,M,N) == 1
           index = index+1;
           dist2 = computeDist2(img_mn, img(m+1,n-1));
           A_i(index) = rowIndex;
           A_j(index) = pixelIdx - M + 1;
           A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasTopN(m,n,M,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx - 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasBotN(m,n,M,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m+1,n));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasTopRightDiagN(m,n,M,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n+1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + M - 1;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasRightN(m,n,M,N) == 1
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m,n+1));
            A_i(index) = rowIndex;
            A_j(index) = pixelIdx + M;
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        end

        if hasBotRightDiagN(m,n,M,N) == 1
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

function has = hasTopLeftDiagN(m, n)
    has = (m > 1 && n > 1);
end

function has = hasLeftN(m, n, M, N)
end

function has = hasBotLeftDiagN(m, n, M, N)
end

function has = hasTopN(m, n, M, N)
end

function has = hasBotN(m, n, M, N)
end

function has = hasTopRightDiagN(m, n, M, N)
end

function has = hasRightN(m, n, M, N)
end

function has = hasBotRightDiagN(m, n, M, N)
end

function dist2 = computeDist2(a, b)
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

