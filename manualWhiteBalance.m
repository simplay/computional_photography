function [ out ] = manualWhiteBalance( img, coords )
%MANUALWHITEBALANCE Summary of this function goes here
%   Detailed explanation goes here
    
    refPix = img(coords(1), coords(2), :);
    grayValue = (refPix(1,1,1) + refPix(1,1,2) + refPix(1,1,3))/3;
    
    scaleR = grayValue./refPix(1,1,1);
    scaleG = grayValue./refPix(1,1,2);
    scaleB = grayValue./refPix(1,1,3);
    
    scaleR = scaleR./scaleG;
    scaleG = scaleG./scaleG; % equal to 1
    scaleB = scaleB./scaleG;
    
    scaledR = img(:,:,1).*scaleR;
    scaledG = img(:,:,2).*scaleG;
    scaledB = img(:,:,3).*scaleB;
    
    out = mat2Img(scaledR,scaledG,scaledB);
end

