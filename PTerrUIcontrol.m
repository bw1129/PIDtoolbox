%% PTerrUIcontrol - ui controls for PID error analyses

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) || ~isempty(filenameB)
      
PTerrfig=figure(3);
set(PTerrfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTerrfig.NumberTitle='off';
PTerrfig.Name= ['PIDtoolbox (' PtbVersion ') - PID Error Tool'];
PTerrfig.InvertHardcopy='off';
set(PTerrfig,'color',bgcolor)

prop_max_screen=(max([PTerrfig.Position(3) PTerrfig.Position(4)]));
fontsz3=round(screensz_multiplier*prop_max_screen);
maxDegsec=100;
updateErr=0;

TooltipString_degsec=['Sets the maximum rate used in the PID error analysis (distribution plots only).',...
    newline , 'E.g., the default means only data in which set point was <= 100deg/s is used.',...
    newline , 'This cutoff helps to reduce inclusion of data with inflated PID error as a result of snap maneuvers' ];

clear posInfo.PIDerrAnalysis
cols=[0.1 0.55];
rows=[0.66 0.38 0.1];
k=0;
for c=1:2
    for r=1:3
        k=k+1;
        posInfo.PIDerrAnalysis(k,:)=[cols(c) rows(r) 0.39 0.24];
    end
end

posInfo.refresh2=[.09 .94 .06 .04];
posInfo.saveFig3=[.16 .94 .06 .04];

posInfo.maxSticktext=[.22 .966 .12 .03];
posInfo.maxStick=[.24 .94 .06 .03];

errCrtlpanel = uipanel('Title','','FontSize',fontsz3,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.085 .93 .23 .06]);
          
guiHandlesPIDerr.refresh = uicontrol(PTerrfig,'string','Refresh','fontsize',fontsz3,'TooltipString',[TooltipString_refresh],'units','normalized','outerposition',[posInfo.refresh2],...
    'callback','updateErr=1;PTplotPIDerror;');
guiHandlesPIDerr.refresh.BackgroundColor=[1 1 .2];

guiHandlesPIDerr.maxSticktext = uicontrol(PTerrfig,'style','text','string','max stick deg/s','fontsize',fontsz3,'TooltipString',[TooltipString_degsec],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.maxSticktext]);
guiHandlesPIDerr.maxStick = uicontrol(PTerrfig,'style','edit','string',[int2str(maxDegsec)],'fontsize',fontsz3,'TooltipString',[TooltipString_degsec],'units','normalized','outerposition',[posInfo.maxStick],...
     'callback','@textinput_call; maxDegsec=str2num(guiHandlesPIDerr.maxStick.String); updateErr=1;PTplotPIDerror; ');

guiHandlesPIDerr.saveFig3 = uicontrol(PTerrfig,'string','Save Fig','fontsize',fontsz3,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig3],...
    'callback','guiHandlesPIDerr.saveFig3.FontWeight=''bold'';PTsaveFig; guiHandlesPIDerr.saveFig3.FontWeight=''normal'';'); 
guiHandlesPIDerr.saveFig3.BackgroundColor=[ .8 .8 .8];
   
else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end
