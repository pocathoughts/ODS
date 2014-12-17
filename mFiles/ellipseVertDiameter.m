function [width_coord, height_coord, approx_vertical_diameter] = ellipseVertDiameter(X, Y)
%%%%Ways this could be improved is using same x point and finding
%%%%corresponding top and bottom points

top_bound = min(Y);
bottom_bound = max(Y);

approx_vertical_diameter = bottom_bound - top_bound;

disp(top_bound);
disp(bottom_bound);
disp(approx_vertical_diameter);

left_bound = min(X);
right_bound = max(X);
middle = (left_bound + right_bound)/2;
% X=[5 6 9 8 4]; our x is our height
% Y=[8 7 2 1 9]; our y is our width
% idx = find(Y == 1);
% Xidx = X(idx);

disp('this is the middle coord');
disp(middle);
% 
% top_index_width = find(Y == top_bound);
% top_width_coord = X(top_index_width);
% 
% bottom_index_width = find(Y == bottom_bound);
% bottom_width_coord = X(bottom_index_width);
disp('this is the top point');
disp(top_bound);
disp('this is bottome bound');
disp(bottom_bound);
%%%%%%%%Ways to improve, average the values in the coordinate arrays%%%%
width_coord = [];
height_coord = [];
width_coord(end + 1) = middle;
width_coord(end + 1) = middle;

height_coord(end + 1) = top_bound;
height_coord(end + 1) = bottom_bound;
% 
% disp('the top index y value is');
% 
% disp(top_bound);
% 
% disp('the top index x value is');
% 
% disp(top_width_coord);
% 
%  
% disp('the bottom index y value is');
% 
% disp(bottom_bound);
% 
% disp('the bottom index x value is');
% 
% disp(bottom_width_coord);
