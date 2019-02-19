function [ tasktypes , difficulties] = get_tasktypes_difficulties( list_files,tasktypes_general,difficulties_general )
    if nargin < 3, difficulties_general={'d1','d2'}; end
    if nargin < 2, tasktypes_general={'fv','vs'}; end

    tasktypes=[];
    difficulties=[];
%     block=[];
%     block_cond=[];
    for f=1:length(list_files)
        for tt=1:length(tasktypes_general)
            if any(vertcat(strfind( list_files{f},tasktypes_general{tt})))
                tasktypes(f)=tt;
            end
        end
        for tt=1:length(difficulties_general)
            if any(vertcat(strfind( list_files{f},difficulties_general{tt})))
                difficulties(f)=tt;
            end
        end
%         for tt=1:length(blocks)
%             if any(vertcat(strfind( list_files{f},blocks{tt})))
%                 block(f)=tt;
%             end
%         end
%         for tt1=1:length(blocks)
%             if any(vertcat(strfind( list_files{f},blocks{tt1})))
%                 block_cond(f)=1;
%                 for tt2=1:length(blocks_cond{tt1})
%                     if any(vertcat(strfind( list_files{f},blocks_cond{tt1}{tt2})))
%                         block_cond(f)=tt2;
%                     end
%                 end
%             end
%         end
    end

end

