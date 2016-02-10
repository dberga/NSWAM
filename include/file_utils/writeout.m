function [  ] = writeout( image, image_name, output_folder, output_extension )



%write output image on output folder
if strcmp(output_extension,'.mat')
	save([output_folder '/' image_name output_extension], image);
else %png, jpg ...
	imwrite(image,[output_folder '/' image_name output_extension ]);
end


end

