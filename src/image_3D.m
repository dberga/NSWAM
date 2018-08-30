function [] = image_3D(I)
    m = size(I',1);            % number of rows
    n = size(I',2);            % number of columns
    I = double(I);            % convert the entries to double
    minI = min(min(I));       % min of all the data
    maxI = max(max(I));       % max of all the data

    % we create a grid of the same size
    x = 1 : 1 : m; 
    y = 1 : 1 : n; 
    [X,Y] = meshgrid(x',y');

    %figure;
    %s2 = subplot(1,2,2);
%     set(s2,'Units','normalized');
    hold on;
    surf(X,Y,I,'LineStyle','none'); % the 3D view of the grayscale image
    colormap(jet);                  % you can change the colormap
    caxis([minI,maxI]);             % to use the complete range of colormap
%     colorbar;                       % add a colorbar
    imgzposition = 2*minI-maxI;     % position of the 2D view under the 3D view

    % scale the between [0, 255] in order to use a custom color map for it.
    scaledimg = (floor(((I - minI)./(maxI - minI))*255)); % perform scaling

    % convert the image to a true color image with the gray colormap.
    colorimg = ind2rgb(scaledimg,gray(256));

    % plot the image plane using surf.
    s2=surf([1 m],[1 n],repmat(imgzposition, [2 2]),...
        colorimg,'facecolor','texture');
    set(s2.Parent,'YDir','reverse');
    view(45,30);
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
%     title('3D view of the grayscale image');

    % We put aside the input grayscale image
%     s1 = subplot(1,2,1);
%     set(s1,'Units','normalized');
%     imagesc(colorimg);
%     xlabel('x');
%     ylabel('y');
%     title('the input grayscale image');
%     truesize;
end

