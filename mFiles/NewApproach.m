img = imread('gs3.jpg');

gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);

betterFundus = adapthisteq(Supa_grayfundus);

rgbFundus = cat(3, Supa_grayfundus, Supa_grayfundus, Supa_grayfundus);

% %# Create the gaussian filter with hsize = [5 5] and sigma = 2
% G = fspecial('gaussian',[50 50],2);
% %# Filter it
% Ig = imfilter(img, G,'same');
% %# Display
% 
% figure,
% imshow(Ig);
% title('Ig');



% B = [];
% B(:,:,2)=Supa_grayfundus;
% B(:,:,3)=Supa_grayfundus;
% B(:,:,1)=Supa_grayfundus;


% hsvfundus = rgb2hsv(rgbImage);
[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 

BW2 = bwareaopen(bw, 200);

SE = strel('disk', 15);
BW2 = imdilate(BW2,SE);


imshow(BW2);
title('after opening function');

figure,
imshow(betterFundus);
title('adaptive hist');

figure,
imshow(Supa_grayfundus);
title('supergray img');

figure,
imshow(maskedRGBImage);
title('hsvfundus');

figure,
imshow(rgbImage);
title('rgbimage');


% %J = imadjust(gray);
% im = im2bw(img);
% 
% imwrite(uint8(BW2),'Fblurred image.png');