%disp(arrays.height);
% cc = bwconncomp(BW2, 4)
% cc.NumObjects
% 
% fundus_data = regionprops(cc, 'basic')
% 
% blob_areas = [fundus_data.Area];

%ones = sumBinary(im);
%disp(ones);

% just to double check everything is correct
% [x,y]=size(BW2); need height and width
% disp(x);
% disp(y);
figure,
img = imread('fundus3.png');
imshow(img);
gray = rgb2gray(img);
J = imadjust(gray);
im = im2bw(img);
hold on, title('Original Image');
mask = false(size(img));
mask(50:150,40:170) = true;
bw = activecontour(J, im);

contour(bw,[0.5 0.5],'r');
legend('Initial Contour','Final Contour');
figure, imshow(bw)
title('Segmented Image');
% gray = rgb2gray(img);
% J = imadjust(gray);
% im = im2bw(img);

% bw = activecontour(J, im);
%hell yeah! This above needs to be a grayscale (J), then a binary (im)

% imshow(bw);
% title('active contour result');

