input_image = imread('gs9.jpg');
radius = 40;

if nargin < 2
    radius = 50;
end

op_image = double(input_image);

%Generate a raster circle
circle_size = [radius,radius].*2; %Radius -> diameter
circle = zeros(circle_size); 
circle( sub2ind(circle_size, radius,radius) ) = 1;
circle = double(bwdist(circle) < radius);

num_elements = sum(circle(:));

op_local_mean = local_mean(op_image, circle);
op_local_sum_2 = local_sum(2.*op_image, circle);
op_local_sum_square = local_sum(op_image.^2, circle);

variance = (1/num_elements) * ( op_local_sum_square - op_local_sum_2 + (num_elements*(op_local_mean.^2)) );
figure,imagesc(variance);
title(' r variance ');

std_dev = sqrt(abs(variance));
figure,imagesc(std_dev);
title('std deviation')

z_score = (op_image - op_local_mean)./sqrt(std_dev);
figure,imagesc(z_score);
title('Z Score of each pixel')

lsd = z_score;

figure,imshow(z_score > 0);
title('Local Z-Score > 0, how do you like me now!?');


