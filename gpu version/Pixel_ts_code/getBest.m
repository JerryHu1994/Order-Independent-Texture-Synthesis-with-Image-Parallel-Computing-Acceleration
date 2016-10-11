function [chosenpixel] = getBest(input,neighborhood,neighsize,error)
% The function returns the best suitable pixel in the input given the
% neighbor.
% input: image from the current level of the input pyramids
% curroutput: enlarged output from one higher level synthesis
% neighsize: the size of neighborhood of a pixel used for choosing the best
% candidate
% error: the error range to choose candidates from the best pixel

% the output: the chosen pixel for 
offset = (neighsize -1)/2;
inputsize = size(input);

mapheight = inputsize(1)-2*offset;
mapwidth = inputsize(2)-2*offset;
ssdmap = zeros(mapheight,mapwidth);
% compute the SSD for each index in the ssdmap
for i = 1:mapheight;
    for j = 1:mapwidth
        curr = input(i:i+neighsize-1,j:j+neighsize-1);
        ssdmap(i,j) = sum(sum(((double(curr))-(double(neighborhood))).^2));
        center = double(curr(1+offset,1+offset))-double(neighborhood(offset+1,offset+1));
        ssdmap(i,j) = ssdmap(i,j) - center^2;
    end
end
%sort the ssdmap
[besterror,ind] = min(ssdmap(:));
%find all the pixels within the error range
candidates = find(ssdmap(:) <= besterror*(1+error));
randomindex = ceil(rand(1)*length(candidates));
chosenindex = candidates(randomindex);
[x,y] = ind2sub(size(ssdmap),chosenindex);
%[x,y] = ind2sub(size(ssdmap),ind);
% return the chosen pixel
chosenpixel = input(x+offset,y+offset);


%fprintf('The pixel at (%d, %d) is chosen\n',x,y);
end
