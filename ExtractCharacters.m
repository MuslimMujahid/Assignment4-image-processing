% load image
I = imread('images/numbers.jpg');
G = rgb2gray(I);
B = imcomplement(imbinarize(G));

% fill characters with holes2
Brccf = imfill(B, 'holes');

% characters detection
info = regionprops(Brccf,'Boundingbox') ;
for k = 1 : length(info)
     BB = info(k).BoundingBox;
     character = imcrop(Brccf, BB);
     imwrite(character, strcat('images/characters/numbers', num2str(k+28,'%d'), '.bmp'))
end