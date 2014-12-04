function [epiImages,selectedLineNrs]  = computeEPI(lightFieldData, imgHeight, rowSelectionCount, frameCount )
%COMPUTEEPI Summary of this function goes here
%   Detailed explanation goes here
    randomLineIdxs = randperm(imgHeight);
    selectedLineNrs = randomLineIdxs(1:rowSelectionCount);

    % for given rows take all height
    scanlines = lightFieldData(selectedLineNrs,:,:,1:frameCount);
    % permute scanlines image: t = images, v = scan line
    % height, camera views, col-channels, different rows
    epiImages = permute(scanlines, [2,4,3,1]);
end

