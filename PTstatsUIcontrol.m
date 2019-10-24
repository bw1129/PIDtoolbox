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

TooltipString_degsecStick=['Plots rate curve (Histograms Figs) in terms of degs per sec per stick-travel units, or how fast one''s rates change across stick travel '];
TooltipString_crossAxesStats=['Selects from several plotting options, from basic histograms of stick use per flight, to means',...
    newline 'and various between-axes representations.',... 
    newline ' ',...
    newline 'Histograms:',...
    newline 'Basic descriptive stats of the flight behavior.',...
    newline ' ',...
    newline 'Mean +/-SD:',...
    newline 'Bars represent the mean/average and lines represent the standard deviation (a measure of variability), ||=absolute value or unsigned average.',...
    newline 'Note: you can select out portions of the data to be examined if desired, by adjusting the selection window in the log viewer.',...
    newline ' ',...
    newline 'Topographic Mode1/2 plots:',...
    newline 'The plots show the topographic view (like looking down at your radio) of how the sticks were moved during the flight',...
    newline 'Line color represents throttle acceleration in red and deceleration in blue, with higher values more saturated.',...
    newline 'If throttle is neither accelerating nor decelerating the line color is white.',...
    newline 'Note: you can select out portions of the data to be examined if desired, by adjusting the selection window in the log viewer, and refreshing the Flight stats tool.',...
    newline ' ',...
    newline 'Axes x Throttle plots:',...
    newline 'Like the mode plots, line color represents throttle acceleration in red and deceleration in blue, with higher values more saturated.',...
    newline 'If throttle is neither accelerating nor decelerating the line color is white.',...
    newline 'The ''Mode and axes X throttle topography plots'' are useful for examining patterns in flight behavior,',...
    newline 'For example, flight behaviour associated with optimal lap times in a race, or the qualities or asymmetries in one''s flying style ',...
    newline 'Note: you can select out portions of the data to be examined if desired, by adjusting the selection window in the log viewer.'];
TooltipString_statScale=['For ''Mode and axes X throttle topography plots'':',...
    newline 'Scale: Z-axis (line color) scale, from 1 to infinity, with higher numbers yielding a wider scale,',...
    newline 'giving greater distinction between lines, where only the fastest movements (highest acceleration/deceleration) become visible.'];
TooltipString_statAlpha=['For ''Mode and axes X throttle topography plots'':',...
    newline 'Alpha: line transparency, from 0 (fully transparent) to 1 (not transparent)'];
updateStats=0;

zScale=1;
zTransparency=1;

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
posInfo.crossAxesStats=[.29 .945 .08 .04];

posInfo.crossAxesStats_text = [.385 .965 .03 .03];
posInfo.crossAxesStats_input = [.385 .945 .03 .03];
posInfo.crossAxesStats_text2 = [.42 .965 .03 .03]; 
posInfo.crossAxesStats_input2 = [.42 .945 .03 .03];

statsCrtlpanel = uipanel('Title','','FontSize',fontsz5,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.06 .935 .40 .06]);

guiHandlesStats.saveFig5 = uicontrol(PTstatsfig,'string','Save Fig','fontsize',fontsz5,'TooltipString',[TooltipString_saveFig],'units','normalized','outerposition',[posInfo.saveFig5],...
    'callback','guiHandlesStats.saveFig5.FontWeight=''bold'';PTsaveFig; guiHandlesStats.saveFig5.FontWeight=''normal'';'); 
guiHandlesStats.saveFig5.BackgroundColor=[ .8 .8 .8];

guiHandlesStats.refresh = uicontrol(PTstatsfig,'string','Refresh','fontsize',fontsz5,'TooltipString',[TooltipString_refresh],'units','normalized','outerposition',[posInfo.refresh3],...
    'callback','updateStats=1;PTplotStats;');
guiHandlesStats.refresh.BackgroundColor=[1 1 .2];

guiHandlesStats.degsecStick =uicontrol(PTstatsfig,'Style','checkbox','String','rate of change','fontsize',fontsz5,'TooltipString',[TooltipString_degsecStick],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.degsecStick],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end; PTplotStats;');
guiHandlesStats.crossAxesStats =uicontrol(PTstatsfig,'Style','popupmenu','String',{'Histograms'; 'Mean & Standard Deviation'; 'Mode 1 topography'; 'Mode 2 topography'; 'Axes X Throttle'},'fontsize',fontsz5,'TooltipString',[TooltipString_crossAxesStats],...
    'units','normalized','BackgroundColor',[1 1 1 ],'outerposition',[posInfo.crossAxesStats],'callback','@selection; if (~isempty(filenameA) | ~isempty(filenameB)), end; PTplotStats;');
%guiHandlesStats.crossAxesStats.Value=0;

guiHandlesStats.crossAxesStats_text = uicontrol(PTstatsfig,'style','text','string','scale','fontsize',fontsz5,'TooltipString',[TooltipString_statScale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.crossAxesStats_text]);
guiHandlesStats.crossAxesStats_input = uicontrol(PTstatsfig,'style','edit','string',[num2str(zScale)],'fontsize',fontsz5,'TooltipString',[TooltipString_statScale],'units','normalized','outerposition',[posInfo.crossAxesStats_input],...
     'callback','@textinput_call4; zScale=str2num(guiHandlesStats.crossAxesStats_input.String);updateStats=1;PTplotStats;');
 
guiHandlesStats.crossAxesStats_text2 = uicontrol(PTstatsfig,'style','text','string','alpha','fontsize',fontsz5,'TooltipString',[TooltipString_statAlpha],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.crossAxesStats_text2]);
guiHandlesStats.crossAxesStats_input2 = uicontrol(PTstatsfig,'style','edit','string',[num2str(zTransparency)],'fontsize',fontsz5,'TooltipString',[TooltipString_statAlpha],'units','normalized','outerposition',[posInfo.crossAxesStats_input2],...
     'callback','@textinput_call4; zTransparency=str2num(guiHandlesStats.crossAxesStats_input2.String); if (zTransparency>1), zTransparency=1; end; if (zTransparency<0), zTransparency=0; end; updateStats=1;PTplotStats;');

else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end


function textinput_call4(src,eventdata)
str=get(src,'String');
    if isempty(str2num(str))
        set(src,'string','0');
        warndlg('Input must be numerical');  
    end
end

function selection(src,event)
    val = c.Value;
    str = c.String;
    str{val};
   % disp(['Selection: ' str{val}]);
end