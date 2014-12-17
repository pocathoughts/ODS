function bool = getSide(img, horizontal_middle)

%%this function decides which side of the image the OD is on so that we can
%%create a better bounding box to pass to chenevese algorithm
%%it will pass a zero if it is on the left and a 1 if it is on the right

gray = rgb2gray(img);
superGray = imadjust(gray);
bw = im2bw(superGray);
[x,y] = size(bw);
figure, imshow(bw), title('bw');

disp(x);
disp(y);
L_counter = 0;
R_counter = 0;

for i = 1:x,
    for j = 1:horizontal_middle,
        if bw(i, j) == 1     
            L_counter = L_counter + 1;
        end
    end
end


for i = 1:x,
    for j = horizontal_middle:y,
        if bw(i, j) == 1           
            R_counter = R_counter + 1;
        end
    end
end

bool = 0;

if L_counter > R_counter,
    bool = 0;
end
if R_counter > L_counter,
    bool = 1;
    
end
disp('bool value is (0 = OD on left side, 1 = OD on right side): ');
disp(bool);
    
    