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
img = imread('imgs/foliage raw.tiff');
img = double(img) / 4096.0;

[m, n] = size(img);
blue_mask = zeros(m, n);
blue_mask(2:2:end, 2:2:end) = 1;

green_mask = zeros(m, n);
green_mask(2:2:end, 1:2:end) = 1;
green_mask(1:2:end, 2:2:end) = 1;

red_mask = zeros(m, n);
red_mask(1:2:end, 1:2:end) = 1;

% get color contribution
red_contribution = img.*red_mask;
green_contribution = img.*green_mask;
blue_contribution = img.*blue_mask;

I3x3 = ones(3);
interpolated_red_contribution = conv2(red_contribution, I3x3, 'same');
interpolated_green_contribution = conv2(green_contribution, I3x3, 'same');
interpolated_blue_contribution = conv2(blue_contribution, I3x3, 'same');


norm_red = interpolated_red_contribution ./ conv2(red_mask, I3x3, 'same');
norm_green = interpolated_green_contribution ./ conv2(green_mask, I3x3, 'same');
norm_blue = interpolated_blue_contribution ./ conv2(blue_mask, I3x3, 'same');


%red_channel = norm_red.*(green_mask+blue_mask)+red_contribution;
%green_channel = norm_green.*(red_mask+blue_mask)+green_contribution;
%blue_channel = norm_blue.*(green_mask+red_mask)+blue_contribution;

red_channel = (norm_red.* ~red_mask) + red_contribution;
green_channel = (norm_green.* ~green_mask) + green_contribution;
blue_channel = (norm_blue.* ~blue_mask) + blue_contribution;

color_pile = [red_channel green_channel blue_channel ];

final_img = reshape(color_pile,m,n,3);
imshow(final_img);


% conv2 image by same ones(3)

% Proceed similarly...

%% Assignement 2.2


%% Assignement 2.3


%% Assignement 2.4


%% Bonus
