function B = GetCrop(img)

[x,y]=size(img);

horizontal_middle = x / 2;
top_bound = horizontal_middle - 400;
bottom_bound = horizontal_middle + 100;

figure, 
imshow(img);
title('bounded area');

plot([0,y], [top_bound, top_bound],'Color','g','LineWidth',2);% J = entropyfilt(gray); 
plot([0,y], [bottom_bound, bottom_bound],'Color','g','LineWidth',2);% J = entropyfilt(gray); 
% imshow(img), figure, imshow(J,[]); 

B = imcrop(img,[0 top_bound x 800]);
%B is now the image that we care about

% figure,
% imshow(B);
% title('cropped image');


% gray = rgb2gray(B);
% figure,
% imshow(gray);
% title('gray');
% 
% hsv = rgb2hsv(B);
% adaptgray = adapthisteq(gray);
% imadjgray = imadjust(adaptgray);
% 
% imadjgray = cat(3, imadjgray, imadjgray, imadjgray);
% 
% goodimg = HSVMASKNEW(imadjgray);
% figure,
% imshow(goodimg);
% title('after mask');
% 
% betterimg = goodimg & ~bwareaopen(goodimg,1000);
% 
% figure,
% imshow(betterimg);
% title('after getting rid of big blobs');
% 
% se90 = strel('line', 3, 90);
% se0 = strel('line', 3, 0);
% % 
% BWsdil = imdilate(goodimg, [se90 se0]);
% figure, imshow(BWsdil), title('dilated gradient mask');
% 
% BWdfill = imfill(BWsdil, 'holes');
% figure, imshow(BWdfill);
% title('binary image with filled holes');

% normalizedGP = localnormalize(B, 100, 100);
% figure,
% imshow(normalizedGP);
% title('please be it');
% 
% newgray = rgb2gray(normalizedGP);
% figure,
% imshow(newgray);
% title('grayscale of weird shit');


% h = fspecial('gaussian', size(newgray), 3.0); 
% g = imfilter(newgray, h); 



% J = entropyfilt(hsv); 
% figure, 
% imshow(J);
% title('entropy thing');


% imshow(img), figure, imshow(J,[]); 

% ln=localnormalize(J, 100, 10);
% 
% figure,
% imshow(ln);
% title('ln');
% % % 
% W=wbalance(img);
% 

% figure,
% imshow(W);
% title('changed color balance');
%  
