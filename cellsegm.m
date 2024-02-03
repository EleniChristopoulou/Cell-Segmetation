close all; clear; clc;
I = imread('normal_40.tif');

figure;
plot(imhist(I));                            % Histogram of Image
titles = {'Thresshold: 35', 'Thresshold: 40', 'Thresshold: 45', 'Original'};
plotImages({I>30,I>40, I>45,I},titles);     %  Compare Thressholds

Ibinary = I>40;                     % convert to Binary, thresshold is 40

Ifill = imfill(Ibinary,"holes");   
%plotImages({Ibinary, Ifill},{"before imfill","after im fill"});

%seSizes = [3, 5, 7]; % Experiment with different sizes
%seShapes = {'square', 'rectangle', 'disk'}; % Experiment with different shapes
se = strel('disk', 10);

%------------Expierementing-------------
%Ierosion = imerode(Ifill,se);       % Erosion
%Idilation = imdilate(Ifill,se);     % Dilation

%Iopen = imerode(Idilation,se);
%Iclose = imdilate(Ierosion,se);
%Iperimetre = Ibinary - Ierosion;

%titles = {'I perimetre', 'I>40', 'close I','open I','fill I', 'erosion'};
%plotImages({Iperimetre, Ibinary, Iclose, Iopen, Ifill, Ierosion},titles);
%-------------------------

%D = bwdist(~Ifill);                % To compare over segmetation results
%phenomenom
%figure;
%D = -D;
%L = watershed(imhmin(255-uint8(bwdist(~Ifill)),5));
%L(~Ifill) = 0;
%rgb = label2rgb(L,'jet',[.5 .5 .5]);
%subplot(1,2,1);
%imshow(rgb)
%L = watershed(D);
%L(~Ifill) = 0;
%rgb = label2rgb(L,'jet',[.5 .5 .5]);
%subplot(1,2,2);
%imshow(rgb)

distanceTransform = imhmin(255-uint8(bwdist(~Ifill)),5);
segmentation = watershed(distanceTransform);
labeled = segmentation == 0;
overlayedImage = imoverlay(Ibinary, segmentation == 0, [1 0 0]);
%titles = {'Colored Watershed', "Result of Image & Labeled image",'Distance Transform', 'Labeled Image'};
%plotImages({label2rgb(segmentation), label2rgb(bwlabel(Ifill & ~labeled)), distanceTransform, labeled},titles);

%figure;
%imshow(labeloverlay(double(Ifill), double(labeled), "Colormap", [1 0 0], "Transparency",0))

se = strel('disk', 4);
finalImg = bwlabel(imerode(segmentation & Ifill,se));
titles = {'Watershed Result','Ifill' , 'Ifill & Watershed' ,'Erosion of Ifill & Segmetation'};
plotImages({segmentation, Ifill, (segmentation & Ifill),finalImg}, titles);
stats = regionprops(finalImg, 'Area', 'Perimeter', 'MajorAxisLength','MinorAxisLength');

disp('Cell Properties including Symmetry:');
for k = 1:length(stats)
    % Calculate aspect ratio as a measure of symmetry
    aspectRatio = stats(k).MajorAxisLength / stats(k).MinorAxisLength;

    disp(['Cell ', num2str(k), ' Area: ', num2str(stats(k).Area), ...
          ' Major Axis: ', num2str(stats(k).MajorAxisLength), ...
          ' Minor Axis: ', num2str(stats(k).MinorAxisLength), ...
          ' Symmetry (Aspect Ratio): ', num2str(aspectRatio)]);
end
