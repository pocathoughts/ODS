%%# Read an image
I = imread('gs3.jpg');
%# Create the gaussian filter with hsize = [5 5] and sigma = 2
G = fspecial('gaussian',[500 500],5);
%# Filter it
Ig = imfilter(I,G,'same');
%# Display
imshow(Ig)