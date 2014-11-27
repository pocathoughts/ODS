function [width_coord, height_coord, approx_vertical_diameter] = VerticalDiameter(binary_image)
[x,y]=size(binary_image); %x is height
%y is width
height = [];
width = [];
coordinate = [];
for i = 1:x,

    for j = 1:y,

        if binary_image(i, j) == 1
            
            height(end + 1) = i;
            width(end + 1) = j;
            
        end

    end

end

%now we need to find the first place in which we get a value
top_bound = min(height);
bottom_bound = max(height);

approx_vertical_diameter = bottom_bound - top_bound;

disp(top_bound);
disp(bottom_bound);
disp(approx_vertical_diameter);

% X=[5 6 9 8 4]; our x is our height
% Y=[8 7 2 1 9]; our y is our width
% idx = find(Y == 1);
% Xidx = X(idx);

top_index_width = find(height == top_bound);
top_width_coord = width(top_index_width);

bottom_index_width = find(height == bottom_bound);
bottom_width_coord = width(bottom_index_width);

top_index_width = find(height == top_bound);

top_width_coord = width(top_index_width);

 

disp('the top index y value is');

disp(top_bound);

disp('the top index x value is');

disp(top_width_coord);

 

 

bottom_index_width = find(height == bottom_bound);

bottom_width_coord = width(bottom_index_width);

 

disp('the bottom index y value is');

disp(bottom_bound);

disp('the bottom index x value is');

disp(bottom_width_coord);

%%%%%%%%Ways to improve, average the values in the coordinate arrays%%%%

width_coord = [];
height_coord = [];

width_coord(end + 1) = top_width_coord(1);
width_coord(end + 1) = bottom_width_coord(1);

height_coord(end + 1) = top_bound(1);
height_coord(end + 1) = bottom_bound(1);


