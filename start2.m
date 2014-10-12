%% Task2
% bilateral filter
img = imread('imgs/Bigel11.jpg');
img2 = double(img)/255;
a = 3.0; b = 0.1;
img31 = bfilt(img2(:,:,1), a, b);
img32 = bfilt(img2(:,:,2), a, b);
img33 = bfilt(img2(:,:,3), a, b);
img3 = mat2Img(img31, img32, img33);

figure(1)
imshow(img3)

% tone mapping task
hdrImg = hdrread('imgs/dani_belgium_oC65.hdr');

figure(2)
imshow(hdrToneMappingGaussian(hdrImg,30))

figure(3)
imshow(hdrToneMapping(hdrImg,30))