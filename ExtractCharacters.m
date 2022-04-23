% load image
I = imread('images/characters.jpg');
G = rgb2gray(I);
B = imbinarize(G);
B = imcomplement(B);
B = imcrop(B, [10 10 size(B, 2)-20 size(B, 1)-20]);
% er_h = imerode(B, strel('line', 50, 0));
% B = imsubtract(B, er_h);

% imshow(B);
% fill characters with holes2
Brccf = imfill(B, 'holes'); 

% characters detection
info = regionprops(Brccf,'Boundingbox') ;
imshow(Brccf);
hold on
for k = 1 : length(info)
     BB = info(k).BoundingBox;
     rectangle('Position', BB, 'EdgeColor', 'r', 'LineWidth', 2); 
     character = imcrop(Brccf, BB);
     imwrite(character, strcat('images/characters/numbers', num2str(k+28,'%d'), '.bmp'))
end