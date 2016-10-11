function [ output ] = synthesis( input,curroutput,pyramidsize,neighsize,error )
% The function snthesize the output based on the input and the output from
% the higher level.
% input: image from the current level of the input pyramids
% curroutput: the output from one higher level synthesis
% pyramidsize: the size of the pyramid
% neighsize: the size of neighborhood of a pixel used for choosing the best
% candidate
% error: the error range to choose candidates from the best pixel

% create an empty image with the same size as curroutput, to avoid cyclic
% dependency
output = zeros(pyramidsize,pyramidsize);

% loop through each pixel, extract its neighborhood, call the getBest()
% function to return the chosen candidate, and attach it onto the empty
% image

%imshow(curroutput);

parfor k = 1:pyramidsize*pyramidsize;
        
        [i,j] = ind2sub(pyramidsize,k);
        % extract the neighborhood region from the enlarged image
        neighborhood = curroutput(i:i+neighsize-1,j:j+neighsize-1);
        % get the best candidate for the pixel enclosed in the neighborhood
        temp(k) = getBest(input,neighborhood,neighsize,error);
        %display the pixel
        %imshow(output);
        %drawnow;
end

    output = reshape(temp,pyramidsize,pyramidsize);


end




