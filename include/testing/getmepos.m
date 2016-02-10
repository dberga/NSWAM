function [rectSource rectDest] = getmepos(screenWidth, screenHeight, bmp, scrpos)

%Gives the coordinates of the destination rectange according to the size of
%the picture and the desired screen position. Options are:
% centre: picture goes at the centre. No distortions
% left and right : idem, no distorion
% centre-max: picture goes at the centre, size equal to half the screen
% left-max and right-max: same for left and right
% centre-huge: picture at the centre with maximum size.

if nargin <4
    scrpos='centre';
end

[picHeight, picWidth, planes] = size(bmp);
rectSource = [ 0 0 picWidth picHeight ];
margen = 5;

switch lower(scrpos)
    case 'centre' %center on screen
        rectDest = [ round((screenWidth-picWidth)/2) round((screenHeight-picHeight)/2) round((screenWidth+picWidth)/2) round((screenHeight+picHeight)/2) ];
    case 'left'
        rectDest = [ round((screenWidth/2-picWidth)/2) round((screenHeight-picHeight)/2) round((screenWidth/2+picWidth)/2) round((screenHeight+picHeight)/2) ];
    case 'right'
        rectDest = [ round(screenWidth/2+(screenWidth/2-picWidth)/2) round((screenHeight-picHeight)/2) round(screenWidth/2+(screenWidth/2+picWidth)/2) round((screenHeight+picHeight)/2) ];
    case 'centre-max'
        newPicWidth = round(screenWidth / 2 - 2*margen);
        newPicHeight = round(picHeight ./ picWidth * newPicWidth);
        rectDest = [ round((screenWidth-newPicWidth)/2) round((screenHeight-newPicHeight)/2) round((screenWidth+newPicHeight)/2) round((screenHeight+newPicHeight)/2) ];
    case 'left-max' %place on the left
        newPicWidth = round(screenWidth / 2 - 2*margen);
        newPicHeight = round(picHeight ./ picWidth * newPicWidth);
        rectDest = [margen round((screenHeight-newPicHeight)/2) round(screenWidth/2 - margen) round((screenHeight+newPicHeight)/2) ];
    case 'right-max' %place on the right    
        newPicWidth = round(screenWidth / 2 - 2*margen);
        newPicHeight = round(picHeight ./ picWidth * newPicWidth);
        rectDest = [round(screenWidth/2 + margen) round((screenHeight-newPicHeight)/2) (screenWidth - margen) round((screenHeight+newPicHeight)/2) ];
    case 'centre-huge'
        newPicHeight = round(screenHeight - 2*margen);
        newPicWidth = round(picWidth ./ picHeight * newPicHeight);
        rectDest = [ round((screenWidth-newPicWidth)/2) round((screenHeight-newPicHeight)/2) round((screenWidth+newPicHeight)/2) round((screenHeight+newPicHeight)/2) ];
        
    otherwise
        error('Wrong position');
end