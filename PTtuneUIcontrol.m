%% PTtuneUIcontrol - ui controls for tuning-specific parameters

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(fnameMaster)
    
PTtunefig=figure(4);
set(PTtunefig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTtunefig.NumberTitle='on';
PTtunefig.Name= ['PIDtoolbox (' PtbVersion ') - Step Response Tool'];
PTtunefig.InvertHardcopy='off';
set(PTtunefig,'color',bgcolor)

updateStep=0;

TooltipString_steprun=['Runs step response analysis.',...
    newline, 'Warning: Set subsampling dropdown @ or < medium for faster processing.'];
TooltipString_minRate=['Input the minimum rate of rotation for calculating the step response (lower bound must be > 0 but lower than upper bound).',...
    newline, 'Really low values may yield more noisy contributions to the data, whereas higher values limit the total data used.',...
    newline, 'The default of 40deg/s should be sufficient in most cases, but if N is low, try setting this to lower'];
TooltipString_maxRate=['Input the maximum rate of rotation for for calculating the step response (upper bound must be greater than lower bound).',...
    newline, 'This also marks the lower bound for step resp plots associated with the ''snap maneuvers'' selection.',...
    newline, 'The default of 500deg/s is sufficient in most cases'];
TooltipString_FastStepResp=['Plots the step response associated with snap maneuvers, whose lower cutoff is defined by upper deg/s dropdown.',...
    newline, 'Note: this requires that the log contains maneuvers > the selected upper deg/s, else the plot is left blank']; 
TooltipString_fileListWindowStep=['List of files available. Click to select which files to run']; 
TooltipString_clearPlot=['Clears lines from all subplots']; 

fcntSR = 0;

clear posInfo.TparamsPos
cols=[0.05 0.45 0.57 0.69];
rows=[0.69 0.395 0.1];
k=0;
for c=1 : size(cols,2)
    for r=1 : size(rows,2)
        k=k+1;
        if c == 1
            posInfo.TparamsPos(k,:)=[cols(c) rows(r) 0.37 0.245];
        else
            posInfo.TparamsPos(k,:)=[cols(c) rows(r) 0.09 0.245];
        end
    end
end

posInfo.linewidth4=[.9 .94 .07 .026];
posInfo.fileListWindowStep=[.898 .66 .088 .24];
posInfo.run4=[.896 .63 .0455 .026];
posInfo.clearPlots=[.942 .63 .0455 .026];
posInfo.saveFig4=[.896 .605 .092 .026];
posInfo.chooseaxis=[.895 .565 .095 .04];
posInfo.smooth_tuning=[.895 .542 .095 .04];
posInfo.maxYStepTxt = [.92 .531 .06 .025];
posInfo.maxYStepInput = [.91 .531 .025 .025];
posInfo.Ycorrection=[.91 .505 .065 .025];
 
guiHandlesTune.tuneCrtlpanel = uipanel('Title','select files (max 10)','FontSize',fontsz,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.89 .5 .105 .42]);
       
guiHandlesTune.run4 = uicontrol(PTtunefig,'string','Run','fontsize',fontsz,'TooltipString',[TooltipString_steprun],'units','normalized','outerposition',[posInfo.run4],...
    'callback','PTtuningParams;'); 
guiHandlesTune.run4.ForegroundColor=[colRun];

guiHandlesTune.fileListWindowStep = uicontrol(PTtunefig,'Style','listbox','string',[fnameMaster],'max',10,'min',1,...
    'fontsize',fontsz,'TooltipString', [TooltipString_fileListWindowStep],'units','normalized','outerposition', [posInfo.fileListWindowStep],'callback','@selection2;');
guiHandlesTune.fileListWindowStep.Value=1;

guiHandlesTune.saveFig4 = uicontrol(PTtunefig,'string','Save Fig','fontsize',fontsz,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig4],...
    'callback','guiHandlesTune.saveFig4.FontWeight=''bold'';PTsaveFig; guiHandlesTune.saveFig4.FontWeight=''normal'';'); 
guiHandlesTune.saveFig4.ForegroundColor=[ saveCol];

guiHandlesTune.chooseaxis = uicontrol(PTtunefig,'Style','popupmenu','string',{'RPY','RP','R','P','Y'}, 'fontsize',fontsz,'units','normalized','outerposition', [posInfo.chooseaxis]);
guiHandlesTune.chooseaxis.Value = 2;

guiHandlesTune.clearPlots = uicontrol(PTtunefig,'string','Reset','fontsize',fontsz,'TooltipString',[TooltipString_clearPlot],'units','normalized','outerposition',[posInfo.clearPlots],...
    'callback','guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow'');'); 
guiHandlesTune.clearPlots.ForegroundColor=[cautionCol];

guiHandlesTune.Ycorrection =uicontrol(PTtunefig,'Style','checkbox','String','Y correction','fontsize',fontsz,'TooltipString', ['Y axis offset correction '],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Ycorrection],'callback', 'guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow''); PTtuningParams;');
guiHandlesTune.Ycorrection.Value = 0;

guiHandlesTune.maxYStepTxt = uicontrol(PTtunefig,'style','text','string','Y max ','fontsize',fontsz,'TooltipString', ['Y scale max'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxYStepTxt]);
guiHandlesTune.maxYStepInput = uicontrol(PTtunefig,'style','edit','string','1.75','fontsize',fontsz,'TooltipString', ['Y scale max'],'units','normalized','outerposition',[posInfo.maxYStepInput],...
     'callback','@textinput_call3; guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0;PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal'' ;PTtuningParams;  ');

guiHandlesTune.smoothFactor_select = uicontrol(PTtunefig,'style','popupmenu','string',{'smoothing off' 'smoothing low' 'smoothing medium' 'smoothing high'},'fontsize',fontsz,'TooltipString', ['Smooth the gyro when step response traces are too noisy'], 'units','normalized','outerposition',[posInfo.smooth_tuning],...
     'callback','@selection2;');
guiHandlesTune.smoothFactor_select.Value=1;

else
    warndlg('Please select file(s)');
end

% functions
function textinput_call3(src,eventdata)
str=get(src,'String');
    if isempty(str2num(str))
        set(src,'string','0');
        warndlg('Input must be numerical');  
    end
end

% functions
function selection2(src,event)
    val = c.Value;
    str = c.String;
    str{val};
   % disp(['Selection: ' str{val}]);
end