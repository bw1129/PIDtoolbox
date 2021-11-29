%% PTtimeFreqUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(fnameMaster)
   
%%% tooltips
TooltipString_specRun=['Run current spectral configuration'];
TooltipString_cmap=['Choose from a selection of colormaps'];
TooltipString_smooth=['Choose amount of smoothing along the freq axis'];
TooltipString_subsampling=['Choose amount of smoothing along the time axis'];
TooltipString_user=['Choose the variable you wish to plot'];
TooltipString_sub100=['Zoom data to show sub 100Hz details',...
    newline, 'Typically used to see propwash or mid-throttle vibration in e.g. Gyro/Pterm/PIDerror'];


%%%
clear posInfo.Spec3Pos
cols=[0.09 ];
rows=[0.69 0.395 0.1];
k=0;
for c=1 : size(cols,2)
    for r=1 : size(rows,2)
        k=k+1; 
        posInfo.Spec3Pos(k,:)=[cols(c) rows(r) 0.77 0.25];
    end
end

updateSpec = 0;
clear specMat
 
posInfo.fileListWindowSpec=[.895 .86 .0915 .04];
posInfo.TermListWindowSpec=[.895 .83 .0915 .04];

posInfo.computeSpec3=            [.895 .815 .0455 .026];
posInfo.resetSpec3=              [.942 .815 .0455 .026]; 
posInfo.saveFig2=               [.895 .785 .092 .026]; % .896 .495 .092 .026
posInfo.smooth_select3 =         [.895 .75 .092 .026];
posInfo.subsampling_select3=     [.895 .72 .092 .026];
posInfo.ColormapSelect2 =        [.895 .69 .092 .026];

posInfo.clim3Max1_text = [.91 .66 .035 .024];
posInfo.clim3Max1_input = [.915 .64 .025 .024];
posInfo.clim3Max2_text = [.94 .66 .035 .024];
posInfo.clim3Max2_input = [.945 .64 .025 .024];
ClimScale3 = [-30 10]; 

posInfo.sub100HzfreqTime  = [.915 .615 .06 .024];

PTspecfig3=figure(31);
set(PTspecfig3, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTspecfig3.NumberTitle='off';
PTspecfig3.Name= ['PIDtoolbox (' PtbVersion ') - Frequency x Time Spectrogram'];
PTspecfig3.InvertHardcopy='off';
set(PTspecfig3,'color',bgcolor);


dcm_obj2 = datacursormode(PTspecfig3);
set(dcm_obj2,'UpdateFcn',@PTdatatip);

Spec3Crtlpanel = uipanel('Title','select file ','FontSize',fontsz,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.89 .61 .105 .31]);
 
guiHandlesSpec3.computeSpec = uicontrol(PTspecfig3,'string','Run','fontsize',fontsz,'TooltipString', [TooltipString_specRun],'units','normalized','outerposition',[posInfo.computeSpec3],...
    'callback','updateSpec = 0; clear specMat; PTfreqTime;');
guiHandlesSpec3.computeSpec.ForegroundColor=[colRun];

guiHandlesSpec3.resetSpec = uicontrol(PTspecfig3,'string','Reset','fontsize',fontsz,'TooltipString', ['Reset Spectral Tool'],'units','normalized','outerposition',[posInfo.resetSpec3],...
    'callback','updateSpec = 0; clear specMat; for k = 1 : 3, delete(subplot(''position'',posInfo.Spec3Pos(k,:))), end; set(PTspecfig3, ''pointer'', ''arrow'');');
guiHandlesSpec3.resetSpec.ForegroundColor=[cautionCol];

guiHandlesSpec3.saveFig2 = uicontrol(PTspecfig3,'string','Save Fig','fontsize',fontsz,'TooltipString',[TooltipString_saveFig],'units','normalized','ForegroundColor',[saveCol],'outerposition',[posInfo.saveFig2],...
    'callback','guiHandlesSpec3.saveFig2.FontWeight=''bold'';PTsaveFig;guiHandlesSpec3.saveFig2.FontWeight=''normal'';'); 

% create string list for SpecSelect
sA={'Gyro','Gyro prefilt','Dterm','Dterm prefilt','Pterm','PID error','Set point','PIDsum'};

guiHandlesSpec3.SpecList = uicontrol(PTspecfig3,'Style','popupmenu','string',[sA], 'fontsize',fontsz, 'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.TermListWindowSpec]);
guiHandlesSpec3.SpecList.Value =1;
 
guiHandlesSpec3.FileSelect = uicontrol(PTspecfig3,'Style','popupmenu','string',[fnameMaster], 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.fileListWindowSpec]);
guiHandlesSpec3.FileSelect.Value = 1;

guiHandlesSpec3.smoothFactor_select = uicontrol(PTspecfig3,'style','popupmenu','string',{'smooth freq axis off' 'smooth freq axis low' 'smooth freq axis med' 'smooth freq axis high'},'fontsize',fontsz,'TooltipString', [TooltipString_smooth], 'units','normalized','outerposition',[posInfo.smooth_select3],...
     'callback','PTfreqTime;');
guiHandlesSpec3.smoothFactor_select.Value=2;

guiHandlesSpec3.subsampleFactor_select = uicontrol(PTspecfig3,'style','popupmenu','string',{'smooth time axis off' 'smooth time axis low' 'smooth time axis med' 'smooth time axis high'},'fontsize',fontsz,'TooltipString', [TooltipString_subsampling], 'units','normalized','outerposition',[posInfo.subsampling_select3],...
     'callback','PTfreqTime;');
guiHandlesSpec3.subsampleFactor_select.Value=2;

 guiHandlesSpec3.ColormapSelect = uicontrol(PTspecfig3,'Style','popupmenu','string',{'parula','jet','hot','cool','gray','bone','copper','viridis','linear-RED','linear-GREY'},...
    'fontsize',fontsz,'TooltipString', [TooltipString_cmap], 'units','normalized','outerposition',[posInfo.ColormapSelect2],'callback','@selection2;updateSpec=1; PTfreqTime;');
guiHandlesSpec3.ColormapSelect.Value=3;% jet 2 hot 3 viridis 8

guiHandlesSpec3.climMax1_text = uicontrol(PTspecfig3,'style','text','string','Z min','fontsize',fontsz,'TooltipString',['adjusts the color limits'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.clim3Max1_text]);
guiHandlesSpec3.climMax1_input = uicontrol(PTspecfig3,'style','edit','string',[num2str(ClimScale3(1))],'fontsize',fontsz,'TooltipString',['adjusts the color limits'],'units','normalized','outerposition',[posInfo.clim3Max1_input],...
     'callback','@textinput_call2; ClimScale3(1)=str2num(guiHandlesSpec3.climMax1_input.String);updateSpec=1;PTfreqTime;');

 guiHandlesSpec3.climMax2_text = uicontrol(PTspecfig3,'style','text','string','Z max','fontsize',fontsz,'TooltipString',['adjusts the color limits'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.clim3Max2_text]);
guiHandlesSpec3.climMax2_input = uicontrol(PTspecfig3,'style','edit','string',[num2str(ClimScale3(2))],'fontsize',fontsz,'TooltipString',['adjusts the color limits'],'units','normalized','outerposition',[posInfo.clim3Max2_input],...
     'callback','@textinput_call2; ClimScale3(2)=str2num(guiHandlesSpec3.climMax2_input.String);updateSpec=1;PTfreqTime;');

 guiHandlesSpec3.sub100HzfreqTime = uicontrol(PTspecfig3,'Style','checkbox','String','sub 100Hz','fontsize',fontsz,'ForegroundColor',[.2 .2 .2],'BackgroundColor',bgcolor,...
    'units','normalized','outerposition',[posInfo.sub100HzfreqTime],'callback','@selection2;updateSpec=1; PTfreqTime;');
 
else
     warndlg('Please select file(s)');
end


% functions
function selection2(src,event)
    val = c.Value;
    str = c.String;
    str{val};
end
 
function getList2(hObj,event)
v=get(hObj,'value')
end

function textinput_call2(src,eventdata)
str=get(src,'String');
    if isempty(str2num(str))
        set(src,'string','0');
        warndlg('Input must be numerical');  
    end
end





