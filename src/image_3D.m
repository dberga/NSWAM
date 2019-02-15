function [s2] = image_3D(I,surf_plane,colormap_surf,colormap_img)
    if nargin<2, surf_plane=true; end
    if nargin <3, colormap_surf=jet; end
    if nargin <4, colormap_img=gray; end
    
    m = size(I,2);            % number of rows
    n = size(I,1);            % number of columns
    I = double(I);            % convert the entries to double
    minI = min(I(:));       % min of all the data
    maxI = max(I(:));       % max of all the data
    if surf_plane==1
        % we create a grid of the same size
        x = 1 : 1 : m; 
        y = 1 : 1 : n; 
        [X,Y] = meshgrid(x',y');

        %figure;
        %s2 = subplot(1,2,2);
    %     set(s2,'Units','normalized');
        hold on;
        s2=surf(X,Y,I,'LineStyle','none'); % the 3D view of the grayscale image
        colormap(colormap_surf);  % you can change the colormap
        caxis([minI,maxI]);             % to use the complete range of colormap
    %     colorbar;                       % add a colorbar
        imgzposition = 2*minI-maxI;     % position of the 2D view under the 3D view
        
        % scale the between [0, 255] in order to use a custom color map for it.
        scaledimg = (floor(((I - minI)./(maxI - minI))*255)); % perform scaling

        % convert the image to a true color image with the gray colormap.
        colorimg = ind2rgb(scaledimg,gray(256));

        % plot the image plane using surf.
        s1=surf([1 m],[1 n],repmat(imgzposition, [2 2]),...
            colorimg,'facecolor','texture');
        %set(s1.Parent,'YDir','reverse');
        set(s1(1).Parent,'YDir','reverse');
        set(s1(2).Parent,'YDir','reverse');
        colormap(colormap_img);
    elseif surf_plane==2
        hold on;
        x = 1 : 1 : m; 
        y = 1 : 1 : n; 
        [X,Y] = meshgrid(x',y');
        s2=surfc(X,Y,I,'LineStyle','none','facecolor','texture');
        set(s2(1).Parent,'YDir','reverse');
        set(s2(2).Parent,'YDir','reverse');
        [~,h]=contourf(X,Y,I);
        %set(h, 'ZData',I*imgzposition);
        colormap(colormap_surf);  
        hold off;
    else
        hold on;
        X=[1 m];
        Y=[1 n];
        Z=[0 0; 0 0];
        s2=surf(X,Y,I,'CData',I,'FaceColor','texture');
        set(s2.Parent,'YDir','reverse');
        %xlim([0 n]);
        %set(h, 'ZData',I*imgzposition);
        colormap(colormap_surf);  
        hold off;
    end
    view(30,42);
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
    hold off;
end

