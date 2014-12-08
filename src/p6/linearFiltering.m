function [ out ] = linearFiltering(lightFieldData, idxPair)
%LINEARFILTERING Summary of this function goes here
%   @param lightFieldData (M x N x 3 x #Count) light field tensor. 
%   @param idxPair an (1 x 2) idx array used for interpolation.
%   @return linear interpolated light field image from given idxPair.
    
    % get image height
    [M, ~, ~, ~] = size(lightFieldData);
    scanlines = lightFieldData(1:M,:,:,idxPair);
    epiImages = permute(scanlines, [2,4,3,1]);
    interpolatedEPI = 0.5*(epiImages(:,1,:,:) + epiImages(:,2,:,:));
    out = permute(interpolatedEPI, [4,1,3,2]);
end

