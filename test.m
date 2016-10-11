input = imread('texture.jpeg');
input = rgb2gray(input)
figure
imshow(input)
output = imresize(input,2);
