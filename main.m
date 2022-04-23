% constants
characters_found_dir = 'images/characters_found';
characters_dir = 'images/characters';
char_found_width = 70;

% load image
I = imread('images/plat5.jpg');
G = rgb2gray(I);
B = imbinarize(G);

% resize image
[rows, cols] = size(B);
desired_rows = 207;
desired_cols = round(desired_rows*cols/rows);
Br = imresize(B, [desired_rows, desired_cols]);

% remove plat border
border_margin = 10;
new_cols = desired_cols-2*border_margin;
new_rows = desired_rows-2*border_margin;
Brc = imcrop(Br, [border_margin border_margin new_cols new_rows]);

% remove bottom part
bottom_part = 82;
Brcc = imcrop(Brc, [0 0 new_cols new_rows-bottom_part]);

% if background is white than reverse it
[rows, cols] = size(Brcc);
n_pixels = rows * cols;
zero_pixels = sum(B(:) == 0);
if (zero_pixels < n_pixels)
    Brcc = imcomplement(Brcc);
end

% fill characters with holes2
Brccf = imfill(Brcc, 'holes');

% clear characters found dir
clearDir(characters_found_dir);

% characters detection
info = regionprops(Brccf,'Boundingbox') ;
imshow(Brccf);
hold on
for k = 1 : length(info)
     BB = info(k).BoundingBox;
     character = imclearborder(imcrop(Brccf, [BB(1)-(char_found_width-BB(3))/2,BB(2)-(char_found_width-BB(4))/2,char_found_width,char_found_width]));
     rectangle('Position', [BB(1)-(char_found_width-BB(3))/2,BB(2)-(char_found_width-BB(4))/2,char_found_width,char_found_width],'EdgeColor','r','LineWidth',2) ;
     imwrite(imresize(character, [50 50]), strcat(characters_found_dir, '/char', num2str(k,'%d'), '.jpg'));
end

% read characters
characters = dir(fullfile(characters_dir, '*.jpg'));
characters_found = dir(fullfile(characters_found_dir, '*.jpg'));

for i = 1 : length(characters_found)
   max_sim = -1;
   max_sim_char_idx = -1;
   for j = 1 : length(characters)   
      char_found = imread(fullfile(characters_found_dir, characters_found(i).name));
      char = imread(fullfile(characters_dir, characters(j).name));
      sim = imageSimilarity(char_found, char);
      
      if (sim > max_sim)
          max_sim = sim;
          max_sim_char_idx = j;
      end
   end
   
   disp(characters(max_sim_char_idx).name);
end

% imshow(imread(fullfile(characters_found_dir, characters_found(1).name)))

function clearDir(dirname)
    filePattern = fullfile(dirname, '*.jpg'); % Change to whatever pattern you need.
    theFiles = dir(filePattern);
    for k = 1 : length(theFiles)
      baseFileName = theFiles(k).name;
      fullFileName = fullfile(dirname, baseFileName);
      delete(fullFileName);
    end
end

function sim = imageSimilarity(img1, img2)
    [rows, cols] = size(img1);
    match = 0;
    for i = 1 : rows
        for j = 1 : cols
            if (img1(i, j) == img2(i, j))
                match = match + 1;
            end
        end
    end
    sim = double(match/(rows*cols));
end