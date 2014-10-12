function [ out ] = bfilt( img, sigma_s, sigma_r)
%BFILT Summary of this function goes here
%   Detailed explanation goes here
    h = waitbar(0, 'Applying Bilateral Filter...');
    set(h, 'Name', 'Bilateral Filter Progress Bar');
    w = ceil(1.5*sigma_s);
    windowLength = 2*w + 1;
    [m, n, p] = size(img);
    out = zeros(m,n);
    %%%
    for i = 1:m,
        for j = 1:n,
            
            [rowIndices, columnIndices] = getRanges(i, j, m, n, windowLength);
            
            neighboordhoodValues = img(rowIndices, columnIndices);
            DeltaNValues = (neighboordhoodValues-img(i,j));
            DeltaNValues = (DeltaNValues.^2) /(-2*sigma_r*sigma_r);
            
            deltaNIdx = getScaledIdxDistanceMat2(rowIndices, columnIndices, ...
                                                [i,j], -2*sigma_s^2);
            
            EV = exp(DeltaNValues+deltaNIdx);
            out(i,j) = (EV(:)'*neighboordhoodValues(:))/sum(EV(:));
        end
        waitbar(i/m);
    end
    close(h);
end

