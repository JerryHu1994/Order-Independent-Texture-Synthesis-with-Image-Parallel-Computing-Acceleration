function [ output ] = ts_pixel( Imagename, outsize, pyramidlevel,neighsize, pyramidfactor,error,iteration)
% Input:
% Imagename: the name of the input image
% outsize: the size of the output graph 
% pyramidlevel: the number of pyramid levels used in the synthesis.
% neighsize: size of neighborhood of a pixel used for choosing the best
% candidate
% pyramidfactor: the size factor between each level of pyramid
% error: the error range to choose candidates from the best pixel

% Output:
% OutputImage: the output image after texture synthesis

start = tic;
% record the total time

% set the default pyramidfactor
if(nargin < 7)
    iteration = 2;
end
if(nargin < 6)
    error = 0.1;
end
if(nargin < 5)
    pyramidfactor = 2;
end
%set the default neighsize
if (nargin < 4)
    neighsize = 3;
end
%set the default pyramidsize
if (nargin < 3)
    pyramidlevel = 5;
end
%check the valid parameter

offset = neighsize-1;
input = imread(Imagename);
%determine the size of the input image
[height, width, colorchannel] = size(input);
if (height*((1/pyramidfactor)^pyramidlevel) < neighsize) or (width*((1/pyramidfactor)^pyramidlevel) < neighsize)
    error('Invalid parameter: The size of the highest pyramid level should be larger than neighborhood size.');
end
% check the input image
if (colorchannel == 3 )
    %convert the RGB to grayscale
    input = rgb2gray(input);
  
[height, width, colorchannel] = size(input);
if(colorchannel ~= 1)
    error('Input image must be either grayscale or RGB.');
end

%display the input image
figure(1);
imshow(input)
title('input sample')

sample = tic;
% record time of sampling
% sample through the input image and determine the ratio between black and
% white pixels
insize = size(input);
inputlength = insize(1)*insize(2);
black = 0;
white = 0;
for i = 1:200,
    % generate a random number
    num = ceil(rand*inputlength);
    % convert it to matrix index
    [I,J]=ind2sub(insize,num);
    % seperation
    if input(I,J) < 128
        black = black + 1;
    else
        white = white + 1;
    end
end
% calculate the ratio between black and white
ratio = black/(black+white);

sampletime = toc(sample)

% start with an empty image for the highest level
% output = zeros(outsize*((1/pyramidfactor)^pyramidlevel)+offset,outsize*((1/pyramidfactor)^pyramidlevel)+offset);

% start with a random image with black and white 
s = int64(outsize*((1/pyramidfactor)^pyramidlevel)+offset);
output = zeros(s,s);
for i = 1:s,
   for j = 1:s,
       r = rand;
       if r < ratio
            output(i,j) = 0;
       else
           output(i,j) = 256;
       end
   end
end
output = 256*output;

%output = imresize(input,[outsize*((1/pyramidfactor)^pyramidlevel)+offset,outsize*((1/pyramidfactor)^pyramidlevel)+offset]);
synthe = tic;
% record the time of synthesis
for i =pyramidlevel:-1:1,
    
    % filter all pixels in the image
    for a = 1:size(output,1),
        for b = 1:size(output,2),
            if output(a,b) < 128
                output(a,b) = 0;
            else
                output(a,b) = 256;
            end
        end
    end
    figure;
    imshow(output);
    fprintf('Start synthesizing % d level: \n',i);
    %compute the current scale
    scale = (1/pyramidfactor)^i;
    %resize the image to the current level
    currimage = imresize(input,scale);
    inputsize = size(currimage);
    fprintf('The current input pryramid size is %d * %d.\n', inputsize(1),inputsize(2));
    synsize = size(output);
    fprintf('The current synthesize size is %d * %d.\n\n',synsize(1)-offset, synsize(2)-offset);
    %call the synthesis funciton to do synthesis for the current level
    figure;
    title('synthesizing');
    currresult = synthesis(currimage,output,synsize(1)-offset,neighsize,error);
%     for j = 1:iteration,
%         currresult = synthesis(currimage,output,synsize(1)-offset,neighsize,error);
%         if j == iteration
%             
%         else
%             output = imresize(currresult,[synsize(1),synsize(1)]);
%         end
%     end
    %imshow(currresult)
    currsize = size(currresult);
    
    % resize the image to the one level lower 
    if i == 1
        % at the last iteration, enlarge the image by a factor of pyramidfactor
        output = imresize(currresult,pyramidfactor);
    else
        % resize the image to the one level lower 
        % construct a larger curroutput with boundary and edge filled
        output = imresize(currresult,[currsize(1)*pyramidfactor+offset,currsize(2)*pyramidfactor+offset]);
    end
    
end

synthetime = toc(synthe)

% filter all pixels
for a = 1:size(output,1),
        for b = 1:size(output,2),
            if output(a,b) < 130
                output(a,b) = 0;
            else
                output(a,b) = 256;
            end
        end
end

figure;
imshow(output);
title('output graph');
fprintf('Finished');


totaltime = toc(start)
end


