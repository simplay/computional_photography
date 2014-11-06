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
A_value = zeros(8*(M-2)*(N-2), 1);
A_i = zeros(8*(M-2)*(N-2), 1);
A_j = zeros(8*(M-2)*(N-2), 1);

% local helper indices
index = 0;

% traverse the pixels in the image column-wise from top to bottom.
% we ignore boundary which won't have any effect.
for n=2:(N-1)
    for m=2:(M-1)

        % create the equations for the pixel (x,y) and it's 8 neighbors

        img_mn = img(m,n, :);
        
        % has top left neighbor
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n-1, :));    
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m-1,n-1, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        % has left neighbor
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m-1,n, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        % has bottom left neighbor
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m-1,n+1, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m-1,n+1, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        % has top neighbor
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m,n-1, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m,n-1, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        % has bottom neighbor
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m,n+1, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m,n+1, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        
        % has top right neighbor
           index = index+1;
           dist2 = computeDist2(img_mn, img(m+1,n-1, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m+1,n-1, M);
           A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        % has right neighbor
            index = index + 1;
            dist2 = computeDist2(img_mn, img(m+1,n, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m+1,n, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);
        
        % has top bottom right neighbor
            index = index+1;
            dist2 = computeDist2(img_mn, img(m+1,n+1, :));
            A_i(index) = pixelIdxRFO(m,n, M);
            A_j(index) = pixelIdxRFO(m+1,n+1, M);
            A_value(index) = penaltyTerm(beta, gamma, dist2);

    end
end

% create the sparse matrix pairwise
pairwise = sparse(A_i, A_j, A_value, pixelCount, pixelCount);

end


function pixelIDX = pixelIdxRFO(m,n, M)
% RFO = ROW FIRST ORDER
% compute pixel index when iteration over image in the following order:
% fix a certain column, then iterate over each rows, i.e. process all
% elements of a column vector.
% @param m row idx of pixel in image
% @param n column idx of pixel in image
% @param N number of columns in image
% @return pixel index in RFO pixelvector.


    pixelIDX = m + M*(n-1);

end

function dist2 = computeDist2(a, b)
% @param a base pixel
% @param b neighbor pixel
% @return compute squared distances of two given pixels
    c = (a-b).^2;
    dist2 = sqrt(sum(c(:)));
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

