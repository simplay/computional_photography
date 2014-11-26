function out = homographicRectification(img, sourcePoints, targetPoints )
%HOMOGRAPHICRECTIFICATION Rectificate a given image using homographic
% tansformations from a given set of source points to target points.
%   @param img (M x N x 3) color image that is supposed to be rectificated.
%   @param sourcePoints (3 x 4) homogenous set of points. 
%          Each column encodes a positions
%   @param targetPoints (3 x 4) homogenous set of points. 
%          Each column encodes a positions
%   @return a (M' x N' x 3) rectificated image  
%              M' = bottom-top
    
    % get image dimensions
    [M, N, ~] = size(img);
    
    % get homographic transformation from source to target points
    H = pointSets2Homography(sourcePoints, targetPoints);
    
    % Build homogenous bounding box coordinates.
    [bb, left, right, top, bottom] = getBoundingBoxAround(targetPoints);
    boundingBoxPos = [bb; ones(1,M*N)];
   
    % Rectificated homogenous pixels.
    pixels = H\boundingBoxPos;
    pixels_w = pixels(3,:);
    pixels = pixels./repmat(pixels_w, 3, 1);
    
    % get interpolated pixel colors
    interpolatedColors = getBilinearInterpolatedColors(img, pixels);
   
    out = zeros(bottom-top+1, right-left+1, 3);
    for k=1:M*N
        % from double to int32
        idxI = int32(boundingBoxPos(2,k));
        idxJ = int32(boundingBoxPos(1,k));    
        out(idxI, idxJ, :) = interpolatedColors(:,k);
    end
end