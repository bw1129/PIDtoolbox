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
posInfo.checkbox10=[.50 .965 .1 .025];
posInfo.checkbox11=[.50 .94 .1 .025];
posInfo.checkbox12=[.58 .965 .1 .025];
posInfo.checkbox13=[.58 .94 .1 .025];
posInfo.checkbox14=[.66 .965 .06 .025];
posInfo.checkbox15=[.66 .94 .06 .025];


posInfo.linewidth=[.71 .965 .07 .026];

checkpanel = uipanel('Title','','FontSize',fontsz,...
             'BackgroundColor',[.95 .95 .95],...
             'Position',[.096 .932 .69 .065]);        

guiHandles.checkbox0=uicontrol(PTfig,'Style','checkbox','String','Gyro (prefilt)','fontsize',fontsz,'ForegroundColor',[linec.col0],'BackgroundColor',bgcolor,...
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

guiHandles.linewidth = uicontrol(PTfig,'Style','popupmenu','string',{'line width 1','line width 2','line width 3','line width 4','line width 5'},...
    'fontsize',fontsz,'units','normalized','outerposition', [posInfo.linewidth],'callback','@selection; if ~isempty(filenameA), PTplotLogViewer; end');
 guiHandles.linewidth.Value = 2;
 
TooltipString_FileNum=['Select the file you wish to plot in the logviewer. '];
guiHandles.FileNum = uicontrol(PTfig,'Style','popupmenu','string',[fnameMaster],'TooltipString', [TooltipString_FileNum],...
    'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.fnameAText],'callback','@selection;if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.FileNum.Value=1;

if isempty(epoch1_A(guiHandles.FileNum.Value)) || isempty(epoch2_A(guiHandles.FileNum.Value))
    epoch1_A(guiHandles.FileNum.Value)=tta{guiHandles.FileNum.Value}(1)/us2sec;
    epoch2_A(guiHandles.FileNum.Value)=tta{guiHandles.FileNum.Value}(end)/us2sec;
end
 
% set IND for data subset. Updated in logviewer.
for f = 1 : Nfiles
    tIND{f} = tta{f} > (epoch1_A(f)*us2sec) & tta{f} < (epoch2_A(f)*us2sec);
end

guiHandles.Epoch1_A_text = uicontrol(PTfig,'style','text','string','start (s)','fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch1_A_text]);
guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',num2str(epoch1_A(guiHandles.FileNum.Value)),'fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
     'callback','@textinput_call; epoch1_A(guiHandles.FileNum.Value)=str2num(guiHandles.Epoch1_A_Input.String); ');
guiHandles.Epoch2_A_text = uicontrol(PTfig,'style','text','string','end (s)','fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch2_A_text]);
guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',num2str(epoch2_A(guiHandles.FileNum.Value)),'fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
     'callback','@textinput_call;epoch2_A(guiHandles.FileNum.Value)=str2num(guiHandles.Epoch2_A_Input.String); ');

posInfo.maxYtext = [.74 .94 .04 .025];
posInfo.maxYinput = [.715 .94 .025 .025];
maxY_textToolTip = ['+/- Scaling factor for the Y axis in degs/s'];
guiHandles.maxY_text = uicontrol(PTfig,'style','text','string','y scale','fontsize',fontsz,'TooltipString', [maxY_textToolTip],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxYtext]);
guiHandles.maxY_input = uicontrol(PTfig,'style','edit','string',int2str(maxY),'fontsize',fontsz,'TooltipString', [maxY_textToolTip],'units','normalized','outerposition',[posInfo.maxYinput],...
     'callback','@textinput_call; PTplotLogViewer; ');

