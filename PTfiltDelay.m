%% PTfiltDelay - update filt delay calcs

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

guiHandlesSpec.AphasedelayText1 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{1}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{1}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText1]);
guiHandlesSpec.AphasedelayText2 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{2}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{2}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText2]);
guiHandlesSpec.AphasedelayText3 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{3}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{3}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText3]);
guiHandlesSpec.AphasedelayText4 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{4}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{4}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText4]);
