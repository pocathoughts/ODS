figure,
img = imread('fundus3.png');
imshow(img);
gray = rgb2gray(img);
J = imadjust(gray);
im = im2bw(img);

redPlane = img(:, :, 1);
greenPlane = img(:, :, 2);
bluePlane = img(:, :, 3);

subplot(4,3,1);
imshow(redPlane);

subplot(4,3,2);
imshow(greenPlane);

[centersBright, radiiBright] = imfindcircles(greenPlane,[0 20],'ObjectPolarity','bright');
viscircles(centersBright, radiiBright,'EdgeColor','b');
%for the sake of segmentation, blue doesn't do shit for us
subplot(4,3,3);
imshow(bluePlane);