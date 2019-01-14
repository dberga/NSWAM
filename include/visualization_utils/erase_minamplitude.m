function [ scanpath ] = erase_minamplitude(scanpath ,amplitude )
    
    f=2;
    if size(scanpath,1)>1 
        while (f <= size(scanpath,1))
            x=scanpath(f-1,1);
            y=scanpath(f-1,2);
            x_next=scanpath(f,1);
            y_next=scanpath(f,2);
            if pdist([x,y;x_next,y_next]) < amplitude
                scanpath(f-1,4)=scanpath(f,4); %copy max time
                scanpath(f,:)=[];
            else
                f=f+1;
            end
        end
    end
    
end
