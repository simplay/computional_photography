function [ out ] = bayerFilter( img )
    rgb_img = demosaicBayer(img);
    yuv_img = rgb2yuv(rgb_img);

    [m, n, c] = size(yuv_img);
    [red_mask, green_mask, blue_mask] = getMasks(m,n);
    
    % median filtered imgs
    medU = medfilt2(yuv_img(:,:,2),[3,3]);
    medV = medfilt2(yuv_img(:,:,3),[3,3]);

    ruvImg = mat2Img(rgb_img(:,:,1).*red_mask, medU, medV);
    guvImg = mat2Img(rgb_img(:,:,2).*green_mask, medU, medV);
    buvImg = mat2Img(rgb_img(:,:,3).*blue_mask, medU, medV);

    [ruv2rgb, guv2rgb, buv2rgb] = getRGBTransformations();

    red = transformImg3(ruvImg, ruv2rgb);                  
    green = transformImg3(guvImg, guv2rgb);
    blue = transformImg3(buvImg, buv2rgb);

    out = (red+green+blue);

end
