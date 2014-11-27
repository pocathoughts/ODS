function [x, y] = getContourEdgePoints(binary_image)
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
disp(height);
disp(width);

x = width;
y = height;
  