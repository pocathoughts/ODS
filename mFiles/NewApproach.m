figure,
img = imread('gs3.jpg');

gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);


rgbFundus = cat(3, gray, gray, gray);

%betterFundus = adapthisteq(gray);

% B = [];
% B(:,:,2)=Supa_grayfundus;
% B(:,:,3)=Supa_grayfundus;
% B(:,:,1)=Supa_grayfundus;


% hsvfundus = rgb2hsv(rgbImage);
[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 

imshow(grayfundus);
title('grayfundus');

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