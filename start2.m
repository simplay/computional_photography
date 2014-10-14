%% Task2
% bilateral filter
img = imread('imgs/Bigel11.jpg');
img2 = double(img)/255;
a = 3.0; b = 0.1;

figure
out = bfiltImg3(img2, a, b);
imshow(out);

%figure(1)
%imshow(img3)

% tone mapping task
%hdrImg = hdrread('imgs/dani_belgium_oC65.hdr');

%figure(2)
%imshow(hdrToneMappingGaussian(hdrImg,30))

%figure(3)
%imshow(hdrToneMapping(hdrImg,30))

% tone adjustment - awesomification
awesomeImg = imread('imgs/winterstorm.png');
awesomeImg = double(awesomeImg)/255;
baseImg = imread('imgs/rock.png');
baseImg = double(baseImg)/255;

advOut = toneAdjustmentColorImg(baseImg, awesomeImg, 1.0);
simpleOut = simpleautoToneAdjustment(baseImg, awesomeImg);

figure(1000)
imshow(advOut)

figure(1001)
imshow(simpleOut)
