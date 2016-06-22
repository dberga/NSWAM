function foundScans=selectInitParameters(foundScans)

if isunix
    fontSize = 10;
else
    fontSize = 9;
end
global HandlesOfGUI;
global lastedit; %#ok<NUSED>

ActionList={'Nothing','Inplanes','Functional','RefFunc'};

OptionsPerColumn=20;
nDirs = size(foundScans,2);
ncols=ceil(nDirs/OptionsPerColumn);
nOptionsPerColumn=ceil(nDirs/ncols);
headerStr='Parameters';

%scale factors for x and y axis coordinates
xs = 1.8;
ys = 1.8;
colwidth=64;
colPos=[2 10 35 45 58 66 80 91 103 112 124];
%default sizes
butWidth=10;
botMargin = 0.2;
height = nDirs*ys+botMargin+10;
width = max(140);


%open the figure
h_mainFig = figure('MenuBar','none',...
    'Units','char',...
    'Resize','off',...
    'NumberTitle','off',...
    'Position',[20, 10, width,height]);
bkColor = get(h_mainFig,'Color');

%___________________________________________________________
%Display title inside a frame
x = 1;
% y = nOptions+1+botMargin;
y = height/ys-2;
uicontrol('Style','frame',...
    'Units','char',...
    'String',headerStr,...
    'Position',[x*xs,(y+.2)*ys,(width-3),ys*1.3],...
    'HorizontalAlignment','center',...
    'FontSize',fontSize);
uicontrol('Style','text',...
    'Units','char',...
    'String',headerStr,...
    'Position',[(x+.25)*xs,(y+.3)*ys,(width-2.50),ys*.9],...
    'HorizontalAlignment','center',...
    'FontSize',fontSize+2);

y=y-1.1;
colT=1; %a couter to increase the column the menue is written into
putuptext('Dir',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('Protocol',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('NoFiles',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('Date',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('run',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-3,ys*.9],fontSize);
colT=colT+1;
putuptext('Action',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('Volume',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('Slices',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('Skip',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
colT=colT+1;
putuptext('Cycles',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);

y=y-0.1;
for ii=1:length(foundScans)
    y=y-1;
   colT=1; 
    %report the findings
    putuptext(int2str(ii),[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
    colT=colT+1;
    putuptext(foundScans(ii).Sequence,[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
    colT=colT+1;
    putuptext(int2str(foundScans(ii).Files),[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
    colT=colT+1;
    putuptext(foundScans(ii).params.date,[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],fontSize);
    colT=colT+1;
    putuptext(foundScans(ii).params.scno,[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-3,ys*.9],fontSize);
    
    %the aktionMenue
    colT=colT+1;
    pos=[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9];
    h_action(ii) = uicontrol('Units','char','HorizontalAlignment','left',...
        'Style','popupmenu','String',ActionList,'Position',pos,'BackgroundColor',[0.85 0.85 0.85]);
    if isempty(foundScans(ii).Action)
        ActionVal=1;
    else
        ActionVal=find(strcmp(foundScans(ii).Action,ActionList));
    end
    set(h_action(ii),'Value',ActionVal);

    %the parameters of the scans

    colT=colT+1;
    h_Volumes(ii)=uicontrol('Units','char','HorizontalAlignment','center',...
        'Style','edit','String',num2str(foundScans(ii).Volumes,4),...
        'Position',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],'BackgroundColor',[0.85 0.85 0.85]);
    callBackStr=['global lastedit;lastedit=',char(39),'Vol_',int2str(ii),char(39),';'];
    set(h_Volumes(ii),'Callback',callBackStr);

    colT=colT+1;
    h_Slices(ii)=uicontrol('Units','char','HorizontalAlignment','center',...
        'Style','edit','String',int2str(foundScans(ii).Slices),...
        'Position',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],'BackgroundColor',[0.85 0.85 0.85]);
    callBackStr=['global lastedit;lastedit=',char(39),'Sli_',int2str(ii),char(39),';'];
    set(h_Slices(ii),'Callback',callBackStr);

    colT=colT+1;
    h_SkipVols(ii)=uicontrol('Units','char','HorizontalAlignment','center',...
        'Style','edit','String',int2str(foundScans(ii).SkipVols),...
        'Position',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],'BackgroundColor',[0.85 0.85 0.85]);
    callBackStr=['global lastedit;lastedit=',char(39),'Ski_',int2str(ii),char(39),';'];
    set(h_SkipVols(ii),'Callback',callBackStr);


    colT=colT+1;
    h_Cycles(ii)=uicontrol('Units','char','HorizontalAlignment','center',...
        'Style','edit','String',int2str(foundScans(ii).Cycles),...
        'Position',[colPos(colT),(y+.3)*ys,colPos(colT+1)-colPos(colT)-1,ys*.9],'BackgroundColor',[0.85 0.85 0.85]);
    callBackStr=['global lastedit;lastedit=',char(39),'Cyc_',int2str(ii),char(39),';'];
    set(h_Cycles(ii),'Callback',callBackStr);
end

HandlesOfGUI.h_Volumes=h_Volumes;
HandlesOfGUI.h_Slices=h_Slices;
HandlesOfGUI.h_SkipVols=h_SkipVols;
HandlesOfGUI.h_Cycles=h_Cycles;



y=y-1.4;
uicontrol('Style','pushbutton',...
    'String','Cancel',...
    'Units','char',...
    'Position',[colPos(4)-4,(y+.3)*ys,colPos(5)-colPos(4)-4,ys*.9],...
    'CallBack','uiresume',...
    'FontSize',fontSize,...
    'UserData','Cancel');

x = width-butWidth-1;
uicontrol('Style','pushbutton',...
    'String','OK',...
    'Units','char',...
    'Position',[colPos(2),(y+.3)*ys,colPos(3)-colPos(2)-4,ys*.9],...
    'CallBack','uiresume',...
    'FontSize',fontSize,...
    'UserData','OK');
global MY_GLOBAL
CopyDownString=['global lastedit; global h_Volumes; selectInitParamChange(lastedit);'];

sabutton=uicontrol('Style','pushbutton',...
    'String','Fill last Value',...
    'Units','char',...
    'Position',[colPos(6)-5,(y+.3)*ys,colPos(8)-colPos(6)-2,ys*.9],...
    'FontSize',fontSize-4,...
    'Callback',CopyDownString,...
    'UserData','OK');


%let the user select some radio buttons and
%wait for a 'uiresume' callback from OK/Cancel
uiwait

%determine which button was hit.
response = get(gco,'UserData');

%gather the status of the radio buttons if 'OK' was
%selected.  Otherwise return empty matrix.
if strcmp(response,'OK')
    for thisScan=1:length(foundScans)
        foundScans(thisScan).Action=ActionList(get(h_action(thisScan),'Value'));
        foundScans(thisScan).Volumes=getNumberFromString(get(h_Volumes(thisScan),'String'));
        foundScans(thisScan).Slices=getNumberFromString(get(h_Slices(thisScan),'String'));
        foundScans(thisScan).SkipVols=getNumberFromString(get(h_SkipVols(thisScan),'String'));
        foundScans(thisScan).Cycles=getNumberFromString(get(h_Cycles(thisScan),'String'));
    end

else
    foundScans = [];
end

close(h_mainFig);

return;
end

function putuptext(TEXT,pos,fontSize)
uicontrol('Style','text',...
    'Units','char',...
    'String',TEXT ,...
    'Position',pos,...
    'HorizontalAlignment','center',...
    'FontSize',9);
end

function number=getNumberFromString(inputString)
number=str2double(inputString);

end

