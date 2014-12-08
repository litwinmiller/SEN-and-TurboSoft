clc; % Clear the command window.
close all; % Close all figures 
workspace; % Make sure the workspace panel is showing.

%Determine platform, adjust path divider.
if ismac 
    slashdir = '/';
elseif ispc
    slashdir = '\';
end

%Get folder where photos reside.
phtdir = uigetdir('','Select directory with input jpg images');

%Get list of all photos using rdir
dirlist = dir(fullfile(phtdir,'*.jpg'));
phtlist = dirlist;

%Get folder where output binary files will go.
outphtdir = uigetdir('','Save binary output JPG images here');

%load each image and measure quantities. Runs for-loop through every image in directory
for h = 1:length(phtlist)
    
    %find root name, without .jpg
    p2=findstr('.jpg',phtlist(h).name)-1;
    rootname=phtlist(h).name(1:p2);
    
    %open image and call it 'grayImage'
    grayImage = imread([phtdir, slashdir, phtlist(h).name]);

    %convert image to binary using threshold set to 0.2. Determined this value by going through all threshold values for a single image and found this to give the best results for your image conditions.
    BW2 = im2bw(grayImage, 0.2);

    %Fills the holes of the binary image so that the pebble is completely filled
    BWfill = imfill(BW2,'holes');
    
    %removes the small white blobs (<1000 pix) from background of the image
    BWclean = bwareaopen(BWfill, 1000);
    
    %save binary image
    imwrite(BWclean, [outphtdir slashdir rootname '_binary.jpg'], 'jpg');
end
