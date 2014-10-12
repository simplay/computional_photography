function [ out ] = bfilt( img, sigma_s, sigma_r )
%BFILT Summary of this function goes here
%   Detailed explanation goes here
    [m, n, p] = size(img);
    out = zeros(m,n);
    for i = 1:m,
        for j = 1:n,
            
            bottom = max(i-1, 1);
            top = min(i+1, m);
            left = max(j-1, 1);
            right = min(j+1, n);
            
            rowIndices = bottom:top; 
            columnIndices = left:right;
            
            neighboordhoodValues = img(rowIndices, columnIndices);
            DeltaNValues = (neighboordhoodValues-img(i,j));
            DeltaNValues = DeltaNValues.*DeltaNValues;
            DeltaNValues = DeltaNValues/(-2*sigma_r*sigma_r);
            
            deltaNIdx = getScaledIdxDistanceMat2(rowIndices, columnIndices, ...
                                                [i,j], -2*sigma_s*sigma_s);
            
            EV = exp(DeltaNValues+deltaNIdx);
            out(i,j) = (EV(:)'*neighboordhoodValues(:))/sum(EV(:));
        end
    end

end

