clc; close all; clear;

imageName = 'datasetFloor';

I = imread(sprintf('%s.png', imageName));

I = rgb2gray(I);


I = imgaussfilt(I,0.9);
[centers, radii, metric]  = imfindcircles(I, [3 10], 'ObjectPolarity','dark','Method', 'TwoStage');


goodCenters = centers;
goodRadii = radii;

thre = 30;
figure
while 1
imshow(I)
viscircles(goodCenters, goodRadii,'EdgeColor','b');
[x,y] = ginput(1);
if x < thre && y < thre
    break;
end
minXY = 1000;
minI = 1;
for i=1:size(goodCenters, 1)
    c  = goodCenters(i,:);
    x1 = c(1); y1 = c(2);
    xy = (x1-x)^2 + (y1-y)^2;
    if xy < minXY
        minXY = xy;
        minI = i;
    end
end

goodCenters(minI,:)=[];
goodRadii(minI) = [];
    
end
I1 = 255*ones(size(I));
I1 = uint8(I1);
rad = ceil(mean(goodRadii(:)));
cirs = [goodCenters ones(size(goodCenters,1),1)*rad];
I1 = insertShape(I1,'FilledCircle', cirs, 'Color', 'black');
%viscircles(goodCenters, goodRadii,'filled');
%hold on
%plot(goodCenters(:,1), goodCenters(:,2), '*')
figure;
imshow(I1);
imwrite(I1,[imageName 'Calib.png']);
