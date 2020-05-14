%% PTtuneUIcontrol - ui controls for tuning-specific parameters

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(filenameA) || ~isempty(filenameB)
    
PTtunefig=figure(4);
set(PTtunefig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTtunefig.NumberTitle='off';
PTtunefig.Name= ['PIDtoolbox (' PtbVersion ') - Step Response Tool'];
PTtunefig.InvertHardcopy='off';
set(PTtunefig,'color',bgcolor)

prop_max_screen=(max([PTtunefig.Position(3) PTtunefig.Position(4)]));
fontsz4=round(screensz_multiplier*prop_max_screen);

updateStep=0;

TooltipString_steprun=['Runs step response analysis.',...
    newline, 'Warning: Set subsampling dropdown @ or < medium for faster processing.'];
TooltipString_minRate=['Input the minimum rate of rotation for calculating the step response (lower bound must be > 0 but lower than upper bound).',...
    newline, 'Really low values may yield more noisy contributions to the data, whereas higher values limit the total data used.',...
    newline, 'The default of 40deg/s should be sufficient in most cases, but if N is low, try setting this to lower'];
TooltipString_maxRate=['Input the maximum rate of rotation for for calculating the step response (upper bound must be greater than lower bound).',...
    newline, 'This also marks the lower bound for step resp plots associated with the ''> upper (deg/s)'' selection.',...
    newline, 'The default of 500deg/s is sufficient in most cases'];
TooltipString_FastStepResp=['Plots the step response associated with snap maneuvers (> upper (deg/s) setting), whose lower cutoff is defined by upper (deg/s) dropdown.',...
    newline, 'Note: this requires that the log contains maneuvers > the selected upper (deg/s), else the plot is left blank']; 
TooltipString_subsample=['Choose degree of subsampling. If N is small and the step resp looks very noisy, it is useful to select med-high to high subsampling.',...
    newline  'Warning, selecting higher subsampling will typically result in slower processing']; 

TooltipString_minRatetxt=['Lower bound in degs/s'];
TooltipString_maxRatetxt=['Upper bound in degs/s'];

clear posInfo.TparamsPos
cols=[0.1 0.55];
rows=[0.66 0.38 0.1];
k=0;
for c=1:2
    for r=1:3
        k=k+1;
        posInfo.TparamsPos(k,:)=[cols(c) rows(r) 0.39 0.24];
    end
end

posInfo.run4=[.09 .94 .06 .04];
posInfo.saveFig4=[.16 .94 .06 .04];
posInfo.subsampFactor=[.23 .94 .06 .04];
posInfo.minDegMovetxt=[.29 .965 .08 .03];
posInfo.minDegMove=[.30 .94 .06 .03];
posInfo.maxDegMovetxt=[.36 .965 .08 .03];
posInfo.maxDegMove=[.37 .94 .06 .03];
posInfo.checkboxrateHigh=[.44 .94 .09 .04];

 
tuneCrtlpanel = uipanel('Title','','FontSize',fontsz4,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.085 .93 .45 .06]);
          
guiHandlesTune.run4 = uicontrol(PTtunefig,'string','Run','fontsize',fontsz4,'TooltipString',[TooltipString_steprun],'units','normalized','outerposition',[posInfo.run4],...
    'callback','PTtuningParams;'); 
guiHandlesTune.run4.BackgroundColor=[.3 .9 .3];

guiHandlesTune.saveFig4 = uicontrol(PTtunefig,'string','Save Fig','fontsize',fontsz4,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig4],...
    'callback','guiHandlesTune.saveFig4.FontWeight=''bold'';PTsaveFig; guiHandlesTune.saveFig4.FontWeight=''normal'';'); 
guiHandlesTune.saveFig4.BackgroundColor=[ .8 .8 .8];

guiHandlesTune.subsampFactor = uicontrol(PTtunefig,'Style','popupmenu','string',{'subsampling low (fastest | less reliable)'; 'subsampling med-low'; 'subsampling medium'; 'subsampling med-high';  'subsampling high (slowest | most reliable)';},...
    'fontsize',fontsz4,'TooltipString', [TooltipString_subsample],'units','normalized','outerposition', [posInfo.subsampFactor],'callback','@selection2;');
guiHandlesTune.subsampFactor.Value=3;

guiHandlesTune.checkboxrateHigh =uicontrol(PTtunefig,'Style','checkbox','String','> upper (deg/s)','fontsize',fontsz4,'TooltipString', [TooltipString_FastStepResp],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkboxrateHigh],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end; updateStep=1;PTtuningParams;');

guiHandlesTune.minDegMove_text = uicontrol(PTtunefig,'style','text','string','lower (deg/s)','fontsize',fontsz4,'TooltipString', [TooltipString_minRatetxt],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.minDegMovetxt]);
guiHandlesTune.minDegMove = uicontrol(PTtunefig,'style','edit','string',int2str(minDegMove),'fontsize',fontsz4,'TooltipString', [TooltipString_minRate],'units','normalized','outerposition',[posInfo.minDegMove],...
     'callback','@textinput_call3;minDegMove=str2num(guiHandlesTune.minDegMove.String); if (minDegMove<1), minDegMove=1; PTtuneUIcontrol; end');

guiHandlesTune.maxDegMove_text = uicontrol(PTtunefig,'style','text','string','upper (deg/s)','fontsize',fontsz4,'TooltipString', [TooltipString_maxRatetxt],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxDegMovetxt]);
guiHandlesTune.maxDegMove = uicontrol(PTtunefig,'style','edit','string',int2str(maxDegMove),'fontsize',fontsz4,'TooltipString', [TooltipString_maxRate],'units','normalized','outerposition',[posInfo.maxDegMove],...
     'callback','@textinput_call3;maxDegMove=str2num(guiHandlesTune.maxDegMove.String); if (maxDegMove<minDegMove), maxDegMove=minDegMove+1; PTtuneUIcontrol; end');
 
else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
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