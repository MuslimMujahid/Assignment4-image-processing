% load image
I = imread('images/numbers.jpg');
G = rgb2gray(I);
B = imcomplement(imbinarize(G));

% % resize image
% [rows, cols] = size(B);
% desired_rows = 207;
% desired_cols = round(desired_rows*cols/rows);
% Br = imresize(B, [desired_rows, desired_cols]);
% 
% % remove plat border
% border_margin = 10;
% new_cols = desired_cols-2*border_margin;
% new_rows = desired_rows-2*border_margin;
% Brc = imcrop(Br, [border_margin border_margin new_cols new_rows]);
% 
% % remove bottom part
% bottom_part = 82;
% Brcc = imcrop(Brc, [0 0 new_cols new_rows-bottom_part]);

% fill characters with holes2
Brccf = imfill(B, 'holes');

% characters detection
info = regionprops(Brccf,'Boundingbox') ;
imshow(Brccf)
hold on
number_width = 120;
for k = 1 : length(info)
     BB = info(k).BoundingBox;
%      rectangle('Position', [BB(1)-(number_width-BB(3))/2,BB(2)-(number_width-BB(4))/2,number_width,number_width],'EdgeColor','r','LineWidth',2) ;
     character = imcrop(Brccf, [BB(1)-(number_width-BB(3))/2,BB(2)-(number_width-BB(4))/2,number_width,number_width]);
     character = imresize(imclearborder(character), [50, 50]);
     imwrite(character, strcat('images/characters/alphabet', num2str(k,'%d'), '.jpg'))
end



% BB = info(1).BoundingBox;
% imshow(imcrop(Brccf, [BB(1),BB(2),BB(3),BB(4)]));

% imshow(Brcc);
% imshowpair(I, B, 'montage');