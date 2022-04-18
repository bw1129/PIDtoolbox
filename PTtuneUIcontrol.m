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
cols=[0.05 0.45 0.58 0.73];
rows=[0.69 0.395 0.1];
k=0;
for c=1 : size(cols,2)
    for r=1 : size(rows,2)
        k=k+1;
        if c == 1
            posInfo.TparamsPos(k,:)=[cols(c) rows(r) 0.4 0.245];
        else
            posInfo.TparamsPos(k,:)=[cols(c) rows(r) 0.11 0.245];
        end
    end
end

posInfo.linewidth4=[.9 .94 .07 .026];
posInfo.fileListWindowStep=[.898 .66 .088 .24];
posInfo.run4=[.896 .63 .0455 .026];
posInfo.clearPlots=[.942 .63 .0455 .026];
posInfo.saveFig4=[.896 .605 .0455 .026];
posInfo.saveSettings4=[.942 .605 .0455 .026];
posInfo.smooth_tuning=[.895 .565 .095 .04];
posInfo.plotR=[.91 .555 .03 .025];
posInfo.plotP=[.935 .555 .03 .025];
posInfo.plotY=[.96 .555 .03 .025];
posInfo.RPYcombo=[.91 .53 .065 .025];
posInfo.Ycorrection=[.91 .505 .065 .025];
posInfo.maxYStepTxt = [.92 .48 .06 .025];
posInfo.maxYStepInput = [.91 .48 .025 .025];


 
guiHandlesTune.tuneCrtlpanel = uipanel('Title','select files (max 10)','FontSize',fontsz,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.89 .47 .105 .45]);
       
guiHandlesTune.run4 = uicontrol(PTtunefig,'string','Run','fontsize',fontsz,'TooltipString',[TooltipString_steprun],'units','normalized','outerposition',[posInfo.run4],...
    'callback','PTtuningParams;'); 
guiHandlesTune.run4.ForegroundColor=[colRun];

guiHandlesTune.fileListWindowStep = uicontrol(PTtunefig,'Style','listbox','string',[fnameMaster],'max',10,'min',1,...
    'fontsize',fontsz,'TooltipString', [TooltipString_fileListWindowStep],'units','normalized','outerposition', [posInfo.fileListWindowStep],'callback','@selection2;');
guiHandlesTune.fileListWindowStep.Value=1;

guiHandlesTune.saveFig4 = uicontrol(PTtunefig,'string','Save Fig','fontsize',fontsz,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig4],...
    'callback','guiHandlesTune.saveFig4.FontWeight=''bold'';PTsaveFig; guiHandlesTune.saveFig4.FontWeight=''normal'';'); 
guiHandlesTune.saveFig4.ForegroundColor=[ saveCol];

guiHandlesTune.saveSettings = uicontrol(PTtunefig,'string','Save Settings','fontsize',fontsz, 'TooltipString',['Save current settings to PTB defaults' ], 'units','normalized','outerposition',[posInfo.saveSettings4],...
    'callback','guiHandlesTune.saveSettings.FontWeight=''bold'';PTsaveSettings; guiHandlesTune.saveSettings.FontWeight=''normal'';'); 
guiHandlesTune.saveSettings.ForegroundColor=[saveCol];

guiHandlesTune.plotR =uicontrol(PTtunefig,'Style','checkbox','String','R','fontsize',fontsz,'TooltipString', ['Plot Roll '],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.plotR],'callback', 'guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow'');');

guiHandlesTune.plotP =uicontrol(PTtunefig,'Style','checkbox','String','P','fontsize',fontsz,'TooltipString', ['Plot Pitch '],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.plotP],'callback', 'guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow'');');
guiHandlesTune.plotP.Value = 1;

guiHandlesTune.plotY =uicontrol(PTtunefig,'Style','checkbox','String','Y','fontsize',fontsz,'TooltipString', ['Plot Yaw '],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.plotY],'callback', 'guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow'');');
guiHandlesTune.plotY.Value = 0;

guiHandlesTune.clearPlots = uicontrol(PTtunefig,'string','Reset','fontsize',fontsz,'TooltipString',[TooltipString_clearPlot],'units','normalized','outerposition',[posInfo.clearPlots],...
    'callback','guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow'');'); 
guiHandlesTune.clearPlots.ForegroundColor=[cautionCol];

guiHandlesTune.Ycorrection =uicontrol(PTtunefig,'Style','checkbox','String','Y correction','fontsize',fontsz,'TooltipString', ['Y axis offset correction '],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Ycorrection],'callback', 'guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow''); PTtuningParams;');
guiHandlesTune.Ycorrection.Value = 0;

guiHandlesTune.RPYcombo =uicontrol(PTtunefig,'Style','checkbox','String','Single Panel','fontsize',fontsz,'TooltipString', ['Plot RPY in same panel '],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.RPYcombo],'callback', 'guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal''; set(PTtunefig, ''pointer'', ''arrow''); PTtuningParams;');
guiHandlesTune.RPYcombo.Value = 0;

guiHandlesTune.maxYStepTxt = uicontrol(PTtunefig,'style','text','string','Y max ','fontsize',fontsz,'TooltipString', ['Y scale max'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxYStepTxt]);
guiHandlesTune.maxYStepInput = uicontrol(PTtunefig,'style','edit','string','1.75','fontsize',fontsz,'TooltipString', ['Y scale max'],'units','normalized','outerposition',[posInfo.maxYStepInput],...
     'callback','@textinput_call3; guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcntSR = 0;PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal'' ;PTtuningParams;  ');
 
guiHandlesTune.smoothFactor_select = uicontrol(PTtunefig,'style','popupmenu','string',{'smoothing off' 'smoothing low' 'smoothing medium' 'smoothing high'},'fontsize',fontsz,'TooltipString', ['Smooth the gyro when step response traces are too noisy'], 'units','normalized','outerposition',[posInfo.smooth_tuning],...
     'callback','@selection2;');
guiHandlesTune.smoothFactor_select.Value=1;

try guiHandlesTune.plotR.Value = defaults.Values(find(strcmp(defaults.Parameters, 'StepResp-plotR'))), catch, guiHandlesTune.plotR.Value = 1, end
try guiHandlesTune.plotP.Value = defaults.Values(find(strcmp(defaults.Parameters, 'StepResp-plotP'))), catch, guiHandlesTune.plotP.Value = 1, end
try guiHandlesTune.plotY.Value = defaults.Values(find(strcmp(defaults.Parameters, 'StepResp-plotY'))), catch, guiHandlesTune.plotY.Value = 1, end
try guiHandlesTune.RPYcombo.Value = defaults.Values(find(strcmp(defaults.Parameters, 'StepResp-SinglePanel'))), catch, guiHandlesTune.RPYcombo.Value = 0, end
try guiHandlesTune.maxYStepInput.String = num2str(defaults.Values(find(strcmp(defaults.Parameters, 'StepResp-Ymax')))), catch, end

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

