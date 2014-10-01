function [ out ] = grayWorld( img, perform_green_normalization )
%GRAYWORLD color balancing relying on the gray world assumption.
%   assumes that the average color in any image is grey. 
%   It transforms the input image to match this assumption
%   @param img is a (m x n x 3) double valued color img in rgb colorspace
%   @param out color balanced input img based in gray world assumption.
%   @param perform_green_normalization integer value either equal 1 or 0
%          if equal to 1 then we apply normalization to green - as req.
%          from the exercise.
%          if equal to 0 then we compute a average gray value and normalize
%          the correction factors according to the avg gray accordingly.
    
    % get mean colorchannel values.
    avgR = mean(mean(img(:,:,1)));
    avgG = mean(mean(img(:,:,2)));
    avgB = mean(mean(img(:,:,3)));
    
    % should we perform green normalization?
    if perform_green_normalization == 1
        % scale color channels according to green color channel.
        img(:,:,1) = img(:,:,1)/(avgR/avgG);
        img(:,:,3) = img(:,:,3)/(avgB/avgG);
        
        % write back
        out = img;
    else
        % avg color of all channels: gray value
        grayValue = (avgR + avgG + avgB)/3;
        
        % rescale gray value according to given channels relatively.
        scaleR = grayValue./avgR;
        scaleG = grayValue./avgG;
        scaleB = grayValue./avgB;
        
        % update color channels by rescaling.
        scaledR = img(:,:,1).*scaleR;
        scaledG = img(:,:,2).*scaleG;
        scaledB = img(:,:,3).*scaleB;
        
        % parse matrices to an imgage
        out = mat2Img(scaledR,scaledG,scaledB);
    end
 
end