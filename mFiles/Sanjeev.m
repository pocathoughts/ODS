img = imread('gs3.jpg');
cropimg = GetCrop(img);
grayImage= rgb2gray(cropimg);

betterg = adapthisteq(grayImage);
figure, imshow(betterg), title('after adathist');
betterg = imadjust(betterg);
figure, imshow(betterg), title('afterimadj');

combine = cat(3, betterg, cropimg(:,:,1), cropimg(:,:,2));
%figure, imshow(combine), title('combined image');

newcombine = BestHSVMask(combine);
figure, imshow(newcombine), title('after mask');

SE = strel('disk', 10);
BW2 = bwareaopen(newcombine, 250);
% BW2 = imerode(BW2, SE);
BW2 = imdilate(BW2, SE);
edges = bwperim(BW2);




figure, imshow(BW2), title('BW2');

[x,y] = getContourEdgePoints(edges);

[width_coord, height_coord, approx_vertical_diameter] = VerticalDiameter(BW2)


% BW = edge(newcombine, 'canny',0.2);
% %Z = edge(BW2,'canny',0.85);
% figure, imshow(BW), title('bw');
% filteredImage = conv2(double(grayImage), [-1 1], 'same');
% figure, imshow(filteredImage), title('filtered image');
%drawnow();

radius = 0;
radius = approx_vertical_diameter /2 ;
Rmin = 140;
Rmax = 190;
disp('this is the radius diameter');
disp(radius);
center = cat(2, x, y); %concatenates into one 2D thing
%the circles may not be as good of a fit as ellipses, but hey its one way
%[centersBright, radiiBright] = imfindcircles(BW2,[Rmin Rmax],'ObjectPolarity','bright');
%centers = imfindcircles(betterg,175);
% disp('these are centers bright');
% disp(centers);

figure, imshow(img), title('original img');
hold on,

for x_vals = 1:length(x)
    for y_vals = 1:length(y)
        center = cat(2, x_vals, y_vals);
        viscircles(center,radius);
    end
end
%viscircles(center, radius); 

%we want all the possible points that could result in an ellipse, meaning
%the threshold
% [l, w] = size(cropimg);
% all_da_points = l * w;
% disp(all_da_points);
