img = imread('gs8.jpg');
gray = rgb2gray(img);
gray = imadjust(gray);
rgb = cat(3, gray, gray, gray);
bw = BestHSVMask(rgb);
figure, imshow(bw), title('masked image');
se = strel('disk', 5);
bw = imerode(bw, se);


Z = edge(bw,'canny',0.85);

figure, imagesc(Z), title('wtf');

CH = bwconvhull(bw);
figure, imshow(CH), title('convex hull');

[x_array, y_array] = getContourEdgePoints(Z);

K = convhull(x_array,y_array);

