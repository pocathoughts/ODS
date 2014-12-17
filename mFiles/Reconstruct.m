I = imread('gs4.jpg');
I =rgb2gray(I);
mask = adapthisteq(I);
figure, imshow(mask);
se = strel('disk',13);
marker = imerode(mask,se);
obr = imreconstruct(marker,mask);
figure, imshow(obr,[])

% mask = imread('gs6.jpg');
% figure, imshow(mask), title('original');
% mask = rgb2gray(mask);
% mask = im2bw(mask);
% mask = adapthisteq(I);
% figure, imshow(mask);

D = bwdist(~mask);
figure, imshow(D,[],'InitialMagnification','fit')
title('Distance transform of ~bw')

D = -D;
D(~bw) = -Inf;
L = watershed(D);
rgb = label2rgb(L,'jet',[.5 .5 .5]);
figure, imshow(rgb,'InitialMagnification','fit')
title('Watershed transform of D')

radius = 60;
circle_size = [radius,radius].*2; %Radius -> diameter
circle = zeros(circle_size); 
circle( sub2ind(circle_size, radius,radius) ) = 1;
circle = double(bwdist(circle) < radius);
figure, imshow(circle), title('circle');


ls = local_sum(obr, circle);
figure, imagesc(ls), title('conv');
disp(ls);



newls = ls./double(obr);
figure, imagesc(newls), title('new conv');
lsbw = im2bw(newls);
lsbw = imadjust(double(lsbw));
figure, imagesc(lsbw), title('bw ls');

% difference = local_mean_diff(obr, 50, 1);
% [ lsd ] = local_std_dev(obr, 30);
% I = imread('gs9.jpg');
% cropI = I(:,:,1);
% figure, imshow(cropI), title('cropI');
% 
% I =rgb2gray(I);
% mask = adapthisteq(I);
% figure, imshow(mask);
% se = strel('disk',13);
% marker = imerode(mask,se);
% obr = imreconstruct(marker,mask);
% figure, imshow(obr,[])
% 
% j = watershed(obr);
% figure, imshow(j), title('after watershed');
% mask = imread('gs8.jpg');
% mask = rgb2gray(mask);
% mask = im2bw(mask);
% imshow(mask);
% marker = false(size(mask));
% marker(13,93) = true;
% im = imreconstruct(marker,mask);
% figure, imshow(im)