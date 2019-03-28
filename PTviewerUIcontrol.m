%% PTviewerUIcontrol

posInfo.checkbox0=[.1 .965 .1 .025];
posInfo.checkbox1=[.1 .94 .1 .025];
posInfo.checkbox2=[.2 .965 .1 .025];
posInfo.checkbox3=[.2 .94 .1 .025];
posInfo.checkbox4=[.3 .965 .1 .025];
posInfo.checkbox5=[.3 .94 .1 .025];
posInfo.checkbox6=[.4 .965 .1 .025];
posInfo.checkbox7=[.4 .94 .1 .025];
posInfo.checkbox8=[.5 .965 .1 .025];
posInfo.checkbox9=[.5 .94 .1 .025];
posInfo.checkbox10=[.6 .965 .1 .025];
posInfo.checkbox11=[.6 .94 .1 .025];
posInfo.checkbox12=[.7 .965 .1 .025];
posInfo.checkbox13=[.7 .94 .1 .025];
posInfo.checkbox14=[.8 .965 .06 .025];
posInfo.checkbox15=[.8 .94 .06 .025];

posInfo.linewidth=[.796 .904 .07 .026];

checkpanel = uipanel('Title','','FontSize',fontsz,...
             'BackgroundColor',[.95 .95 .95],...
             'Position',[.096 .932 .77 .065]);
         

guiHandles.checkbox0=uicontrol(PTfig,'Style','checkbox','String','Gyro (unfiltered)','fontsize',fontsz,'ForegroundColor',[linec.col0],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox0],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox1=uicontrol(PTfig,'Style','checkbox','String','Gyro','fontsize',fontsz,'ForegroundColor',[linec.col1],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox1],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox2=uicontrol(PTfig,'Style','checkbox','String','P-term','fontsize',fontsz,'ForegroundColor',[linec.col2],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox2],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox3=uicontrol(PTfig,'Style','checkbox','String','I-term','fontsize',fontsz,'ForegroundColor',[linec.col3],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox3],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
guiHandles.checkbox4=uicontrol(PTfig,'Style','checkbox','String','D-term (unfiltered)','fontsize',fontsz,'ForegroundColor',[linec.col4],'BackgroundColor',bgcolor,...
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

guiHandles.checkbox0.Value=1;
guiHandles.checkbox1.Value=1;
guiHandles.checkbox14.Value=1;

guiHandles.checkbox15=uicontrol(PTfig,'Style','checkbox','String','All','fontsize',fontsz,'ForegroundColor',[linec.col15],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.checkbox15],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), plotall_flag=guiHandles.checkbox15.Value; PTplotLogViewer; end');

guiHandles.linewidth = uicontrol(PTfig,'Style','popupmenu','string',{'line width 1','line width 2','line width 3','line width 4','line width 5'},...
    'fontsize',fontsz,'units','normalized','outerposition', [posInfo.linewidth],'callback','@selection; if (~isempty(filenameA) | ~isempty(filenameB)), PTplotLogViewer; end');
    