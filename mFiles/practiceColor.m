img = imread('gs7.jpg');

figure,
imshow(img);
title('original image');
gray = rgb2gray(img);
adaptgray = adapthisteq(gray);
imadjgray = imadjust(adaptgray);

[x,y]=size(img);

horizontal_middle = x / 2;
top_bound = horizontal_middle - 400;
bottom_bound = horizontal_middle + 400;

figure, 
imshow(img);
title('bounded area');
hold on
plot([0,y], [top_bound, top_bound],'Color','g','LineWidth',2);% J = entropyfilt(gray); 
plot([0,y], [bottom_bound, bottom_bound],'Color','g','LineWidth',2);% J = entropyfilt(gray); 
% imshow(img), figure, imshow(J,[]); 

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
