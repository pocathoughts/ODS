img = imread('gs4.jpg');
figure, imshow(img), title('original');
im_points = img(:);
% disp(im_points);

img = rgb2gray(img);

img = imadjust(img);

img = adapthisteq(img);
figure, imshow(img), title('bw');

newimg = cat(3, img, img, img);

mask = BestHSVMask(newimg);
se = strel('disk', 7);
se1 = strel('square', 25);
mask = bwareaopen(mask, 150);
mask = imerode(mask, se);
mask = imdilate(mask, se1);
figure, imshow(mask), title('mask');