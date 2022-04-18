%% PTviewerUIcontrol 


% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------  
    

posInfo.checkbox0=[.1 .965 .1 .025];
posInfo.checkbox1=[.1 .94 .1 .025];
posInfo.checkbox2=[.18 .965 .1 .025];
posInfo.checkbox3=[.18 .94 .1 .025];
posInfo.checkbox4=[.26 .965 .1 .025];
posInfo.checkbox5=[.26 .94 .1 .025];
posInfo.checkbox6=[.34 .965 .1 .025];
posInfo.checkbox7=[.34 .94 .1 .025];
posInfo.checkbox8=[.42 .965 .1 .025];
posInfo.checkbox9=[.42 .94 .1 .025];
posInfo.checkbox13=[.50 .965 .06 .025];%m4
posInfo.checkbox12=[.50 .94 .06 .025];%m3
posInfo.checkbox11=[.58 .965 .06 .025];%m2
posInfo.checkbox10=[.58 .94 .06 .025]; %m1
posInfo.checkbox14=[.66 .965 .06 .025];
posInfo.checkbox15=[.66 .94 .06 .025];

posInfo.maxYtext = [.70 .965 .04 .025];
posInfo.maxYinput = [.735 .965 .025 .025];

posInfo.nCols_text = [.70 .94 .04 .025];
posInfo.nCols_input = [.735 .94 .025 .025];

posInfo.YTstick = [.892 vPos-0.39 .045 .085];
posInfo.RPstick = [.948 vPos-0.39 .045 .085];

posInfo.linepos1=[0.095 0.665 0.77 0.261];
posInfo.linepos2=[0.095 0.395 0.77 0.261];
posInfo.linepos3=[0.095 0.125 0.77 0.261];

fullszPlot = [0.095 0.07 0.77 0.855];


checkpanel = uipanel('Title','','FontSize',fontsz,...
             'BackgroundColor',[.95 .95 .95],...
             'Position',[.096 .932 .68 .065]);        

guiHandles.checkbox0=uicontrol(PTfig,'Style','checkbox','String','Debug','fontsize',fontsz,'ForegroundColor',[linec.col0],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox0],'callback','if ~isempty(fnameMaster),  PTplotLogViewer; end');
guiHandles.checkbox1=uicontrol(PTfig,'Style','checkbox','String','Gyro','fontsize',fontsz,'ForegroundColor',[linec.col1],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox1],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox2=uicontrol(PTfig,'Style','checkbox','String','P-term','fontsize',fontsz,'ForegroundColor',[linec.col2],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox2],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox3=uicontrol(PTfig,'Style','checkbox','String','I-term','fontsize',fontsz,'ForegroundColor',[linec.col3],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox3],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox4=uicontrol(PTfig,'Style','checkbox','String','D-term (prefilt)','fontsize',fontsz,'ForegroundColor',[linec.col4],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox4],'callback','if (~isempty(filenameA) ), PTplotLogViewer; end');
guiHandles.checkbox5=uicontrol(PTfig,'Style','checkbox','String','D-term','fontsize',fontsz,'ForegroundColor',[linec.col5],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox5],'callback','if (~isempty(filenameA) ), PTplotLogViewer; end');
guiHandles.checkbox6=uicontrol(PTfig,'Style','checkbox','String','F-term','fontsize',fontsz,'ForegroundColor',[linec.col6],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox6],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox7=uicontrol(PTfig,'Style','checkbox','String','Set point','fontsize',fontsz,'ForegroundColor',[linec.col7],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox7],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox8=uicontrol(PTfig,'Style','checkbox','String','PID sum','fontsize',fontsz,'ForegroundColor',[linec.col8],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox8],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox9=uicontrol(PTfig,'Style','checkbox','String','PID error','fontsize',fontsz,'ForegroundColor',[linec.col9],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox9],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox10=uicontrol(PTfig,'Style','checkbox','String','Motor 1','fontsize',fontsz,'ForegroundColor',[linec.col10],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox10],'callback','if (~isempty(filenameA) ), PTplotLogViewer; end');
guiHandles.checkbox11=uicontrol(PTfig,'Style','checkbox','String','Motor 2','fontsize',fontsz,'ForegroundColor',[linec.col11],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox11],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox12=uicontrol(PTfig,'Style','checkbox','String','Motor 3','fontsize',fontsz,'ForegroundColor',[linec.col12],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox12],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox13=uicontrol(PTfig,'Style','checkbox','String','Motor 4','fontsize',fontsz,'ForegroundColor',[linec.col13],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox13],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.checkbox14=uicontrol(PTfig,'Style','checkbox','String','Throttle','fontsize',fontsz,'ForegroundColor',[linec.col14],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox14],'callback','if ~isempty(fnameMaster), PTplotLogViewer; end');

guiHandles.checkbox1.Value=1;
guiHandles.checkbox7.Value=1;
guiHandles.checkbox14.Value=1;

guiHandles.checkbox15=uicontrol(PTfig,'Style','checkbox','String','All','fontsize',fontsz,'TooltipString', ['Plot or clear all lines '],'ForegroundColor',[linec.col15],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox15],'callback','if ~isempty(fnameMaster), plotall_flag=guiHandles.checkbox15.Value; PTplotLogViewer; end');
 
TooltipString_FileNum=['Select the file you wish to plot in the logviewer. '];
guiHandles.FileNum = uicontrol(PTfig,'Style','popupmenu','string',[fnameMaster],'TooltipString', [TooltipString_FileNum],...
    'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.fnameAText],'callback','if ~isempty(fnameMaster), set(zoom, ''Enable'',''off''), expandON=0; PTplotLogViewer; if ~isempty(filenameA) && guiHandles.startEndButton.Value, [x y] = ginput(1); epoch1_A(guiHandles.FileNum.Value) = round(x(1)*10)/10; PTplotLogViewer; [x y] = ginput(1); epoch2_A(guiHandles.FileNum.Value) = round(x(1)*10)/10; PTplotLogViewer, end, end');

            
if isempty(epoch1_A(guiHandles.FileNum.Value)) || isempty(epoch2_A(guiHandles.FileNum.Value))
    epoch1_A(guiHandles.FileNum.Value)=tta{guiHandles.FileNum.Value}(1)/us2sec;
    epoch2_A(guiHandles.FileNum.Value)=tta{guiHandles.FileNum.Value}(end)/us2sec;
end

% set IND for data subset. Updated in logviewer.
for f = 1 : Nfiles
    tIND{f} = tta{f} > (epoch1_A(f)*us2sec) & tta{f} < (epoch2_A(f)*us2sec);
end

maxY_textToolTip = ['+/- Scaling factor for the Y axis in degs/s'];
guiHandles.maxY_text = uicontrol(PTfig,'style','text','string','y scale','fontsize',fontsz,'TooltipString', [maxY_textToolTip],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxYtext]);
guiHandles.maxY_input = uicontrol(PTfig,'style','edit','string',int2str(maxY),'fontsize',fontsz,'TooltipString', [maxY_textToolTip],'units','normalized','outerposition',[posInfo.maxYinput],...
     'callback','PTplotLogViewer; ');
 
guiHandles.nCols_text = uicontrol(PTfig,'style','text','string','N colors','fontsize',fontsz,'TooltipString', ['sets the number of colors for other tools (allowable range 1 - 20)'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.nCols_text]);
guiHandles.nCols_input = uicontrol(PTfig,'style','edit','string',int2str(nLineCols),'fontsize',fontsz,'TooltipString', ['sets the number of colors for other tools (allowable range 1 - 20)'],'units','normalized','outerposition',[posInfo.nCols_input],...
     'callback','if str2num(guiHandles.nCols_input.String) > 20, guiHandles.nCols_input.String = ''20''; end; if str2num(guiHandles.nCols_input.String) < 1, guiHandles.nCols_input.String = ''1''; end; multiLineCols=PTlinecmap(str2num(guiHandles.nCols_input.String)); ');
 
subplot('position',[posInfo.YTstick]); 
set(gca, 'xlim', [-500 500], 'ylim', [0 100], 'xticklabel',[], 'yticklabel',[],'xtick',[0], 'ytick',[50], 'xgrid', 'on', 'ygrid', 'on'); 
box on
subplot('position',[posInfo.RPstick])
set(gca, 'xlim', [-500 500], 'ylim', [0 100], 'xticklabel',[], 'yticklabel',[],'xtick',[0], 'ytick',[50], 'xgrid', 'on', 'ygrid', 'on'); 
box on

try guiHandles.maxY_input.String = num2str(defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-Ymax')))), catch, end
try guiHandles.nCols_input.String = num2str(defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-Ncolors')))), catch, end


