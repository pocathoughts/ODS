function [width_coord, height_coord, approx_horiz_diameter] = ellipseHorizDiameter(X, Y)
%%%%Ways this could be improved is using same x point and finding
%%%%corresponding top and bottom points

top_bound = min(X);
bottom_bound = max(X);

approx_horiz_diameter = bottom_bound - top_bound;

disp(top_bound);
disp(bottom_bound);
disp(approx_horiz_diameter);

% X=[5 6 9 8 4]; our x is our height
% Y=[8 7 2 1 9]; our y is our width
% idx = find(Y == 1);
% Xidx = X(idx);

top_index_width = find(X == top_bound);
top_width_coord = Y(top_index_width);

bottom_index_width = find(X == bottom_bound);
bottom_width_coord = Y(bottom_index_width);


disp('the top index y value is');

disp(top_bound);

disp('the top index x value is');

disp(top_width_coord);

 
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


