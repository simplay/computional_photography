function [ out ] = bfilt( img, sigma_s, sigma_r, w )
%BFILT Summary of this function goes here
%   Detailed explanation goes here
    [m, n, p] = size(img);
    out = zeros(m,n);
    for i = 1:m,
        for j = 1:n,
            
            [rowIndices, columnIndices] = getRanges(i, j, m, n, w);
            
            neighboordhoodValues = img(rowIndices, columnIndices);
            DeltaNValues = (neighboordhoodValues-img(i,j));
            DeltaNValues = (DeltaNValues.^2) /(-2*sigma_r*sigma_r);
            
            deltaNIdx = getScaledIdxDistanceMat2(rowIndices, columnIndices, ...
                                                [i,j], -2*sigma_s*sigma_s);
            
            EV = exp(DeltaNValues+deltaNIdx);
            out(i,j) = (EV(:)'*neighboordhoodValues(:))/sum(EV(:));
        end
    end

end

