function [ out ] = manualWhiteBalance( img, coords )
%MANUALWHITEBALANCE perform manual color balancing.
%   Choose a pixel in the image manually that should be white.
%   @param img is a (m x n x 3) double valued color img in rgb colorspace 
%   @param coord coordinates in img of reference pixel which represents
%   white.
%   @return out color balanced input images using a reference pixel.
    
    refPix = img(coords(1), coords(2), :);
    grayValue = (refPix(1,1,1) + refPix(1,1,2) + refPix(1,1,3))/3;
    
    scaleR = grayValue./refPix(1,1,1);
    scaleG = grayValue./refPix(1,1,2);
    scaleB = grayValue./refPix(1,1,3);
    
    scaledR = img(:,:,1).*scaleR;
    scaledG = img(:,:,2).*scaleG;
    scaledB = img(:,:,3).*scaleB;
    
    out = mat2Img(scaledR,scaledG,scaledB);
end

