%% PTviewerUIcontrol 


% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------  
    
try
    
  
posInfo.checkbox0=[.1 .965 .1 .025];
posInfo.checkbox1=[.1 .94 .1 .025];
posInfo.checkbox2=[.18 .965 .1 .025];
posInfo.checkbox3=[.18 .94 .1 .025];
posInfo.checkbox4=[.27 .965 .1 .025];
posInfo.checkbox5=[.27 .94 .1 .025];
posInfo.checkbox6=[.36 .965 .1 .025];
posInfo.checkbox7=[.36 .94 .1 .025];
posInfo.checkbox8=[.45 .965 .1 .025];
posInfo.checkbox9=[.45 .94 .1 .025];
posInfo.checkbox10=[.54 .965 .1 .025];
posInfo.checkbox11=[.54 .94 .1 .025];
posInfo.checkbox12=[.63 .965 .1 .025];
posInfo.checkbox13=[.63 .94 .1 .025];
posInfo.checkbox14=[.73 .965 .06 .025];
posInfo.checkbox15=[.73 .94 .06 .025];

posInfo.linewidth=[.796 .904 .07 .026];

checkpanel = uipanel('Title','','FontSize',fontsz,...
             'BackgroundColor',[.95 .95 .95],...
             'Position',[.096 .932 .71 .065]);
         

guiHandles.checkbox0=uicontrol(PTfig,'Style','checkbox','String','Gyro (prefilt)','fontsize',fontsz,'ForegroundColor',[linec.col0],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox0],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox1=uicontrol(PTfig,'Style','checkbox','String','Gyro','fontsize',fontsz,'ForegroundColor',[linec.col1],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox1],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox2=uicontrol(PTfig,'Style','checkbox','String','P-term','fontsize',fontsz,'ForegroundColor',[linec.col2],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox2],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox3=uicontrol(PTfig,'Style','checkbox','String','I-term','fontsize',fontsz,'ForegroundColor',[linec.col3],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox3],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox4=uicontrol(PTfig,'Style','checkbox','String','D-term (prefilt)','fontsize',fontsz,'ForegroundColor',[linec.col4],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox4],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox5=uicontrol(PTfig,'Style','checkbox','String','D-term','fontsize',fontsz,'ForegroundColor',[linec.col5],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox5],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox6=uicontrol(PTfig,'Style','checkbox','String','F-term','fontsize',fontsz,'ForegroundColor',[linec.col6],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox6],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox7=uicontrol(PTfig,'Style','checkbox','String','Set point','fontsize',fontsz,'ForegroundColor',[linec.col7],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox7],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox8=uicontrol(PTfig,'Style','checkbox','String','PID sum','fontsize',fontsz,'ForegroundColor',[linec.col8],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox8],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox9=uicontrol(PTfig,'Style','checkbox','String','PID error','fontsize',fontsz,'ForegroundColor',[linec.col9],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox9],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');

if (A_debugmode~=DSHOT_RPM_TELEMETRY && A_debugmode~=GYRO_SCALED && A_debugmode~=0) || (B_debugmode~=DSHOT_RPM_TELEMETRY && B_debugmode~=GYRO_SCALED && B_debugmode~=0)
    guiHandles.checkbox10=uicontrol(PTfig,'Style','checkbox','String','Motor 1/debug 1','fontsize',fontsz,'ForegroundColor',[linec.col10],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox10],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox11=uicontrol(PTfig,'Style','checkbox','String','Motor 2/debug 2','fontsize',fontsz,'ForegroundColor',[linec.col11],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox11],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox12=uicontrol(PTfig,'Style','checkbox','String','Motor 3/debug 3','fontsize',fontsz,'ForegroundColor',[linec.col12],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox12],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox13=uicontrol(PTfig,'Style','checkbox','String','Motor 4/debug 4','fontsize',fontsz,'ForegroundColor',[linec.col13],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox13],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox14=uicontrol(PTfig,'Style','checkbox','String','Throttle','fontsize',fontsz,'ForegroundColor',[linec.col14],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox14],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
else
    guiHandles.checkbox10=uicontrol(PTfig,'Style','checkbox','String','Motor 1','fontsize',fontsz,'ForegroundColor',[linec.col10],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox10],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox11=uicontrol(PTfig,'Style','checkbox','String','Motor 2','fontsize',fontsz,'ForegroundColor',[linec.col11],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox11],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox12=uicontrol(PTfig,'Style','checkbox','String','Motor 3','fontsize',fontsz,'ForegroundColor',[linec.col12],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox12],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox13=uicontrol(PTfig,'Style','checkbox','String','Motor 4','fontsize',fontsz,'ForegroundColor',[linec.col13],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox13],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    guiHandles.checkbox14=uicontrol(PTfig,'Style','checkbox','String','Throttle','fontsize',fontsz,'ForegroundColor',[linec.col14],'BackgroundColor',bgcolor,...
        'units','normalized','outerposition',[posInfo.checkbox14],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
end

guiHandles.checkbox0.Value=1;
guiHandles.checkbox1.Value=1;
guiHandles.checkbox14.Value=1;

guiHandles.checkbox15=uicontrol(PTfig,'Style','checkbox','String','All','fontsize',fontsz,'ForegroundColor',[linec.col15],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox15],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), plotall_flag=guiHandles.checkbox15.Value; PTplotLogViewer; end');

guiHandles.linewidth = uicontrol(PTfig,'Style','popupmenu','string',{'line width 1','line width 2','line width 3','line width 4','line width 5'},...
    'fontsize',fontsz,'units','normalized','outerposition', [posInfo.linewidth],'callback','@selection; if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
  

catch
  %  close
end