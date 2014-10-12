%% Task2
% Tone mapping
img = imread('imgs/Bigel11.jpg');
img2 = double(img)/255;
img31 = bfilt(img2(:,:,1), 10, 300);
img32 = bfilt(img2(:,:,2), 10, 300);
img33 = bfilt(img2(:,:,3), 10, 300);
img3 = mat2Img(img31, img32, img33);
figure
imshow(img3)
figure
imshow(bfilter2(img2, 1, [10, 300]))