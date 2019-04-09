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
PTtunefig.Name= 'PIDtoolbox Step Response';
PTtunefig.InvertHardcopy='off';
set(PTtunefig,'color',bgcolor)

prop_max_screen=(max([PTtunefig.Position(3) PTtunefig.Position(4)]));
fontsz4=round(screensz_multiplier*prop_max_screen);

updateStep=0;

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
posInfo.checkboxrateHigh=[.30 .94 .08 .04];


tuneCrtlpanel = uipanel('Title','','FontSize',fontsz4,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.085 .93 .31 .06]);
          
guiHandlesTune.run4 = uicontrol(PTtunefig,'string','run','fontsize',fontsz4,'units','normalized','outerposition',[posInfo.run4],...
    'callback','PTtuningParams;');
guiHandlesTune.run4.BackgroundColor=[.3 .9 .3];

guiHandlesTune.saveFig4 = uicontrol(PTtunefig,'string','save fig','fontsize',fontsz4,'units','normalized','outerposition',[posInfo.saveFig4],...
    'callback','guiHandlesTune.saveFig4.FontWeight=''bold'';PTsaveFig; guiHandlesTune.saveFig4.FontWeight=''normal'';'); 
guiHandlesTune.saveFig4.BackgroundColor=[ .8 .8 .8];

guiHandlesTune.subsampFactor = uicontrol(PTtunefig,'Style','popupmenu','string',{'subsampling low'; 'subsampling med-low'; 'subsampling medium'; 'subsampling med-high';  'subsampling high';},...
    'fontsize',fontsz4,'units','normalized','outerposition', [posInfo.subsampFactor],'callback','@selection2;');
guiHandlesTune.subsampFactor.Value=3;

guiHandlesTune.checkboxrateHigh =uicontrol(PTtunefig,'Style','checkbox','String','>500deg/s','fontsize',fontsz4,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkboxrateHigh],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end; updateStep=1;PTtuningParams;');


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