%% Task2
% Tone mapping
img = imread('imgs/Bigel11.jpg');
img2 = double(img)/255;
a = 3.0; b = 0.1; w = 5;
img31 = bfilt(img2(:,:,1), a, b);
img32 = bfilt(img2(:,:,2), a, b);
img33 = bfilt(img2(:,:,3), a, b);
img3 = mat2Img(img31, img32, img33);
figure
imshow(img3)
figure
imshow(bfilter2(img2, w, [a, b]))