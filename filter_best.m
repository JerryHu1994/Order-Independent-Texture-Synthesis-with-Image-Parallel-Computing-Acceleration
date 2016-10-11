function [ chosenpixel ] = filter_best( input,neighborhood,neighsize,error )
% The function returns the best suitable pixel in the input given the
% neighbor using filter.
% input: image from the current level of the input pyramids
% curroutput: enlarged output from one higher level synthesis
% neighsize: the size of neighborhood of a pixel used for choosing the best
% candidate
% error: the error range to choose candidates from the best pixel

% the output: the chosen pixel for 
% offset = (neighsize -1)/2;
% inputsize = size(input);
% 
% mapheight = inputsize(1)-2*offset;
% mapwidth = inputsize(2)-2*offset;
% ssdmap = zeros(mapheight,mapwidth);

% calculate squared difference between the input and neighborhood using
% filter2() in ssdmap.
norm = ones(size(neighborhood,1),size(neighborhood,2));

a2 = filter2(norm,input.^2,'valid');
b2 = sum(sum(neighborhood.^2));
ab = filter2(neighborhood,input,'valid');
ssdmap = abs(a2-ab.*2+b2);

best = min(ssdmap(:));
% find all the pixels within the error range
candidates = find(ssdmap(:) <= best*(1+error));
randomindex = ceil(rand(1)*length(candidates));
chosenindex = candidates(randomindex);
[x,y] = ind2sub(size(ssdmap),chosenindex);
% return the chosen pixel
chosenpixel = input(x,y);
%fprintf('The pixel at (%d, %d) is chosen\n',x,y);

end

