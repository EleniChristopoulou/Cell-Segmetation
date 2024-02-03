function plotImages(images, titles)
    numImages = numel(images);
    numRows = ceil(sqrt(numImages));
    numCols = ceil(numImages / numRows);

    figure;

    for k = 1:numImages
        subplot(numRows, numCols, k);
        imshow(images{k});
        
        % Check if titles are provided
        if nargin > 1 && ~isempty(titles) && numel(titles) >= k
            title(titles{k});
        else
            title(['Image ', num2str(k)]);
        end
    end
end
