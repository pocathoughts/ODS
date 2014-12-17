close all
clear all
orig_img = imread('gs1.jpg');
%copy this for later to display
I = orig_img; 

% Imnoise the original image, the snake moves through the fuzz, it needs
%a "medium" to travel through
%investigate different types of noise but for now this seems to be great
I(:,:,2) = imnoise(I(:,:,2), 'gaussian', 0.2, .5);

%blurring the image helps with making the snake as accurate as possible
filter = fspecial('gaussian',5, 5);
I = imfilter(I, filter, 'circular');

%display original image
figure(),
subplot(1,2,1),
imshow(orig_img),
title('original image');

%displays the noisy vector
subplot(1,2,2),
imshow(I), 
title('original image with two components adding noise');

% seems to work well with ODSeg using 'vector' setting
seg = chenvese(I,'medium',500,0.01,'vector');

figure, imshow(seg), title('seg');

