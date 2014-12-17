img = imread('gs6.jpg');
img = GetCrop(img);

figure, subplot(4,4,1), imshow(img), title('original');
H1 = fspecial('unsharp');

H2 = fspecial('gaussian',150, 150);
newrgb = imfilter(img, H1, 'circular');
text = rangefilt(newrgb);
subplot(4,4,2), imshow(text), title('texture filter');
newestrgb = imfilter(newrgb, H2, 'circular');
greenPlane = newestrgb(:,:,2);
% grayImage = rgb2gray(newestrgb);

subplot(4,4,3), imshow(newrgb), title('unsharp filter');
subplot(4,4,4), imshow(newestrgb), title('low pass');
subplot(4,4,5), imshow(greenPlane), title('greenplane');

betterg = adapthisteq(greenPlane);
subplot(4,4,6), imshow(betterg), title('after adathist');
betterg = imfilter(betterg, H1, 'circular');
subplot(4,4,7), imshow(betterg), title('unsharp filter after adapthist');
betterg = imadjust(betterg);
subplot(4,4,8), imshow(betterg), title('afterimadj');

fakergb = cat(3, betterg, betterg, betterg);
mask = BestHSVMask(fakergb);
subplot(4,4,9), imshow(mask), title('masked image');
%SE = strel('disk', 8);
BW2 = bwareaopen(mask, 250);
subplot(4,4, 10), imshow(BW2), title('after area open');
% BW2 = imerode(BW2, SE);
BW2dil = imdilate(BW2, SE);
subplot(4,4,11), imshow(BW2dil), title('after dilate');
%edges = bwperim(BW2);

s = regionprops(BW2dil, greenPlane, {'Centroid','WeightedCentroid'});

subplot(4,4,12),
imshow(img),
title('Weighted (red) and Unweighted (blue) Centroid Locations');
hold on
numObj = numel(s);
for k = 1 : numObj
    plot(s(k).WeightedCentroid(1), s(k).WeightedCentroid(2), 'r*');
    plot(s(k).Centroid(1), s(k).Centroid(2), 'bo');
end
hold off
% 
% % [centersBright, radiiBright, metricBright] = imfindcircles(fakergb,[120 200], ...
% %     'ObjectPolarity','bright','Sensitivity',0.92,'Method','twostage');
% % 
% % disp(length(centers));