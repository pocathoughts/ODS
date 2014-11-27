function [width_coord, height_coord, approx_horiz_diameter] = HorizontalDiameter(binary_image)
[x,y]=size(binary_image); %x is height
%y is width
height = [];
width = [];
coordinate = []
for i = 1:x,

    for j = 1:y,

        if binary_image(i, j) == 1
            
            height(end + 1) = i;
            width(end + 1) = j;
            
        end

    end

end

%now we need to find the first place in which we get a value
left_bound = min(width);
right_bound = max(width);

approx_horiz_diameter = right_bound - left_bound;

disp(left_bound);
disp(right_bound);
disp(approx_horiz_diameter);

% X=[5 6 9 8 4]; our x is our height
% Y=[8 7 2 1 9]; our y is our width
% idx = find(Y == 1);
% Xidx = X(idx);

left_index_height = find(width == left_bound);
left_height_coord = height(left_index_height);

right_index_height = find(width == right_bound);
right_height_coord = height(right_index_height);

width_coord = [];
height_coord = [];

width_coord(end + 1) = left_height_coord(1);
width_coord(end + 1) = right_height_coord(1);

height_coord(end + 1) = left_bound(1);
height_coord(end + 1) = right_bound(1);


