clear all
close all
clc

clear;

% Fusion types to choose from
fusionTypes = {'MeanMean', 'MeanMax', 'MeanMin', ...
               'MaxMean', 'MaxMax', 'MaxMin', ...
               'MinMean', 'MinMax', 'MinMin'};

[fusionIdx, okFusion] = listdlg('PromptString', 'Select a Fusion Type:', ...
                                'SelectionMode', 'single', ...
                                'ListString', fusionTypes);
if ~okFusion
    error('Fusion type selection cancelled.');
end

fusiontype = fusionTypes{fusionIdx};

% One of the most commonly used wavetypes for image fusion 
wavetype = 'coif5';

% Loading the images:
image1 = selectAndReadImage();
image2 = selectAndReadImage();

% Global size of image 1 and 2 and output:
[row, col] = size(image1(:,:,1));

% Image 1 and 2 must be the same szie:
if ~isequal(size(image1), size(image2))
    image2 = imresize(image2, [row, col]);
end

% Ensure both images have the same number of channels
if size(image1, 3) ~= size(image2, 3)
    if size(image1, 3) == 1
        image1 = repmat(image1, 1, 1, 3);
    elseif size(image2, 3) == 1
        image2 = repmat(image2, 1, 1, 3);
    end
end

% Perform fusion based on the number of channels
if size(image1, 3) == 3
    % Fuse each color channel (Red, Green, Blue) separately
    fusedImageR = fuse2image(image1(:,:,1), image2(:,:,1), fusiontype, wavetype);
    fusedImageG = fuse2image(image1(:,:,2), image2(:,:,2), fusiontype, wavetype);
    fusedImageB = fuse2image(image1(:,:,3), image2(:,:,3), fusiontype, wavetype);

    fusedImage = uint8(cat(3, fusedImageR, fusedImageG, fusedImageB));
else
    % Single-channel grayscale fusion
    fusedGray = fuse2image(image1, image2, fusiontype, wavetype);
    fusedImage = uint8(fusedGray);
end

% Writing the image out to the file system as .jpg:
imwrite(imresize(fusedImage, [row, col]), 'fusedImage.jpg','Quality',100);

%Plotting images:
figure;
subplot(1,3,1), imshow(image1), title('Image 1');
subplot(1,3,2), imshow(image2), title('Image 2');
subplot(1,3,3), imshow(fusedImage), title('Fused Image');
