%% PTplotStats - UI control for flight statistics

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(filenameA) || ~isempty(filenameB)

PTstatsfig=figure(6);
set(PTstatsfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTstatsfig.NumberTitle='off';
PTstatsfig.Name= ['PIDtoolbox (' PtbVersion ') - Flight stats'];
PTstatsfig.InvertHardcopy='off';
set(PTstatsfig,'color',bgcolor)

prop_max_screen=(max([PTstatsfig.Position(3) PTstatsfig.Position(4)]));
fontsz5=round(screensz_multiplier*prop_max_screen);

clear posInfo.statsPos
cols=[0.06 0.54];
rows=[0.75 0.52 0.29 0.06];
k=0;
for c=1:2
    for r=1:4
        k=k+1;
        posInfo.statsPos(k,:)=[cols(c) rows(r) 0.39 0.18];
    end
end

posInfo.saveFig5=[.065 .945 .06 .04];
posInfo.refresh3=[.135 .945 .06 .04];
posInfo.degsecStick=[.20 .945 .09 .04];


statsCrtlpanel = uipanel('Title','','FontSize',fontsz5,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.06 .935 .24 .06]);

guiHandlesStats.saveFig5 = uicontrol(PTstatsfig,'string','Save Fig','fontsize',fontsz5,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig5],...
    'callback','guiHandlesStats.saveFig5.FontWeight=''bold'';PTsaveFig; guiHandlesStats.saveFig5.FontWeight=''normal'';'); 
guiHandlesStats.saveFig5.BackgroundColor=[ .8 .8 .8];

guiHandlesStats.refresh = uicontrol(PTstatsfig,'string','Refresh','fontsize',fontsz5,'TooltipString',[TooltipString_refresh],'units','normalized','outerposition',[posInfo.refresh3],...
    'callback','updateErr=1;PTplotStats;');
guiHandlesStats.refresh.BackgroundColor=[1 1 .2];

guiHandlesStats.degsecStick =uicontrol(PTstatsfig,'Style','checkbox','String','rate of change','fontsize',fontsz5,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.degsecStick],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end; PTplotStats;');

        
else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end
