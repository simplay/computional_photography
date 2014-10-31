function [RUV2RGB, GUV2RGB, BUV2RGB] = getRGBTransformations()
% foobartext
%   @param img_rgb is supposed to be a mxnx3 rgb image.
    % Transformation of RGB colors into yuv color space:
    % (Y)   ( a b c )   (R)
    % (U) = ( d e f ) * (G)
    % (V)   ( g h i )   (B)
    rgb2yuv = [0.299 0.587 0.114; 
              -0.14713 -0.28886 0.436; 
               0.615 -0.51499 -0.10001];
    
    % Basically we want to make use of the rgb to yuv colorspace transformation
    % but further we also want to keep either the R, G or B color channel
    % insead of the Y channel (from the YUV color-space). Replacing the Y channel
    % from the YUV space by one of the RGB color components can simply
    % achieved by applying a unit-vector to the corresponding channel. For
    % example, in case we are interested in the RUV (instead of the YUV)
    % space, we have to modify the rgb2yuv colorspace-transformation the
    % following way:
    % (R)   ( 1 0 0 )   (R)
    % (U) = ( d e f ) * (G)
    % (V)   ( g h i )   (B)
    % in oder to receive the guv and bug colorspace transformations
    % we have to proceed analogousely.
    rgb2ruv = [[1 0 0];rgb2yuv(2:3, :)];
    rgb2guv = [[0 1 0];rgb2yuv(2:3, :)];
    rgb2buv = [[0 0 1];rgb2yuv(2:3, :)];
    
    % identity matrix
    I = eye(3);      
           
    
    % compute inverse transformations: from (either R,G or B)UV to RGB colors: 
     RUV2RGB = rgb2ruv\I;
     GUV2RGB = rgb2guv\I;
     BUV2RGB = rgb2buv\I;
    
end

