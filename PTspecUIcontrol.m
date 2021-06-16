%% PTspecUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(fnameMaster)
   
%%% tooltips
TooltipString_specRun=['Run current spectral configuration',...
    newline, 'Warning: Set subsampling dropdown @ or < medium for faster processing.'];
TooltipString_presets=['Choose from a selection of PRESET configurations'];
TooltipString_cmap=['Choose from a selection of colormaps'];
TooltipString_smooth=['Choose amount of smoothing'];
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
TooltipString_controlFreqCutoff=['Hz = Freq cutoff bounds for sub100Hz mean/peak analysis window.',...
    newline  'Changing this will move the yellow dashed lines representing this range (only in sub100Hz view).'];

%%%

% define
smat=[];%string
ampmat=[];%spec matrix
amp2d=[];%spec 2d
freq=[];% freq

% only need to call once to compute extra colormaps
PTcolormap;

SpecLineCols=[];
SpecLineCols(:,:,1) = [colorA; colorA; colorA; colorA];  
SpecLineCols(:,:,2) = [colorA; colorA; colorB; colorB]; 
SpecLineCols(:,:,3) = [colorA; colorB; colorC; colorD]; 
    
clear posInfo.SpecPos
cols=[0.045 0.267 0.489 0.711];
rows=[0.64 0.35 0.06];
k=0;
for c=1:4
    for r=1:3
        k=k+1;
        posInfo.SpecPos(k,:)=[cols(c) rows(r) 0.175 0.23];
    end
end

posInfo.computeSpec=            [.905 .835 .039 .04];
posInfo.resetSpec=              [.945 .835 .039 .04];
posInfo.saveFig2=               [.905 .79 .079 .04];
 
posInfo.specPresets=            [.902 .765 .085 0.01];
posInfo.ColormapSelect=         [.902 .732 .085 0.01];
posInfo.smooth_select =         [.902 .698 .085 0.01];
posInfo.controlFreq1Cutoff =    [.916 .62 .023 .025];
posInfo.controlFreq2Cutoff =    [.951 .62 .023 .025];
posInfo.controlFreqCutoff_text =[.911 .645 .07 .025];
posInfo.checkbox2d=             [.915 .595 .04 .02];
posInfo.checkboxPSD=            [.945 .595 .04 .02];
 
posInfo.AphasedelayText1=[.06 .983 .14 .018];
posInfo.AphasedelayText2=[.282 .983 .14 .018];
posInfo.AphasedelayText3=[.504 .983 .14 .018];
posInfo.AphasedelayText4=[.726 .983 .14 .018];
 
posInfo.hCbar1pos=[0.045 0.878 0.18  0.02];
posInfo.hCbar2pos=[0.267 0.878 0.18  0.02];
posInfo.hCbar3pos=[0.489 0.878 0.18  0.02];
posInfo.hCbar4pos=[0.711 0.878 0.18  0.02];
 
posInfo.hDropdn1pos=[0.08 0.97 0.095   0.01];
posInfo.hDropdn2pos=[0.302 0.97 0.095   0.01];
posInfo.hDropdn3pos=[0.524 0.97 0.095   0.01];
posInfo.hDropdn4pos=[0.746 0.97 0.095   0.01];
 
posInfo.fDropdn1pos=[0.08 0.94 0.095  0.01];
posInfo.fDropdn2pos=[0.302 0.94 0.095  0.01];
posInfo.fDropdn3pos=[0.524 0.94 0.095  0.01];
posInfo.fDropdn4pos=[0.746 0.94 0.095  0.01];
 
posInfo.Sub100HzCheck1=[0.18 0.945 .06 .025];
posInfo.Sub100HzCheck2=[.405 .945 .06 .025];
posInfo.Sub100HzCheck3=[0.625 0.945 .06 .025];
posInfo.Sub100HzCheck4=[.85 .945 .06 .025];

posInfo.climMax_text = [.015 .901 .025 .024];
posInfo.climMax_input = [.015 .876 .025 .024];
posInfo.climMax_text2 = [.237 .901 .025 .024]; 
posInfo.climMax_input2 = [.237 .876 .025 .024];
posInfo.climMax_text3 = [.46 .901 .025 .024]; 
posInfo.climMax_input3 = [.46 .876 .025 .024];
posInfo.climMax_text4 = [.682 .901 .025 .024]; 
posInfo.climMax_input4 = [.682 .876 .025 .024];
climScale=[0.5 0.5 0.5 0.5; 5 5 5 5];
Flim1=20; % 3.3333Hz steps
Flim2=60;

PTspecfig=figure(2);
set(PTspecfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTspecfig.NumberTitle='off';
PTspecfig.Name= ['PIDtoolbox (' PtbVersion ') - Spectral Analyzer'];
PTspecfig.InvertHardcopy='off';
set(PTspecfig,'color',bgcolor);


dcm_obj2 = datacursormode(PTspecfig);
set(dcm_obj2,'UpdateFcn',@PTdatatip);

specCrtlpanel = uipanel('Title','Params','FontSize',fontsz,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.897 .589 .095 .31]);
 
%%% PRESET CONFIGURATIONS

% guiHandles.FileNum = uicontrol(PTspecfig,'Style','popupmenu','string',[fnameMaster],'TooltipString', [TooltipString_FileNum],...
%     'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.fnameASpec],'callback','PTplotSpec;');

guiHandlesSpec.specPresets = uicontrol(PTspecfig,'Style','popupmenu','string',{'Presets:'; '1. Gyro prefilt | Gyro | Dterm prefilt | Dterm' ;  '2. Gyro prefilt | Gyro | Pterm | Dterm' ; '3. Gyro | Dterm | Set point | PID error' ; '4. A|A|B|B Gyro prefilt | Gyro' ; '5. A|A|B|B Dterm prefilt | Dterm' ; '6. A|B|C|D Gyro prefilt ' ;'7. A|B|C|D Gyro '; '8. A|B|C|D Dterm '; '9. A|B|C|D PID error'},...
    'fontsize',fontsz,'TooltipString', [TooltipString_presets], 'units','normalized','outerposition', [posInfo.specPresets],'callback',...
    ['if guiHandlesSpec.specPresets.Value == 1, guiHandlesSpec.SpecSelect{1}.Value=1; guiHandlesSpec.SpecSelect{2}.Value=1; guiHandlesSpec.SpecSelect{3}.Value=1; guiHandlesSpec.SpecSelect{4}.Value=1; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 2, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=8; guiHandlesSpec.SpecSelect{4}.Value=7; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 3, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=6; guiHandlesSpec.SpecSelect{4}.Value=7; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...  
     'if guiHandlesSpec.specPresets.Value == 4, guiHandlesSpec.SpecSelect{1}.Value=2; guiHandlesSpec.SpecSelect{2}.Value=7; guiHandlesSpec.SpecSelect{3}.Value=5; guiHandlesSpec.SpecSelect{4}.Value=4; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=1; guiHandlesSpec.Sub100HzCheck{4}.Value=1; end;',...
     'if guiHandlesSpec.specPresets.Value == 5, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=3; guiHandlesSpec.SpecSelect{4}.Value=2; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 6, guiHandlesSpec.SpecSelect{1}.Value=8; guiHandlesSpec.SpecSelect{2}.Value=7; guiHandlesSpec.SpecSelect{3}.Value=8; guiHandlesSpec.SpecSelect{4}.Value=7; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 7, guiHandlesSpec.SpecSelect{1}.Value=3; guiHandlesSpec.SpecSelect{2}.Value=3; guiHandlesSpec.SpecSelect{3}.Value=3; guiHandlesSpec.SpecSelect{4}.Value=3; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 8, guiHandlesSpec.SpecSelect{1}.Value=2; guiHandlesSpec.SpecSelect{2}.Value=2; guiHandlesSpec.SpecSelect{3}.Value=2; guiHandlesSpec.SpecSelect{4}.Value=2; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 9, guiHandlesSpec.SpecSelect{1}.Value=7; guiHandlesSpec.SpecSelect{2}.Value=7; guiHandlesSpec.SpecSelect{3}.Value=7; guiHandlesSpec.SpecSelect{4}.Value=7; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;',...
     'if guiHandlesSpec.specPresets.Value == 10, guiHandlesSpec.SpecSelect{1}.Value=4; guiHandlesSpec.SpecSelect{2}.Value=4; guiHandlesSpec.SpecSelect{3}.Value=4; guiHandlesSpec.SpecSelect{4}.Value=4; guiHandlesSpec.Sub100HzCheck{1}.Value=0; guiHandlesSpec.Sub100HzCheck{2}.Value=0; guiHandlesSpec.Sub100HzCheck{3}.Value=0; guiHandlesSpec.Sub100HzCheck{4}.Value=0; end;']); 
guiHandlesSpec.specPresets.Value = 1;

guiHandlesSpec.computeSpec = uicontrol(PTspecfig,'string','Run','fontsize',fontsz,'TooltipString', [TooltipString_specRun],'units','normalized','outerposition',[posInfo.computeSpec],...
    'callback','PTplotSpec;');
guiHandlesSpec.computeSpec.BackgroundColor=[.3 .9 .3];

guiHandlesSpec.resetSpec = uicontrol(PTspecfig,'string','Reset','fontsize',fontsz,'TooltipString', ['Reset Spectral Tool'],'units','normalized','outerposition',[posInfo.resetSpec],...
    'callback',' for k = 1 :12, delete(subplot(''position'',posInfo.SpecPos(k,:))), end; guiHandlesSpec.specPresets.Value = 1; PTspecUIcontrol; ');
guiHandlesSpec.resetSpec.BackgroundColor=[cautionCol];

guiHandlesSpec.checkbox2d =uicontrol(PTspecfig,'Style','checkbox','String','2D','fontsize',fontsz,'TooltipString', [TooltipString_2d],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkbox2d],'callback','if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');

guiHandlesSpec.checkboxPSD =uicontrol(PTspecfig,'Style','checkbox','String','PSD','fontsize',fontsz,'TooltipString', ['Power Spectral Density'],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkboxPSD],'callback', 'PTplotSpec;');
guiHandlesSpec.checkboxPSD.Value = 0;

guiHandlesSpec.controlFreqCutoff_text = uicontrol(PTspecfig,'style','text','string','freq lims Hz','fontsize',fontsz,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.controlFreqCutoff_text]);
guiHandlesSpec.controlFreq1Cutoff = uicontrol(PTspecfig,'style','edit','string',[num2str(round(Flim1))],'fontsize',fontsz,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','outerposition',[posInfo.controlFreq1Cutoff],...
     'callback','@textinput_call2; Flim1=round(str2num(guiHandlesSpec.controlFreq1Cutoff.String));updateSpec=1;PTplotSpec;');
guiHandlesSpec.controlFreq2Cutoff = uicontrol(PTspecfig,'style','edit','string',[num2str(round(Flim2))],'fontsize',fontsz,'TooltipString',[TooltipString_controlFreqCutoff],'units','normalized','outerposition',[posInfo.controlFreq2Cutoff],...
     'callback','@textinput_call2; Flim2=round(str2num(guiHandlesSpec.controlFreq2Cutoff.String));updateSpec=1;PTplotSpec;');


guiHandlesSpec.saveFig2 = uicontrol(PTspecfig,'string','Save Fig','fontsize',fontsz,'TooltipString',[TooltipString_saveFig],'units','normalized','BackgroundColor',[saveCol],'outerposition',[posInfo.saveFig2],...
    'callback','guiHandlesSpec.saveFig2.FontWeight=''bold'';PTsaveFig;guiHandlesSpec.saveFig2.FontWeight=''normal'';'); 

guiHandlesSpec.Sub100HzCheck{1} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz,'TooltipString', [TooltipString_sub100], 'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck1],'callback','if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{2} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz,'TooltipString', [TooltipString_sub100], 'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck2],'callback','if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{3} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz,'TooltipString', [TooltipString_sub100], 'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck3],'callback','if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{4} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz,'TooltipString', [TooltipString_sub100], 'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck4],'callback','if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');

% create string list for SpecSelect
sA={'NONE','Gyro','Gyro prefilt','PID error','Set point','Pterm','Dterm','Dterm prefilt','PIDsum'};

guiHandlesSpec.SpecSelect{1} = uicontrol(PTspecfig,'Style','popupmenu','string',sA, 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn1pos]);
guiHandlesSpec.SpecSelect{2} = uicontrol(PTspecfig,'Style','popupmenu','string',sA, 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn2pos]);
guiHandlesSpec.SpecSelect{3} = uicontrol(PTspecfig,'Style','popupmenu','string',sA,  'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn3pos]);
guiHandlesSpec.SpecSelect{4} = uicontrol(PTspecfig,'Style','popupmenu','string',sA, 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.hDropdn4pos]);

guiHandlesSpec.SpecSelect{1}.Value=3;
guiHandlesSpec.SpecSelect{2}.Value=2;
guiHandlesSpec.SpecSelect{3}.Value=8;
guiHandlesSpec.SpecSelect{4}.Value=7;
 
guiHandlesSpec.FileSelect{1} = uicontrol(PTspecfig,'Style','popupmenu','string',[fnameMaster], 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.fDropdn1pos],'callback','PTfiltDelay;');
guiHandlesSpec.FileSelect{2} = uicontrol(PTspecfig,'Style','popupmenu','string',[fnameMaster], 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.fDropdn2pos],'callback','PTfiltDelay;');
guiHandlesSpec.FileSelect{3} = uicontrol(PTspecfig,'Style','popupmenu','string',[fnameMaster], 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.fDropdn3pos],'callback','PTfiltDelay;');
guiHandlesSpec.FileSelect{4} = uicontrol(PTspecfig,'Style','popupmenu','string',[fnameMaster], 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.fDropdn4pos],'callback','PTfiltDelay;');

guiHandlesSpec.smoothFactor_select = uicontrol(PTspecfig,'style','popupmenu','string',{'smoothing low' 'smoothing low-med' 'smoothing medium' 'smoothing med-high' 'smoothing high'},'fontsize',fontsz,'TooltipString', [TooltipString_smooth], 'units','normalized','outerposition',[posInfo.smooth_select],...
     'callback','@selection2;updateSpec=1;PTplotSpec;');
guiHandlesSpec.smoothFactor_select.Value=3;

guiHandlesSpec.climMax_text = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text]);
guiHandlesSpec.climMax_input = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 1))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 1)=str2num(guiHandlesSpec.climMax_input.String);updateSpec=1;PTplotSpec;');

 guiHandlesSpec.climMax_text2 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text2]);
guiHandlesSpec.climMax_input2 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 2))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input2],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 2)=str2num(guiHandlesSpec.climMax_input2.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.climMax_text3 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text3]);
guiHandlesSpec.climMax_input3 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 3))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input3],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 3)=str2num(guiHandlesSpec.climMax_input3.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.climMax_text4 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text4]);
guiHandlesSpec.climMax_input4 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 4))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input4],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 4)=str2num(guiHandlesSpec.climMax_input4.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.ColormapSelect = uicontrol(PTspecfig,'Style','popupmenu','string',{'parula','jet','hot','cool','gray','bone','copper','viridis','linear-RED','linear-GREY'},...
    'fontsize',fontsz,'TooltipString', [TooltipString_cmap], 'units','normalized','outerposition',[posInfo.ColormapSelect],'callback','@selection2;updateSpec=1; PTplotSpec;');
guiHandlesSpec.ColormapSelect.Value=3;% jet 2 hot 3 viridis 8


%% get estimate of phase delay (computed on roll axis only since it's typically the most active)
% note, this is an estimate, given the many dynamic filter options in BF4.0+
% the reliability of the estimate depend to some degree on the amplitude modulation of the signals 
% (i.e., when there is stick input).
clear sampTime maxlag PhaseDelay_A PhaseDelay2_A SampleDelay_A SampleDelay2_A
HardwareLPFdelay = 0.98; % ms
 
% work in progress, phase lag in a moving window
% SampleDelay_A=zeros(1,length(DATmainA.debug(1,:)));
% wind=A_lograte*2000; %2sec
% for i=wind:size(DATmainA.debug(1,:),2)-wind+1
%      SampleDelay_A(1,i)=finddelay(smooth(DATmainA.debug(1,i-wind+1:i+wind),50),smooth(DATmainA.GyroFilt(1,i-wind+1:i+wind),50),maxlag);   
% end
PhaseDelay_A={};PhaseDelay2_A={};
for k = 1 : Nfiles
    try 
        Fs=1000/A_lograte(k);% yields more consistent results (mode(diff(tta)));
        maxlag=int8(round(6000/Fs)); %~6ms delay

        clear d g1 g2
        g1 = smooth(T{k}.debug_0_(tIND{k}),50);
        g2 = smooth(T{k}.gyroADC_0_(tIND{k}), 50);
        d = finddelay(g1 ,g2, maxlag); % both signals smoothed equally, more reliable estimate
        d = d * (Fs / 1000);
        if d<.1,  PhaseDelay_A{k} = ' '; else PhaseDelay_A{k} = num2str(d);end 
        
        clear d g1 g2
        g1 = [0;smooth(diff(smooth(T{k}.gyroADC_0_(tIND{k}),50)), 50)];
        g2 = smooth(T{k}.axisD_0_(tIND{k}),50);
        d=finddelay(g1, g2, maxlag) ;
        d=d * (Fs / 1000);
        if d<.1, PhaseDelay2_A{k} = ' '; else PhaseDelay2_A{k} = num2str(d); end
    catch
        PhaseDelay_A{k} = ' ';
        PhaseDelay2_A{k} = ' ';
    end
end

guiHandlesSpec.estDelayText = uicontrol(PTspecfig,'style','text','string',['est. delay:'],'fontsize',fontsz,'TooltipString', [' '],'units','normalized','BackgroundColor',[.9 .9 .1],'outerposition',[.01 .98 .048 .024]);
guiHandlesSpec.AphasedelayText1 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{1}.Value} 'ms, Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{1}.Value} 'ms'],'fontsize',fontsz*.9,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText1]);
guiHandlesSpec.AphasedelayText2 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{2}.Value} 'ms, Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{2}.Value} 'ms'],'fontsize',fontsz*.9,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText2]);
guiHandlesSpec.AphasedelayText3 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{3}.Value} 'ms, Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{3}.Value} 'ms'],'fontsize',fontsz*.9,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText3]);
guiHandlesSpec.AphasedelayText4 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{4}.Value} 'ms, Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{4}.Value} 'ms'],'fontsize',fontsz*.9,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText4]);


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





