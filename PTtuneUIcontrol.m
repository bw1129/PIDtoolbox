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

fcnt = 0;

clear posInfo.TparamsPos
cols=[0.05 0.55];
rows=[0.69 0.395 0.1];
k=0;
for c=1:2
    for r=1:3
        k=k+1;
        posInfo.TparamsPos(k,:)=[cols(c) rows(r) 0.48 0.26];
    end
end

verticalOffset = 0.03;
posInfo.fileListWindowStep=[.898 .64+verticalOffset .088 .22];
posInfo.run4=[.9 .60+verticalOffset .041 .04];
posInfo.clearPlots=[.944 .60+verticalOffset .041 .04];
posInfo.saveFig4=[.9 .555+verticalOffset .085 .04];
posInfo.linewidth4=[.9 .94 .07 .026];
 
tuneCrtlpanel = uipanel('Title','select files (max 10)','FontSize',fontsz,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.89 .515+verticalOffset .105 .37]);
        
% guiHandlesTune.linewidth4 = uicontrol(PTtunefig,'Style','popupmenu','string',{'line width 1','line width 2','line width 3','line width 4','line width 5'},...
% 'fontsize',fontsz,'units','normalized','outerposition', [posInfo.linewidth4],'callback','@selection; PTtuningParams;');
% guiHandlesTune.linewidth4.Value = 3;

guiHandlesTune.run4 = uicontrol(PTtunefig,'string','Run','fontsize',fontsz,'TooltipString',[TooltipString_steprun],'units','normalized','outerposition',[posInfo.run4],...
    'callback','PTtuningParams;'); 
guiHandlesTune.run4.BackgroundColor=[colRun];

guiHandlesTune.fileListWindowStep = uicontrol(PTtunefig,'Style','listbox','string',[fnameMaster],'max',10,'min',1,...
    'fontsize',fontsz,'TooltipString', [TooltipString_fileListWindowStep],'units','normalized','outerposition', [posInfo.fileListWindowStep],'callback','@selection2;');
guiHandlesTune.fileListWindowStep.Value=1;

guiHandlesTune.saveFig4 = uicontrol(PTtunefig,'string','Save Fig','fontsize',fontsz,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig4],...
    'callback','guiHandlesTune.saveFig4.FontWeight=''bold'';PTsaveFig; guiHandlesTune.saveFig4.FontWeight=''normal'';'); 
guiHandlesTune.saveFig4.BackgroundColor=[ saveCol];

guiHandlesTune.clearPlots = uicontrol(PTtunefig,'string','Reset','fontsize',fontsz,'TooltipString',[TooltipString_clearPlot],'units','normalized','outerposition',[posInfo.clearPlots],...
    'callback','guiHandlesTune.clearPlots.Value=1; guiHandlesTune.clearPlots.FontWeight=''bold''; fcnt = 0; PTtuningParams; guiHandlesTune.clearPlots.Value=0; guiHandlesTune.clearPlots.FontWeight=''normal'';'); 
guiHandlesTune.clearPlots.BackgroundColor=[cautionCol];

posInfo.maxYStepTxt = [.895 .55 .06 .025];
posInfo.maxYStepInput = [.94 .551 .025 .025];
guiHandles.maxYStepTxt = uicontrol(PTtunefig,'style','text','string','Y max ','fontsize',fontsz,'TooltipString', ['Y scale max'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxYStepTxt]);
guiHandles.maxYStepInput = uicontrol(PTtunefig,'style','edit','string','1.75','fontsize',fontsz,'TooltipString', ['Y scale max'],'units','normalized','outerposition',[posInfo.maxYStepInput],...
     'callback','@textinput_call3; ');


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