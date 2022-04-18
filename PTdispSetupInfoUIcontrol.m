%% PTdispSetupInfo 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

    
if ~isempty(fnameMaster)
    
PTdisp=figure(5);
screensz = get(0,'ScreenSize');
set(PTdisp, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTdisp.NumberTitle='on';
PTdisp.Name= ['PIDtoolbox (' PtbVersion ') -  Setup Info'];
set(PTdisp,'color',bgcolor)

columnWidth=55*round(screensz_multiplier*prop_max_screen);

TooltipString_FileNumDispA=['List of files available. Click to view setup info for each']; 
posInfo.FileNumDispA=[.22 .95 .1 .04];
posInfo.FileNumDispB=[.72 .95 .1 .04];
posInfo.checkboxDIFF=[.04 .96 .1 .04];
  
guiHandlesInfo.FileNumDispA = uicontrol(PTdisp,'Style','popupmenu','string',[fnameMaster],...
    'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.FileNumDispA],'callback','@selection; PTdispSetupInfo;');
guiHandlesInfo.FileNumDispA.Value=1;
if Nfiles > 1
    guiHandlesInfo.FileNumDispB = uicontrol(PTdisp,'Style','popupmenu','string',[fnameMaster],...
        'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.FileNumDispB],'callback','@selection; PTdispSetupInfo;');
    guiHandlesInfo.FileNumDispB.Value=2;
end

guiHandlesInfo.checkboxDIFF =uicontrol(PTdisp,'Style','checkbox','String','Show Differences Only','fontsize',fontsz,'TooltipString', [''],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkboxDIFF],'callback', 'PTdispSetupInfo;');

else
     warndlg('Please select file(s)');
end

% functions
function selection(src,event)
    val = c.Value;
    str = c.String;
    str{val};
   % disp(['Selection: ' str{val}]);
end