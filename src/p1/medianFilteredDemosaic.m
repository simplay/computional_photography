function [ out ] = medianFilteredDemosaic( img )
%% demosaic a given image and then perform median filtering in order to 
% get rid of color-frinching artifacts.
    % @param img a (mxnx3) rgb img
    
    % get linear demosaiced filtered image 
    rgb_img = demosaicBayer(img);
    
    % transform rgb colors to yuv color space.
    yuv_img = rgb2yuv(rgb_img);
    
    % get bayer colorchannel masks.
    [m, n, c] = size(yuv_img);
    [red_mask, green_mask, blue_mask] = getMasks(m,n);
    
    % median filtered U,V channels of YUV images by a kernel of size 5. 
    kernelSize = 5;
    medU = medfilt2(yuv_img(:,:,2),[kernelSize, kernelSize]);
    medV = medfilt2(yuv_img(:,:,3),[kernelSize, kernelSize]);
    
    % get RUV, GUV, BUG imgs: Note that we have the following 
    % system of equations to solve for every pixel:
    % [Y;U;V] = rgb2yuv_transformation * [R;G;B]
    % Instead of solving above's system of equation, 
    % solve the following 3 system:
    % [R;U;V] = rgb2ruv_transformation*[R;G;B] for given R and unknown G,B
    % [G;U;V] = rgb2guv_transformation*[R;G;B] for given G and unknown R,B
    % [B;U;V] = rgb2buv_transformation*[R;G;B] for given B and unknown R,G
    % We denote the images containing every component of
    % [R;U;V] by ruvImg, [G;U;V] by guvImg, [B;U;V] = buvImg
    ruvImg = mat2Img(rgb_img(:,:,1).*red_mask, medU, medV);
    guvImg = mat2Img(rgb_img(:,:,2).*green_mask, medU, medV);
    buvImg = mat2Img(rgb_img(:,:,3).*blue_mask, medU, medV);
    
    % transformation matrices from ruv, guv, buv colorspace to RGB.
    % ruv2rgb denotes rgb2ruv_transformation
    % guv2rgb denotes rgb2guv_transformation
    % buv2rgb denotes rgb2buv_transformation
    [ruv2rgb, guv2rgb, buv2rgb] = getRGBTransformations();
    
    % compute the color transformations
    % [R;U;V] = rgb2ruv_transformation*[R;G;B] for given R and unknown G,B
    % [G;U;V] = rgb2guv_transformation*[R;G;B] for given G and unknown R,B
    % [B;U;V] = rgb2buv_transformation*[R;G;B] for given B and unknown R,G
    redImg = transformImg3(ruvImg, ruv2rgb);                  
    greenImg = transformImg3(guvImg, guv2rgb);
    blueImg = transformImg3(buvImg, buv2rgb);
    
    % combine all color images
    out = (redImg+greenImg+blueImg);

end
