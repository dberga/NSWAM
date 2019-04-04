function [ scanpaths_gazes ] = scanpaths_gazes( scanpaths)

   max_gazes = 0;
   for i=1:length(scanpaths) %participant
       if length(scanpaths{i})>max_gazes
           max_gazes = length(scanpaths{i});
       end
   end
   
   scanpaths_gazes = cell(max_gazes,1);
   for k=1:max_gazes %gaze
       for i=1:length(scanpaths) %participant
           single_scanpath = scanpaths{i};
           try
                scanpaths_gazes{k} = [scanpaths_gazes{k}; single_scanpath(1:k,:)];
           catch
               scanpaths_gazes{k} = [scanpaths_gazes{k}];
           end
       end
   end       

    
end



