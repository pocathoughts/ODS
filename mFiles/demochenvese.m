
close all
clear all
P = imread('od4.png');


I = P; %copy this for later to display

% Imnoise the original input
I(:,:,2) = imnoise(I(:,:,2),'gaussian',0.2, .5);
H3 = fspecial('gaussian',5, 5);
I = imfilter(I, H3, 'circular');

% I(:,:,1) = imnoise(I(:,:,1),'speckle');

figure(),subplot(1,2,1),imshow(P),title('original image');
subplot(1,2,2),imshow(I),title('original image with two components adding noise')

% Normal Chan & Vese cannot work
seg = chenvese(I,'medium',500,0.01,'chan'); 

% Chan & Vese for vector image works here
seg = chenvese(I,'medium',500,0.01,'vector');
% Using built-in mask = 'whole' leads faster and better segmentation
seg = chenvese(I,'medium',500,0.01,'vector');

%-- End 

