function [x, y] = getCenterPoint(binary_image)
[x,y]=size(binary_image); %x is height
%y is width
height = [];
width = [];
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
left_bound = min(width);
right_bound = max(width);

disp(top_bound);
disp(bottom_bound);


vertical_average = (top_bound + bottom_bound) / 2
horizontal_average = (left_bound + right_bound) / 2

x = horizontal_average;
y = vertical_average;
  