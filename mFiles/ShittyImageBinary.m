img = imread('badf2.jpg');
greenPlane = img(:, :, 2);
figure, imshow(img), title('original image');

gimg = rgb2gray(img);
adaptgray = adapthisteq(gimg);
imadjgray = imadjust(gimg);

figure, imshow(imadjgray), title('final gray image');

rgbimg = cat(3, imadjgray, imadjgray, imadjgray);

goodimg = HSVMASKNEW(rgbimg);
figure,
imshow(goodimg);
title('after mask');

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

BWsdil = imdilate(goodimg, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

betterimg = BWsdil & ~bwareaopen(BWsdil,35000);

croppedimg = GetCrop(betterimg);
cleanimg = bwareaopen(croppedimg, 500);

figure,
imshow(betterimg);
title('after removing large chunks');

figure,
imshow(cleanimg);
title('after removing small chunks');


figure, imshow(croppedimg), title('watershed');

% hsv = rgb2hsv(img);
% greenPlane = hsv(:, :, 2);
% 
% %greenPlane = img(:, :, 2); %now we have a grayscale image of just the green plane
% adaptgray = adapthisteq(greenPlane);
% imadjgray = imadjust(adaptgray);
% 
% 
% [~, threshold] = edge(imadjgray, 'sobel');
% fudgeFactor = .15;
% BWs = edge(imadjgray ,'sobel', threshold * fudgeFactor);
% figure, imshow(BWs), title('binary gradient mask');


% se90 = strel('line', 3, 90);
% se0 = strel('line', 3, 0);
% 
% BWsdil = imdilate(switchedBWs, [se90 se0]);
% figure, imshow(BWsdil), title('dilated gradient mask');
% 
% BWdfill = imfill(BWsdil, 'holes');
% figure, imshow(BWdfill);
% title('binary image with filled holes');
% 
% seD = strel('diamond',1);
% BWfinal = imerode(BWnobord,seD);
% BWfinal = imerode(BWfinal,seD);
% figure, imshow(BWfinal), title('segmented image');