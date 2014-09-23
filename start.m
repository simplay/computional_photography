% Computational Photography Project 1
% Turned in by <Name>

%% Assignement 1

img = imread('imgs/castle.jpg');
img = im2double(img);

[grey, inverted] = spanishCastle(img);

% Please show your images with imshow (instead of imwrite) and add titles
% to the (sub)figures if there are more then one.
figure(1);
imshow(grey);
title('Greyscale image');

figure(2)
imshow(inverted);
title('Inverted image');


%% Assignement 2.1

% Proceed similarly...

%% Assignement 2.2


%% Assignement 2.3


%% Assignement 2.4


%% Bonus
