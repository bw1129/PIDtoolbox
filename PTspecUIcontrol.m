%% PTspecUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(filenameA) || ~isempty(filenameB)
   
%%% tooltips
TooltipString_specRun=['Run current spectral configuration',...
    newline, 'Warning: Set subsampling dropdown @ or < medium for faster processing.'];
TooltipString_presets=['Choose from a selection of PRESET configurations'];
TooltipString_percentThr=['Plot as a function of % throttle or % motor output'];
TooltipString_cmap=['Choose from a selection of colormaps'];
TooltipString_smooth=['Choose amount of smoothing'];
TooltipString_subsample=['Choose degree of subsampling. Warning: this is designed to deal with small data sets,',...
    newline, 'for example, if you chose a short time window, select higher subsampling, but be aware that higher=slower processing'];
TooltipString_2d=['Show 2 dimensional plots'];
TooltipString_user=['Choose the variable you wish to plot (consider PRESETs dropdown menu above for quick configurations)'];
TooltipString_sub100=['Zoom data to show sub 100Hz details',...
    newline, 'Typically used to see propwash or mid-throttle vibration in e.g. Gyro/Pterm/PIDerror'];
TooltipString_phase=['Estimated phase delay based on cross-correlation technique.',...
    newline, 'Note: estimate is most reliable with sufficient stick input so as to modulate the gyro and dterm.',...
    newline, 'Also requires that betaflight debug_mode is set to ''GYRO_SCALED'' '];
TooltipString_scale=['Colormap scaling. Note, the default is set such that an optimally filtered gyro ',...
    newline, 'should show little to no activity with the exception of a sub 100Hz band across throttle.',...
    newline, 'Dterm and motor outputs will typically be noisier, so sometimes scale adjustments ',...
    newline, 'are useful to see details. Otherwise, scaling should be the same when making comparisons'];
TooltipString_controlFreqCutoff=['Fcut1/Fcut2 = Freq cutoff, used in sub100Hz plots, and sets',...
    newline  'the min and max cutoff (in 3.333hz steps) for computing sub100Hz mean/peak activity.',...
    newline  'Changing this will also move the yellow dashed lines representing this range.'];
TooltipString_RClim=['RClim=RC limit, sets the min RC value (RPY set-point in deg/s)',...
    newline  'used in the FFT calculation. This is useful for observing spectrograms',...
    newline  'under minimal stick influence, which is particularly useful for analyzing',...
    newline, 'differences in propwash or other vibrations that might overlap in ',... 
    newline  'freq range with typical copter control freqencies. I recomend using a value of ~10 or 20.',...
    newline  'NOTE: when using low RClim cutoffs (<50) it is recommended to use higher subsampling',...
    newline  'in order to compensate for the reduction in useable data. See also Flight stats for histograms of RC use.'];


%%%

% define
smat=[];%string
ampmat=[];%spec matrix
amp2d=[];%spec 2d
freq=[];% freq

% only need to call once to compute extra colormaps
PTcolormap;

clear posInfo.SpecPos
cols=[0.06 0.30 0.54 0.78];
rows=[0.59 0.34 0.09];
k=0;
for c=1:4
    for r=1:3
        k=k+1;
        posInfo.SpecPos(k,:)=[cols(c) rows(r) 0.19 0.24];
    end
end
         
posInfo.computeSpec=[.02 .955 .06 .04];
posInfo.saveFig2=[.02 .91 .06 .04];

posInfo.specPresets=[.09 .955 .06 .04];
posInfo.percentMotor=[.16 .955 .06 .04];
posInfo.ColormapSelect=[.23 .955 .06 .04];
posInfo.smooth_select =[.30 .955 .06 .04];
posInfo.subsampleFactor=[.37 .955 .06 .04];
posInfo.controlFreq1Cutoff_text = [.45 .97 .03 .03];
posInfo.controlFreq1Cutoff=[.45 .95 .03 .03];
posInfo.controlFreq2Cutoff_text = [.48 .97 .03 .03];
posInfo.controlFreq2Cutoff=[.48 .95 .03 .03];
posInfo.RClimCutoff_text = [.52 .97 .03 .03];
posInfo.RClimCutoff=[.52 .95 .03 .03];
posInfo.checkbox2d=[.56 .955 .06 .04];


posInfo.AphasedelayText=[.59 .976 .4 .022];
posInfo.BphasedelayText=[.59 .954 .4 .022];

posInfo.hCbar1pos=[0.06 0.845 0.19  0.02];
posInfo.hCbar2pos=[0.3 0.845 0.19  0.02];
posInfo.hCbar3pos=[0.54 0.845 0.19  0.02];
posInfo.hCbar4pos=[0.78 0.845 0.19  0.02];

posInfo.hDropdn1pos=[0.09 0.94 0.100  0.01];
posInfo.hDropdn2pos=[0.33 0.94 0.100  0.01];
posInfo.hDropdn3pos=[0.57 0.94 0.100  0.01];
posInfo.hDropdn4pos=[0.81 0.94 0.100  0.01];
 
posInfo.Sub100HzCheck1=[0.2 0.92 .06 .025];
posInfo.Sub100HzCheck2=[.44 .92 .06 .025];
posInfo.Sub100HzCheck3=[0.68 0.92 .06 .025];
posInfo.Sub100HzCheck4=[.92 .92 .06 .025];

posInfo.climMax_text = [.02 .87 .03 .03];
posInfo.climMax_input = [.02 .845 .03 .03];
posInfo.climMax_text2 = [.26 .87 .03 .03]; 
posInfo.climMax_input2 = [.26 .845 .03 .03];
posInfo.climMax_text3 = [.5 .87 .03 .03]; 
posInfo.climMax_input3 = [.5 .845 .03 .03];
posInfo.climMax_text4 = [.74 .87 .03 .03]; 
posInfo.climMax_input4 = [.74 .845 .03 .03];
climScale=[.5 .5 .5 .5];
Flim1=6; % 3.3333Hz steps
Flim2=30;
RClim=1000;%deg/s

PTspecfig=figure(2);
set(PTspecfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTspecfig.NumberTitle='off';
PTspecfig.Name= ['PIDtoolbox (' PtbVersion ') - Spectral Analyzer'];
PTspecfig.InvertHardcopy='off';
set(PTspecfig,'color',bgcolor);

prop_max_screen=(max([PTspecfig.Position(3) PTspecfig.Position(4)]));
fontsz2=round(screensz_multiplier*prop_max_screen);

dcm_obj2 = datacursormode(PTspecfig);
set(dcm_obj2,'UpdateFcn',@PTdatatip);

specCrtlpanel = uipanel('Title','','FontSize',fontsz2,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.015 .9 .975 .1]);
 
%%% PRESET CONFIGURATIONS
guiHandlesSpec.specPresets = uicontrol(PTspecfig,'Style','popupmenu','string',{'PRESETS:'; '  1. [A+B] Gyro prefilt | Gyro'  ; '  2. [A+B] Gyro | Dterm' ; '  3. [A+B] Fterm | PIDsum' ; '  4. [A+B] Set point | PID error'; '  5. [A+B] Motors 1-2 | Motors 3-4' ; '  6. [A+B] Debug 1-2 | Debug 3-4' ;  '  7. [A] Gyro prefilt | Gyro | Pterm | Dterm' ; '  8. [A] Gyro prefilt | Gyro | Dterm prefilt | Dterm' ; '  9. [A] Pterm | Dterm | Fterm | PIDsum ' ;'  10. [A] Gyro | Dterm | Set point | PID error' ; '11. [A] Motors 1-2 | Motors 3-4' ;  '12. [A] Debug 1-2 | Debug 3-4'; '13. [B] Gyro prefilt | Gyro | Pterm | Dterm' ; '14. [B] Gyro prefilt | Gyro | Dterm prefilt | Dterm'; '15. [B] Pterm | Dterm | Fterm | PIDsum ' ; '16. [B] Gyro | Dterm | Set point | PID error' ; '17. [B] Motors 1-2 | Motors 3-4'; '18. [B] Debug 1-2 | Debug 3-4'},...
    'fontsize',fontsz2,'TooltipString', [TooltipString_presets], 'units','normalized','outerposition', [posInfo.specPresets],'callback',...
    ['if guiHandlesSpec.specPresets.Value == 1, guiHandlesSpec.SpecSelect{1}.Value=1; guiHandlesSpec.SpecSelect{2}.Value=1; guiHandlesSpec.SpecSelect{3}.Value=1; guiHandlesSpec.SpecSelect{4}.Value=1; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...    
    'if guiHandlesSpec.specPresets.Value == 2, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=16; guiHandlesSpec.SpecSelect{4}.Value=15; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 3, guiHandlesSpec.SpecSelect{1}.Value=2; guiHandlesSpec.SpecSelect{2}.Value=7; guiHandlesSpec.SpecSelect{3}.Value=15; guiHandlesSpec.SpecSelect{4}.Value=20; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 4, guiHandlesSpec.SpecSelect{1}.Value=9; guiHandlesSpec.SpecSelect{2}.Value=10; guiHandlesSpec.SpecSelect{3}.Value=22; guiHandlesSpec.SpecSelect{4}.Value=23; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 5, guiHandlesSpec.SpecSelect{1}.Value=5; guiHandlesSpec.SpecSelect{2}.Value=4; guiHandlesSpec.SpecSelect{3}.Value=18; guiHandlesSpec.SpecSelect{4}.Value=17; guiHandlesSpec.Sub100HzCheck{1}.Value=1; guiHandlesSpec.Sub100HzCheck{2}.Value=1; guiHandlesSpec.Sub100HzCheck{3}.Value=1; guiHandlesSpec.Sub100HzCheck{4}.Value=1; end;',...
    'if guiHandlesSpec.specPresets.Value == 6, guiHandlesSpec.SpecSelect{1}.Value=11; guiHandlesSpec.SpecSelect{2}.Value=12; guiHandlesSpec.SpecSelect{3}.Value=24; guiHandlesSpec.SpecSelect{4}.Value=25; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...  
    'if guiHandlesSpec.specPresets.Value == 7, guiHandlesSpec.SpecSelect{1}.Value=13; guiHandlesSpec.SpecSelect{2}.Value=14; guiHandlesSpec.SpecSelect{3}.Value=26; guiHandlesSpec.SpecSelect{4}.Value=27; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...  
    'if guiHandlesSpec.specPresets.Value == 8, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=6; guiHandlesSpec.SpecSelect{4}.Value=7; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 9, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=8; guiHandlesSpec.SpecSelect{4}.Value=7; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',... 
    'if guiHandlesSpec.specPresets.Value == 10, guiHandlesSpec.SpecSelect{1}.Value=6; guiHandlesSpec.SpecSelect{2}.Value=7; guiHandlesSpec.SpecSelect{3}.Value=9; guiHandlesSpec.SpecSelect{4}.Value=10; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 11, guiHandlesSpec.SpecSelect{1}.Value=2; guiHandlesSpec.SpecSelect{2}.Value=7; guiHandlesSpec.SpecSelect{3}.Value=5; guiHandlesSpec.SpecSelect{4}.Value=4; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=1; guiHandlesSpec.Sub100HzCheck{4}.Value=1; end;',...
    'if guiHandlesSpec.specPresets.Value == 12, guiHandlesSpec.SpecSelect{1}.Value=11; guiHandlesSpec.SpecSelect{2}.Value=12; guiHandlesSpec.SpecSelect{3}.Value=1; guiHandlesSpec.SpecSelect{4}.Value=1; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 13, guiHandlesSpec.SpecSelect{1}.Value=13; guiHandlesSpec.SpecSelect{2}.Value=14; guiHandlesSpec.SpecSelect{3}.Value=1; guiHandlesSpec.SpecSelect{4}.Value=1; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 14, guiHandlesSpec.SpecSelect{1}.Value=16; guiHandlesSpec.SpecSelect{2}.Value=15; guiHandlesSpec.SpecSelect{3}.Value=19; guiHandlesSpec.SpecSelect{4}.Value=20; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 15, guiHandlesSpec.SpecSelect{1}.Value=16; guiHandlesSpec.SpecSelect{2}.Value=15; guiHandlesSpec.SpecSelect{3}.Value=21; guiHandlesSpec.SpecSelect{4}.Value=20; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 16, guiHandlesSpec.SpecSelect{1}.Value=19; guiHandlesSpec.SpecSelect{2}.Value=20; guiHandlesSpec.SpecSelect{3}.Value=22; guiHandlesSpec.SpecSelect{4}.Value=23; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
    'if guiHandlesSpec.specPresets.Value == 17, guiHandlesSpec.SpecSelect{1}.Value=15; guiHandlesSpec.SpecSelect{2}.Value=20; guiHandlesSpec.SpecSelect{3}.Value=18; guiHandlesSpec.SpecSelect{4}.Value=17; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=1; guiHandlesSpec.Sub100HzCheck{4}.Value=1; end;',...
    'if guiHandlesSpec.specPresets.Value == 18, guiHandlesSpec.SpecSelect{1}.Value=24; guiHandlesSpec.SpecSelect{2}.Value=25; guiHandlesSpec.SpecSelect{3}.Value=1; guiHandlesSpec.SpecSelect{4}.Value=1; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',... 
    'if guiHandlesSpec.specPresets.Value == 19, guiHandlesSpec.SpecSelect{1}.Value=26; guiHandlesSpec.SpecSelect{2}.Value=27; guiHandlesSpec.SpecSelect{3}.Value=1; guiHandlesSpec.SpecSelect{4}.Value=1; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;']); 

guiHandlesSpec.computeSpec = uicontrol(PTspecfig,'string','Run','fontsize',fontsz2,'TooltipString', [TooltipString_specRun],'units','normalized','outerposition',[posInfo.computeSpec],...
    'callback','PTplotSpec;');
guiHandlesSpec.computeSpec.BackgroundColor=[.3 .9 .3];

guiHandlesSpec.checkbox2d =uicontrol(PTspecfig,'Style','checkbox','String','2-D','fontsize',fontsz2,'TooltipString', [TooltipString_2d],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkbox2d],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');

guiHandlesSpec.percentMotor = uicontrol(PTspecfig,'Style','popupmenu','string',{'%throttle'; '%motor'},...
    'fontsize',fontsz2,'TooltipString', [TooltipString_percentThr], 'units','normalized','outerposition', [posInfo.percentMotor],'callback','@selection2;');

guiHandlesSpec.subsampleFactor = uicontrol(PTspecfig,'Style','popupmenu','string',{'subsampling low (fastest | less reliable)'; 'subsampling med-low'; 'subsampling medium'; 'subsampling med-high'; 'subsampling high (slowest | most reliable)'},...
    'fontsize',fontsz2,'TooltipString', [TooltipString_subsample], 'units','normalized','outerposition', [posInfo.subsampleFactor],'callback','@selection2;');
guiHandlesSpec.subsampleFactor.Value=2;

guiHandlesSpec.controlFreq1Cutoff_text = uicontrol(PTspecfig,'style','text','string','Fcut1','fontsize',fontsz2,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.controlFreq1Cutoff_text]);
guiHandlesSpec.controlFreq1Cutoff = uicontrol(PTspecfig,'style','edit','string',[num2str(round(Flim1))],'fontsize',fontsz2,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','outerposition',[posInfo.controlFreq1Cutoff],...
     'callback','@textinput_call2; Flim1=round(str2num(guiHandlesSpec.controlFreq1Cutoff.String));updateSpec=1;PTplotSpec;');

guiHandlesSpec.controlFreq2Cutoff_text = uicontrol(PTspecfig,'style','text','string','Fcut2','fontsize',fontsz2,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.controlFreq2Cutoff_text]);
guiHandlesSpec.controlFreq2Cutoff = uicontrol(PTspecfig,'style','edit','string',[num2str(round(Flim2))],'fontsize',fontsz2,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','outerposition',[posInfo.controlFreq2Cutoff],...
     'callback','@textinput_call2; Flim2=round(str2num(guiHandlesSpec.controlFreq2Cutoff.String));updateSpec=1;PTplotSpec;');

 
guiHandlesSpec.RClimCutoff_text = uicontrol(PTspecfig,'style','text','string','RClim','fontsize',fontsz2,'TooltipString',[TooltipString_RClim],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.RClimCutoff_text]);
guiHandlesSpec.RClimCutoff = uicontrol(PTspecfig,'style','edit','string',[num2str(round(RClim))],'fontsize',fontsz2,'TooltipString',[TooltipString_RClim],'units','normalized','outerposition',[posInfo.RClimCutoff],...
     'callback','@textinput_call2; RClim=round(str2num(guiHandlesSpec.RClimCutoff.String));updateSpec=1;PTplotSpec;');

 

guiHandlesSpec.saveFig2 = uicontrol(PTspecfig,'string','Save Fig','fontsize',fontsz2,'TooltipString',[TooltipString_saveFig],'units','normalized','BackgroundColor',[.8 .8 .8],'outerposition',[posInfo.saveFig2],...
    'callback','guiHandlesSpec.saveFig2.FontWeight=''bold'';PTsaveFig;guiHandlesSpec.saveFig2.FontWeight=''normal'';'); 

guiHandlesSpec.Sub100HzCheck{1} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,'TooltipString', [TooltipString_sub100],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck1],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{2} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,'TooltipString', [TooltipString_sub100],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck2],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{3} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,'TooltipString', [TooltipString_sub100],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck3],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{4} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,'TooltipString', [TooltipString_sub100],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck4],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');

% create string list for SpecSelect
sA={'NONE','Gyro [A]','Gyro prefilt [A]','PID error [A]','Set point [A]','Pterm [A]','Dterm [A]','Dterm prefilt [A]','Fterm [A]','PIDsum [A]','Motors 1 2 [A]','Motors 3 4 [A]', 'Debug 1 2 [A]','Debug 3 4 [A]'};
sB={'Gyro [B]','Gyro prefilt [B]','PID error [B]','Set point [B]','Pterm [B]','Dterm [B]','Dterm prefilt [B]','Fterm [B]','PIDsum [B]','Motors 1 2 [B]','Motors 3 4 [B]', 'Debug 1 2 [B]','Debug 3 4 [B]'};

% combine strings
sAB=[sA sB];
    
guiHandlesSpec.SpecSelect{1} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn1pos],'callback','@selection2;');
guiHandlesSpec.SpecSelect{2} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn2pos],'callback','@selection2;');
guiHandlesSpec.SpecSelect{3} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn3pos],'callback','@selection2;');
guiHandlesSpec.SpecSelect{4} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn4pos],'callback','@selection2;');

 guiHandlesSpec.SpecSelect{1}.Value=1;
 guiHandlesSpec.SpecSelect{2}.Value=1;
 guiHandlesSpec.SpecSelect{3}.Value=1;
 guiHandlesSpec.SpecSelect{4}.Value=1;

guiHandlesSpec.smoothFactor_select = uicontrol(PTspecfig,'style','popupmenu','string',{'smoothing low' 'smoothing low-med' 'smoothing medium' 'smoothing med-high' 'smoothing high'},'fontsize',fontsz2,'TooltipString', [TooltipString_smooth], 'units','normalized','outerposition',[posInfo.smooth_select],...
     'callback','@selection2;updateSpec=1;PTplotSpec;');
guiHandlesSpec.smoothFactor_select.Value=3;

guiHandlesSpec.climMax_text = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text]);
guiHandlesSpec.climMax_input = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(1))],'fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input],...
     'callback','@textinput_call2; climScale(1)=str2num(guiHandlesSpec.climMax_input.String);updateSpec=1;PTplotSpec;');

 guiHandlesSpec.climMax_text2 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text2]);
guiHandlesSpec.climMax_input2 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(2))],'fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input2],...
     'callback','@textinput_call2; climScale(2)=str2num(guiHandlesSpec.climMax_input2.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.climMax_text3 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text3]);
guiHandlesSpec.climMax_input3 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(3))],'fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input3],...
     'callback','@textinput_call2; climScale(3)=str2num(guiHandlesSpec.climMax_input3.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.climMax_text4 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text4]);
guiHandlesSpec.climMax_input4 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(4))],'fontsize',fontsz2,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input4],...
     'callback','@textinput_call2; climScale(4)=str2num(guiHandlesSpec.climMax_input4.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.ColormapSelect = uicontrol(PTspecfig,'Style','popupmenu','string',{'parula','jet','hot','cool','gray','bone','copper','viridis','linear-RED','linear-GREY'},...
    'fontsize',fontsz2,'TooltipString', [TooltipString_cmap], 'units','normalized','outerposition',[posInfo.ColormapSelect],'callback','@selection2;updateSpec=1; PTplotSpec;');
guiHandlesSpec.ColormapSelect.Value=3;% hot 3 viridis 12


%% get estimate of phase delay (computed on roll axis only since it's typically the most active)
% note, this is an estimate, given the many dynamic filter options in BF4.0+
% the reliability of the estimate depend to some degree on the amplitude modulation of the signals 
% (i.e., when there is stick input).
clear sampTime maxlag PhaseDelay_A PhaseDelay2_A 
HardwareLPFdelay = 0.98; % ms
 
if A_debugmode==GYRO_SCALED
    try
        sampTime=(mean(diff(tta)));%microsec
        maxlag=int8(round(3000/sampTime)); %~3ms delay
        PhaseDelay_A=finddelay(smooth(DATmainA.debug(1,:),50),smooth(DATmainA.GyroFilt(1,:),50),maxlag) * sampTime / 1000; % both signals smoothed equally, more reliable estimate
        if PhaseDelay_A<.1, PhaseDelay_A=[]; end % when garbage gets through

        PhaseDelay2_A=finddelay(smooth(DATmainA.DtermRaw(1,:),50),smooth(DATmainA.DtermFilt(1,:),50),maxlag) * sampTime / 1000;
        if PhaseDelay2_A<.1, PhaseDelay2_A=[]; end % when garbage gets through
        guiHandlesSpec.AphasedelayText = uicontrol(PTspecfig,'style','text','string',['[A] estimated phase delay (hardware/gyro/dterm/total): ' num2str(HardwareLPFdelay) ' / ' num2str(round(PhaseDelay_A*100)/100) ' / ' num2str(round(PhaseDelay2_A*100)/100) ' / ' num2str(round((HardwareLPFdelay+PhaseDelay_A+PhaseDelay2_A)*100)/100) ' ms'],'fontsize',fontsz2,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText]);
    catch
        guiHandlesSpec.AphasedelayText = uicontrol(PTspecfig,'style','text','string',['[A] unable to estimate phase delay '],'fontsize',fontsz2,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText]);
    end
else
        guiHandlesSpec.AphasedelayText = uicontrol(PTspecfig,'style','text','string',['[A] unable to estimate phase delay '],'fontsize',fontsz2,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText]);
end

clear sampTime maxlag PhaseDelay_B PhaseDelay2_B
if B_debugmode==GYRO_SCALED
    try
        sampTime=(mean(diff(ttb)));
        maxlag=int8(round(3000/sampTime)); %~3ms delay
        PhaseDelay_B=finddelay(smooth(DATmainB.debug(1,:),50),smooth(DATmainB.GyroFilt(1,:),50),maxlag) * sampTime / 1000;
        if PhaseDelay_B<.1, PhaseDelay_B=[]; end % when garbage gets through

        PhaseDelay2_B=finddelay(smooth(DATmainB.DtermRaw(1,:),50),smooth(DATmainB.DtermFilt(1,:),50),maxlag) * sampTime / 1000;
        if PhaseDelay2_B<.1, PhaseDelay2_B=[]; end % when garbage gets through

        guiHandlesSpec.BphasedelayText = uicontrol(PTspecfig,'style','text','string',['[B] estimated phase delay (hardware/gyro/dterm/total): ' num2str(HardwareLPFdelay) ' / ' num2str(round(PhaseDelay_B*100)/100) ' / ' num2str(round(PhaseDelay2_B*100)/100) ' / ' num2str(round((HardwareLPFdelay+PhaseDelay_B+PhaseDelay2_B)*100)/100) ' ms'],'fontsize',fontsz2,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.BphasedelayText]);
    catch
        guiHandlesSpec.BphasedelayText = uicontrol(PTspecfig,'style','text','string',['[B] unable to estimate phase delay '],'fontsize',fontsz2,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.BphasedelayText]);
    end
else
       guiHandlesSpec.BphasedelayText = uicontrol(PTspecfig,'style','text','string',['[B] unable to estimate phase delay '],'fontsize',fontsz2,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.BphasedelayText]);
end

else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end

% functions
function selection2(src,event)
    val = c.Value;
    str = c.String;
    str{val};
   % disp(['Selection: ' str{val}]);
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

% functions
function selection3()
    if guiHandlesSpec.specPresets.Value == 1
        guiHandlesSpec.SpecSelect{1}.Value=1;
        guiHandlesSpec.SpecSelect{2}.Value=1;
        guiHandlesSpec.SpecSelect{3}.Value=1;
        guiHandlesSpec.SpecSelect{4}.Value=1;
    end
    if guiHandlesSpec.specPresets.Value == 2
        guiHandlesSpec.SpecSelect{1}.Value=3;
        guiHandlesSpec.SpecSelect{2}.Value=2;
        guiHandlesSpec.SpecSelect{3}.Value=6;
        guiHandlesSpec.SpecSelect{4}.Value=7;
    end
end



