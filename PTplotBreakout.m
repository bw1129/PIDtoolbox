%% PTplotBreakout - script to save main Figs without UI control panel in new window

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) | ~isempty(filenameB)


PTfig2 = figure(2);
set(PTfig2, 'units','normalized','outerposition',[0 0 1 1])
PTfig2.NumberTitle='off';
PTfig2.Name= 'PID toolbox';
dcm_obj = datacursormode(PTfig2);
         set(dcm_obj,'UpdateFcn',@PTdatatip);
         

%% update font sizes

prop_max_screen=(max([PTfig2.Position(3) PTfig2.Position(4)]));

fontsz=(screensz_multiplier*prop_max_screen);

guiHandles.fileA.FontSize=fontsz;
guiHandles.fileB.FontSize=fontsz;
guiHandles.runAll.FontSize=fontsz;
guiHandles.refreshcall.FontSize=fontsz;
guiHandles.maxSticktext.FontSize=fontsz;
guiHandles.maxStick.FontSize=fontsz;
guiHandles.Epoch1_A_text.FontSize=fontsz;
guiHandles.Epoch1_A_Input.FontSize=fontsz;
guiHandles.Epoch2_A_text.FontSize=fontsz;
guiHandles.Epoch2_A_Input.FontSize=fontsz;
guiHandles.Epoch1_B_text.FontSize=fontsz;
guiHandles.Epoch1_B_Input.FontSize=fontsz;
guiHandles.Epoch2_B_text.FontSize=fontsz;
guiHandles.Epoch2_B_Input.FontSize=fontsz;
guiHandles.climMax_text.FontSize=fontsz;
guiHandles.climMax_input.FontSize=fontsz;
guiHandles.climMax_text2.FontSize=fontsz;
guiHandles.climMax_input2.FontSize=fontsz;
guiHandles.BreakoutPlotButton.FontSize=fontsz;
guiHandles.Spec1Select.FontSize=fontsz;
guiHandles.Spec2Select.FontSize=fontsz;
guiHandles.Sub100HzCheck1.FontSize=fontsz;
guiHandles.Sub100HzCheck2.FontSize=fontsz;
guiHandles.ColormapSelect.FontSize=fontsz;
guiHandles.DispInfoButton.FontSize=fontsz;
guiHandles.PlotSelect.FontSize=fontsz;


%% text
    
if  ~isempty(filenameA)
    if ~dataA.BBfileFlag
        UIsetupInfo.fnameAText = uicontrol(PTfig2,'style','text','string',['A:' filenameA],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.950    0.2000    0.0400]);
        UIsetupInfo.Firmware_revisionA = uicontrol(PTfig2,'style','text','string',[Firmware_revision_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.920    0.200    0.0500]);
        UIsetupInfo.looptimeA = uicontrol(PTfig2,'style','text','string',['looptime A:' int2str(A_looptime/1000) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.8900    0.2000    0.0400]);
        UIsetupInfo.frameIntervalPDenomA = uicontrol(PTfig2,'style','text','string',['lograte A:' int2str(A_lograte) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.8600    0.2000    0.0400]);
        UIsetupInfo.rollPIDFA = uicontrol(PTfig2,'style','text','string',[char(string(rollPIDF_A(1))) ':' char(string(rollPIDF_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.830    0.2000    0.0400]);
        UIsetupInfo.pitchPIDFA = uicontrol(PTfig2,'style','text','string',[char(string(pitchPIDF_A(1))) ':' char(string(pitchPIDF_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.800    0.2000    0.0400]);
        UIsetupInfo.yawPIDFA = uicontrol(PTfig2,'style','text','string',[char(string(yawPIDF_A(1))) ':' char(string(yawPIDF_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.770    0.2000    0.0400]);
        UIsetupInfo.rc_ratesA = uicontrol(PTfig2,'style','text','string',[char(string(rc_rates_A(1))) ':' char(string(rc_rates_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.740    0.2000    0.0400]);
        UIsetupInfo.rc_expoA = uicontrol(PTfig2,'style','text','string',[char(string(rc_expo_A(1))) ':' char(string(rc_expo_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.710    0.2000    0.0400]);
        UIsetupInfo.Super_ratesA = uicontrol(PTfig2,'style','text','string',['Super rates:' char(string(Super_rates_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.680    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass_hzA = uicontrol(PTfig2,'style','text','string',[char(string(gyro_lowpass_hz_A(1))) ':' char(string(gyro_lowpass_hz_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.650    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass2_hzA = uicontrol(PTfig2,'style','text','string',[char(string(gyro_lowpass2_hz_A(1))) ':' char(string(gyro_lowpass2_hz_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.620    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf_hzA = uicontrol(PTfig2,'style','text','string',[char(string(dterm_lpf_hz_A(1))) ':' char(string(dterm_lpf_hz_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.5900    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf2_hzA = uicontrol(PTfig2,'style','text','string',[char(string(dterm_lpf2_hz_A(1))) ':' char(string(dterm_lpf2_hz_A(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.5600    0.2000    0.0400]);
        UIsetupInfo.AphasedelayText = uicontrol(PTfig2,'style','text','string',['phase delay A:' num2str(PhaseDelay_A+PhaseDelay2_A) 'ms'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.530    0.2000    0.0400]);
    else
        UIsetupInfo.fnameAText = uicontrol(PTfig2,'style','text','string',['A:' filenameA],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.950    0.2000    0.0400]);
        UIsetupInfo.Firmware_revisionA = uicontrol(PTfig2,'style','text','string',[Firmware_revision_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.920    0.200    0.0500]);
        UIsetupInfo.looptimeA = uicontrol(PTfig2,'style','text','string',['looptime A:' int2str(A_looptime/1000) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.8900    0.2000    0.0400]);
        UIsetupInfo.frameIntervalPDenomA = uicontrol(PTfig2,'style','text','string',['lograte A:' int2str(A_lograte) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.8600    0.2000    0.0400]);
        UIsetupInfo.rollPIDFA = uicontrol(PTfig2,'style','text','string',['rollPIDF_A:' rollPIDF_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.830    0.2000    0.0400]);
        UIsetupInfo.pitchPIDFA = uicontrol(PTfig2,'style','text','string',['pitchPIDF_A:' pitchPIDF_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.800    0.2000    0.0400]);
        UIsetupInfo.yawPIDFA = uicontrol(PTfig2,'style','text','string',['yawPIDF_A:' yawPIDF_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.770    0.2000    0.0400]);
        UIsetupInfo.rc_ratesA = uicontrol(PTfig2,'style','text','string',['rc_rates_A:' rc_rates_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.740    0.2000    0.0400]);
        UIsetupInfo.rc_expoA = uicontrol(PTfig2,'style','text','string',['rc_expo_A:' rc_expo_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.710    0.2000    0.0400]);
        UIsetupInfo.Super_ratesA = uicontrol(PTfig2,'style','text','string',['Super rates:' Super_rates_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.680    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass_hzA = uicontrol(PTfig2,'style','text','string',['gyro_lowpass_hz_A:' gyro_lowpass_hz_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.650    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass2_hzA = uicontrol(PTfig2,'style','text','string',['gyro_lowpass2_hz_A:' gyro_lowpass2_hz_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.620    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf_hzA = uicontrol(PTfig2,'style','text','string',['dterm_lpf_hz_A:' dterm_lpf_hz_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.5900    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf2_hzA = uicontrol(PTfig2,'style','text','string',['dterm_lpf2_hz_A:' dterm_lpf2_hz_A],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.5600    0.2000    0.0400]);
        UIsetupInfo.AphasedelayText = uicontrol(PTfig2,'style','text','string',['phase delay A:' num2str(PhaseDelay_A+PhaseDelay2_A) 'ms'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.530    0.2000    0.0400]);      
    end
end

if ~isempty(filenameB)
    if ~dataB.BBfileFlag
        UIsetupInfo.fnameBText = uicontrol(PTfig2,'style','text','string',['B:' filenameB],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.490    0.2000    0.0400]);
        UIsetupInfo.Firmware_revisionB = uicontrol(PTfig2,'style','text','string',[Firmware_revision_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.460    0.2000    0.0500]);
        UIsetupInfo.looptimeB = uicontrol(PTfig2,'style','text','string',['looptime B:' int2str(B_looptime/1000) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.430    0.2000    0.0400]);
        UIsetupInfo.frameIntervalPDenomB = uicontrol(PTfig2,'style','text','string',['lograte B:' int2str(B_lograte) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.400    0.2000    0.0400]);
        UIsetupInfo.rollPIDFB = uicontrol(PTfig2,'style','text','string',[char(string(rollPIDF_B(1))) ':' char(string(rollPIDF_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.3700    0.2000    0.0400]);
        UIsetupInfo.pitchPIDFB = uicontrol(PTfig2,'style','text','string',[char(string(pitchPIDF_B(1))) ':' char(string(pitchPIDF_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.3400    0.2000    0.0400]);
        UIsetupInfo.yawPIDFB = uicontrol(PTfig2,'style','text','string',[char(string(yawPIDF_B(1))) ':' char(string(yawPIDF_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.3100    0.2000    0.0400]);
        UIsetupInfo.rc_ratesB = uicontrol(PTfig2,'style','text','string',[char(string(rc_rates_B(1))) ':' char(string(rc_rates_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.2800    0.2000    0.0400]);
        UIsetupInfo.rc_expoB = uicontrol(PTfig2,'style','text','string',[char(string(rc_expo_B(1))) ':' char(string(rc_expo_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.250    0.2000    0.0400]);
        UIsetupInfo.Super_ratesB = uicontrol(PTfig2,'style','text','string',['Super rates:' char(string(Super_rates_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.220    0.200    0.0400]);
        UIsetupInfo.gyro_lowpass_hzB = uicontrol(PTfig2,'style','text','string',[char(string(gyro_lowpass_hz_B(1))) ':' char(string(gyro_lowpass_hz_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.1900    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass2_hzB = uicontrol(PTfig2,'style','text','string',[char(string(gyro_lowpass2_hz_B(1))) ':' char(string(gyro_lowpass2_hz_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.1600    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf_hzB = uicontrol(PTfig2,'style','text','string',[char(string(dterm_lpf_hz_B(1))) ':' char(string(dterm_lpf_hz_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.130    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf2_hzB = uicontrol(PTfig2,'style','text','string',[char(string(dterm_lpf2_hz_B(1))) ':' char(string(dterm_lpf2_hz_B(2)))],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.10    0.2000    0.0400]);
        UIsetupInfo.BphasedelayText = uicontrol(PTfig2,'style','text','string',['phase delay B:' num2str(PhaseDelay_B+PhaseDelay2_B) 'ms'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.0700    0.2000    0.0400]);
    else
        UIsetupInfo.fnameBText = uicontrol(PTfig2,'style','text','string',['B:' filenameB],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805     0.490    0.2000    0.0400]);
        UIsetupInfo.Firmware_revisionB = uicontrol(PTfig2,'style','text','string',[Firmware_revision_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.460    0.200    0.0500]);
        UIsetupInfo.looptimeB = uicontrol(PTfig2,'style','text','string',['looptime B:' int2str(B_looptime/1000) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.4300    0.2000    0.0400]);
        UIsetupInfo.frameIntervalPDenomB = uicontrol(PTfig2,'style','text','string',['lograte B:' int2str(B_lograte) 'k'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.4000    0.2000    0.0400]);
        UIsetupInfo.rollPIDFB = uicontrol(PTfig2,'style','text','string',['rollPIDF_B:' rollPIDF_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.370    0.2000    0.0400]);
        UIsetupInfo.pitchPIDFB = uicontrol(PTfig2,'style','text','string',['pitchPIDF_B:' pitchPIDF_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.340    0.2000    0.0400]);
        UIsetupInfo.yawPIDFB = uicontrol(PTfig2,'style','text','string',['yawPIDF_B:' yawPIDF_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.310    0.2000    0.0400]);
        UIsetupInfo.rc_ratesB = uicontrol(PTfig2,'style','text','string',['rc_rates_B:' rc_rates_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.280    0.2000    0.0400]);
        UIsetupInfo.rc_expoB = uicontrol(PTfig2,'style','text','string',['rc_expo_B:' rc_expo_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.250    0.2000    0.0400]);
        UIsetupInfo.Super_ratesB = uicontrol(PTfig2,'style','text','string',['Super rates:' Super_rates_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.220    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass_hzB = uicontrol(PTfig2,'style','text','string',['gyro_lowpass_hz_B:' gyro_lowpass_hz_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.190    0.2000    0.0400]);
        UIsetupInfo.gyro_lowpass2_hzB = uicontrol(PTfig2,'style','text','string',['gyro_lowpass2_hz_B:' gyro_lowpass2_hz_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.160    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf_hzB = uicontrol(PTfig2,'style','text','string',['dterm_lpf_hz_B:' dterm_lpf_hz_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.1300    0.2000    0.0400]);
        UIsetupInfo.dterm_lpf2_hzB = uicontrol(PTfig2,'style','text','string',['dterm_lpf2_hz_B:' dterm_lpf2_hz_B],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.1000    0.2000    0.0400]);
        UIsetupInfo.BphasedelayText = uicontrol(PTfig2,'style','text','string',['phase delay B:' num2str(PhaseDelay_B+PhaseDelay2_B) 'ms'],'fontsize',fontsz-2,'units','normalized','outerposition',[0.805    0.070    0.2000    0.0400]);      
    end
end

%% if expanded subplot in figure(1), we want to plot it same here
if guiHandles.PlotSelect.Value==1
    figure(1)
    if expandON==1;
        expandaxis=axis; 
    else % otherwise, plot as usual
        if ~isempty(filenameA)
            subplot('position',posInfo.linepos1); v1=axis;
            subplot('position',posInfo.linepos2); v2=axis;
            subplot('position',posInfo.linepos3); v3=axis;
        end
        if ~isempty(filenameB)
            subplot('position',posInfo.linepos4); v4=axis;
            subplot('position',posInfo.linepos5); v5=axis;
            subplot('position',posInfo.linepos6); v6=axis;
        end
    end    
end

% main + spec 1 %%%%% !!not identical to PTplotRaw
figure(2)

if guiHandles.PlotSelect.Value==1
    if ~expandON
        if ~isempty(filenameA)
        
            subplot('position',posInfo.linepos1);
            cla

            xmax=max(((tta/1000)/1000)); 
            ymax= maxDegsec*2;

            h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA ]);
            set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(1,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(1,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(1,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(1,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((tta/1000)/1000, DATmainA.DtermRaw(1,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((tta/1000)/1000, DATmainA.DtermFilt(1,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(1,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(1,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(1,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(1,:));hold on;set(h,'color', [line.col9],'linewidth',1), end

            h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)

            h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
            set(h,'linewidth',.1)
            h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
            set(h,'linewidth',.1)

           axis(v1)

            box on
            T=text(5, -maxDegsec*1.5, ['% throttle']);
            set(T, 'FontSize',fontsz,'Color',[.2 .2 .2])    
            % T=text(5, maxDegsec*1.4, ['max rate = ' int2str(maxDegsec) ' deg/s ' ]);
            % set(T, 'FontSize',fontsz)
           % h=title('raw PID error');
        %    set(h,'fontsize',fontsz)
            ylabel('Roll ^o/s');
            set(gca,'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[posInfo.linepos1]);
  
            subplot('position',posInfo.linepos2)
            cla
            xmax=max(((tta/1000)/1000)); 

             h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA ]);
            set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(2,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(2,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(2,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(2,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((tta/1000)/1000, DATmainA.DtermRaw(2,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((tta/1000)/1000, DATmainA.DtermFilt(2,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(2,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(2,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(2,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(2,:));hold on;set(h,'color', [line.col9],'linewidth',1), end

            h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)

            h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
            set(h,'linewidth',.1)
            h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
            set(h,'linewidth',.1)

            axis(v2)

            box on
            T=text(5, -maxDegsec*1.5, ['% throttle']);
            set(T, 'FontSize',fontsz,'Color',[.2 .2 .2]) 
            ylabel('Pitch ^o/s');
            set(gca,'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[posInfo.linepos2]);

            subplot('position',posInfo.linepos3)
            cla
            xmax=max(((tta/1000)/1000)); 

             h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA]);
            set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(3,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(3,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(3,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(3,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(3,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(3,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(3,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(3,:));hold on;set(h,'color', [line.col9],'linewidth',1), end

            h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)

            h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
            set(h,'linewidth',.1)
            h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
            set(h,'linewidth',.1)

            axis(v3)

            T=text(5, -maxDegsec*1.5, ['% throttle']);
            set(T, 'FontSize',fontsz,'Color',[.2 .2 .2]) 
            ylabel('Yaw ^o/s');
            if isempty(filenameB)
                xlabel('time (s)');
            else
                xlabel('');
            end
            set(gca,'fontsize',fontsz,'tickdir','out','xminortick','on','yminortick','on','position',[posInfo.linepos3]);
            box on
        end
        % T=text(5, maxDegsec*1.4, ['max yaw rate = ' int2str(maxDegsec) ' deg/s ' ]);
        % set(T, 'FontSize',fontsz)

        if ~isempty(filenameB)

            subplot('position',posInfo.linepos4)
            cla
            xmax=max(((ttb/1000)/1000)); 
            ymax= maxDegsec*2;

            h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
            set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(1,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(1,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(1,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(1,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((ttb/1000)/1000, DATmainB.DtermRaw(1,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((ttb/1000)/1000, DATmainB.DtermFilt(1,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(1,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(1,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(1,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(1,:));hold on;set(h,'color', [line.col9],'linewidth',1), end

            h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
            set(h,'linewidth',.1)
            h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
            set(h,'linewidth',.1)

            axis(v4)

            T=text(5, -maxDegsec*1.5, ['% throttle']);
            set(T, 'FontSize',fontsz,'Color',[.2 .2 .2])   
            % T=text(5, maxDegsec*1.4, ['max roll rate = ' int2str(maxDegsec) ' deg/s ' ]);
            % set(T, 'FontSize',fontsz)
            ylabel('Roll ^o/s');
            set(gca,'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[posInfo.linepos4]);
            box on

            subplot('position',posInfo.linepos5)
            cla
            xmax=max(((ttb/1000)/1000)); 

            h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
            set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(2,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(2,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(2,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(2,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((ttb/1000)/1000, DATmainB.DtermRaw(2,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((ttb/1000)/1000, DATmainB.DtermFilt(2,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(2,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(2,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(2,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(2,:));hold on;set(h,'color', [line.col9],'linewidth',1), end


            h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
            set(h,'linewidth',.1)
            h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
            set(h,'linewidth',.1)

            axis(v5)

            T=text(5, -maxDegsec*1.5, ['% throttle']);
            set(T, 'FontSize',fontsz,'Color',[.2 .2 .2]) 
            box on
            ylabel('Pitch ^o/s');
            set(gca,'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[posInfo.linepos5]);

            subplot('position',posInfo.linepos6)
            cla
            xmax=max(((ttb/1000)/1000)); 

            h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
            set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
            hold on
             if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(3,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(3,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(3,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(3,:));hold on;set(h,'color', [line.col3],'linewidth',1), end       
            if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(3,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(3,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(3,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(3,:));hold on;set(h,'color', [line.col9],'linewidth',1), end

            h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
            set(h,'linewidth',.1)
            h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
            set(h,'linewidth',.1)

            axis(v6)

            T=text(5, -maxDegsec*1.5, ['% throttle']);
            set(T, 'FontSize',fontsz,'Color',[.2 .2 .2]) 
            box on
            %T=text(5, maxDegsec*1.8, 'yaw');
            %set(T, 'FontSize',fontsz)
            ylabel('Yaw ^o/s');
            xlabel('time (s)');
            set(gca,'fontsize',fontsz,'tickdir','out','xminortick','on','yminortick','on','position',[posInfo.linepos6]);
        end
    else
        %%%%% expandON==1
        subplot('position',expand_sz)
        if ~isempty(hexpand1)   
            hold on
            h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA ]);
            set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(1,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(1,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(1,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(1,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((tta/1000)/1000, DATmainA.DtermRaw(1,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((tta/1000)/1000, DATmainA.DtermFilt(1,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(1,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(1,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(1,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(1,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
             h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            hexpand1=[];
        end
        
        if ~isempty(hexpand2)   
            h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA ]);
            set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(2,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(2,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(2,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(2,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((tta/1000)/1000, DATmainA.DtermRaw(2,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((tta/1000)/1000, DATmainA.DtermFilt(2,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(2,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(2,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(2,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(2,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
             h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            hexpand2=[];
        end
        
        if ~isempty(hexpand3)  
            h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA ]);
            set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(3,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(3,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(3,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(3,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(3,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(3,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(3,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(3,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
             h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            hexpand3=[];
        end
        
        if ~isempty(hexpand4)   
            h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
            set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(1,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(1,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(1,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(1,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((ttb/1000)/1000, DATmainB.DtermRaw(1,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((ttb/1000)/1000, DATmainB.DtermFilt(1,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(1,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(1,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(1,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(1,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
            h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            hexpand4=[];
        end
        
        if ~isempty(hexpand5)   
            h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
            set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(2,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(2,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(2,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(2,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox4.Value, h=plot((ttb/1000)/1000, DATmainB.DtermRaw(2,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
            if guiHandles.checkbox5.Value, h=plot((ttb/1000)/1000, DATmainB.DtermFilt(2,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
            if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(2,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(2,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(2,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(2,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
            h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            hexpand5=[];
        end
        
        if ~isempty(hexpand6)  
            h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
            set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
            hold on
            if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(3,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
            if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(3,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
            if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(3,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
            if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(3,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
            if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(3,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
            if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(3,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
            if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(3,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
            if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(3,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
            h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
            h.BaseLine.BaseValue=-(maxDegsec*2);
            set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
            hexpand6=[];
        end
        
        set(gca,'fontsize',fontsz,'tickdir','out','xminortick','on','yminortick','on','position',[expand_sz]);
        axis(expandaxis)
        
        expandON=0;
    end
end
 

%% spec only 2
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  SPT 1  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(filenameA)  
    try
  
    xticks=[1 size(ampmatR_A,1)/5:size(ampmatR_A,1)/5:size(ampmatR_A,1)];
    
    h1=subplot('position',posInfo.Spec1PosA1);cla
    imagesc(flipud(ampmatR_A'))
    % color maps
    if guiHandles.ColormapSelect.Value<12
        colormap(char(guiHandles.ColormapSelect.String(guiHandles.ColormapSelect.Value)))
    end
    % user defined colormaps
    if guiHandles.ColormapSelect.Value==12, colormap(parulaMod); end
    % more perceptually linear, gamma corrected
    if guiHandles.ColormapSelect.Value==13, colormap(linearREDcmap); end 
    if guiHandles.ColormapSelect.Value==14, colormap(linearGREYcmap); end
    
    if guiHandles.Sub100HzCheck1.Value
        if A_lograte<2, 
            yticks=[size(ampmatR_A,2)-size(ampmatR_A,2)/5:size(ampmatR_A,2)/25:size(ampmatR_A,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A,2)-size(ampmatR_A,2)/5 size(ampmatR_A,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
%         h=text(35,97 ,'commanded motion'); set(h,'color','r')
%             h=text(35,83 ,'uncommanded motion');set(h,'color','y')
        else
            yticks=[size(ampmatR_A,2)-size(ampmatR_A,2)/10:size(ampmatR_A,2)/50:size(ampmatR_A,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A,2)-size(ampmatR_A,2)/10 size(ampmatR_A,2)])  
            hold on;plot([0 100],[197 197],'r--')
              
%                h=text(35,197 ,'commanded motion'); set(h,'color','r')
%             h=text(35,183 ,'uncommanded motion');set(h,'color','y')
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
    else
        yticks=[1:(size(ampmatR_A,2))/10:size(ampmatR_A,2) size(ampmatR_A,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[1 size(ampmatR_A,2)])
        if A_lograte<2, set(gca,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
    end 
    % xlabel('% throttle')
    
    ylabel('freq Hz')
     
    if guiHandles.Spec1Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor1'); end
    if guiHandles.Spec1Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor3'); end
    if guiHandles.Spec1Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'roll'); end
    
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end
    
    h=title(['A: ' char(guiHandles.Spec1Select.String(guiHandles.Spec1Select.Value))]);
    set(h,'fontsize',fontsz)

    catch
    end
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat 

    try
        
    h1=subplot('position',posInfo.Spec1PosA2);cla
    imagesc(flipud(ampmatP_A'))
   if guiHandles.Sub100HzCheck1.Value
        if A_lograte<2, 
            yticks=[size(ampmatP_A,2)-size(ampmatP_A,2)/5:size(ampmatP_A,2)/25:size(ampmatP_A,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A,2)-size(ampmatP_A,2)/5 size(ampmatP_A,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
        else
            yticks=[size(ampmatP_A,2)-size(ampmatP_A,2)/10:size(ampmatP_A,2)/50:size(ampmatP_A,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A,2)-size(ampmatP_A,2)/10 size(ampmatP_A,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');

   else
        yticks=[1:(size(ampmatP_A,2))/10:size(ampmatP_A,2) size(ampmatP_A,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if A_lograte<2, set(gca,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
   end
    ylabel('freq Hz')
    
    if guiHandles.Spec1Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor2'); end
    if guiHandles.Spec1Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor4'); end
    if guiHandles.Spec1Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'pitch'); end
        set(h,'Color',[1 1 1],'fontsize',fontsz)
         grid on
        ax = gca;
        ax.GridColor = [1 1 1]; 
        if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
            ax.GridColor = [0 0 0]; % black on white background
            set(h,'Color',[0 0 0],'fontsize',fontsz)
        end
    
    catch
    end
    
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
    
    try
        
    if guiHandles.Spec1Select.Value~=8 & guiHandles.Spec1Select.Value~=9 & guiHandles.Spec1Select.Value~=10 & guiHandles.Spec1Select.Value~=11

        h1=subplot('position',posInfo.Spec1PosA3);cla
        imagesc(flipud(ampmatY_A'))
       if guiHandles.Sub100HzCheck1.Value
            if A_lograte<2, 
                yticks=[size(ampmatY_A,2)-size(ampmatY_A,2)/5:size(ampmatY_A,2)/25:size(ampmatY_A,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A,2)-size(ampmatY_A,2)/5 size(ampmatY_A,2)]) 
                hold on;plot([0 100],[97 97],'r--')
                  
            else
                yticks=[size(ampmatY_A,2)-size(ampmatY_A,2)/10:size(ampmatY_A,2)/50:size(ampmatY_A,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A,2)-size(ampmatY_A,2)/10 size(ampmatY_A,2)])  
                hold on;plot([0 100],[197 197],'r--')
            
            end  
            set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
      
       else
           yticks=[1:(size(ampmatY_A,2))/10:size(ampmatY_A,2) size(ampmatY_A,2)];
            set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if A_lograte<2, set(gca,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
       end  
        if isempty(filenameB) | guiHandles.PlotSelect.Value==2,
            set(gca,'xticklabels',{0 20 40 60 80 100 })
            xlabel('% throttle')
        else
            set(gca,'xticklabels',{})
            xlabel('')
        end
        ylabel('freq Hz')
       
        h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'yaw');
        set(h,'Color',[1 1 1],'fontsize',fontsz) 
         grid on
        ax = gca;
        ax.GridColor = [1 1 1]; 
        if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
            ax.GridColor = [0 0 0]; % black on white background
            set(h,'Color',[0 0 0],'fontsize',fontsz)
        end
    end
     if guiHandles.Spec1Select.Value==8 | guiHandles.Spec1Select.Value==9 | guiHandles.Spec1Select.Value==10 | guiHandles.Spec1Select.Value==11
        h=subplot('position',Spec1PosA3);
        set(gca,'xticklabels',{})
        xlabel('')
        delete(h)
        subplot('position',Spec1PosA2);
        set(gca,'xticklabels',{'0','20','40','60','80','100' })
        xlabel('% throttle')
     end 
    catch
    end
     
     %%%%%%%%%%%%%%%%%%%
    % color bar for spec1 at the top 
    subplot('position',posInfo.Spec1PosA1)
    hCbar1= colorbar('NorthOutside');
    set(hCbar1,'Position', [hCbar1pos])
    %%%%%%%%%%%%%%%%%%%
end

if ~isempty(filenameB)   
    try
   
     clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
   
    xticks=[1 size(ampmatR_B,1)/5:size(ampmatR_B,1)/5:size(ampmatR_B,1)];

    h1=subplot('position',posInfo.Spec1PosB1);cla
    imagesc(flipud(ampmatR_B'))
   if guiHandles.Sub100HzCheck1.Value
        if B_lograte<2, 
            yticks=[size(ampmatR_B,2)-size(ampmatR_B,2)/5:size(ampmatR_B,2)/25:size(ampmatR_B,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B,2)-size(ampmatR_B,2)/5 size(ampmatR_B,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
%         h=text(35,97 ,'commanded motion'); set(h,'color','r')
%             h=text(35,83 ,'uncommanded motion');set(h,'color','y')
        else
            yticks=[size(ampmatR_B,2)-size(ampmatR_B,2)/10:size(ampmatR_B,2)/50:size(ampmatR_B,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B,2)-size(ampmatR_B,2)/10 size(ampmatR_B,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
%               h=text(35,197 ,'commanded motion'); set(h,'color','r')
%             h=text(35,183 ,'uncommanded motion');set(h,'color','y')
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
  
   else
        yticks=[1:(size(ampmatR_B,2))/10:size(ampmatR_B,2) size(ampmatR_B,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(gca,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
   end
    %xlabel('% throttle')
    ylabel('freq Hz')
   
    if guiHandles.Spec1Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor1'); end
    if guiHandles.Spec1Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor3'); end
    if guiHandles.Spec1Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'roll'); end
    
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end
    
    h=title(['B: ' char(guiHandles.Spec1Select.String(guiHandles.Spec1Select.Value))]);    
    set(h,'fontsize',fontsz)

    catch
    end
    
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
   
    try
        
    h1=subplot('position',posInfo.Spec1PosB2);cla;
    imagesc(flipud(ampmatP_B'))
   if guiHandles.Sub100HzCheck1.Value
        if B_lograte<2, 
            yticks=[size(ampmatP_B,2)-size(ampmatP_B,2)/5:size(ampmatP_B,2)/25:size(ampmatP_B,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B,2)-size(ampmatP_B,2)/5 size(ampmatP_B,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
        else
            yticks=[size(ampmatP_B,2)-size(ampmatP_B,2)/10:size(ampmatP_B,2)/50:size(ampmatP_B,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B,2)-size(ampmatP_B,2)/10 size(ampmatP_B,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
   
   else
        yticks=[1:(size(ampmatP_B,2))/10:size(ampmatP_B,2) size(ampmatP_B,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(gca,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
   end
   ylabel('freq Hz')
  
    if guiHandles.Spec1Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor2'); end
    if guiHandles.Spec1Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor4'); end
    if guiHandles.Spec1Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'pitch'); end
    
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end

    catch
    end
    
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat

    try
        
    if guiHandles.Spec1Select.Value~=8 & guiHandles.Spec1Select.Value~=9 & guiHandles.Spec1Select.Value~=10 & guiHandles.Spec1Select.Value~=11 
        h1=subplot('position',posInfo.Spec1PosB3);cla
        imagesc(flipud(ampmatY_B'))
       if guiHandles.Sub100HzCheck1.Value
            if B_lograte<2, 
                yticks=[size(ampmatY_B,2)-size(ampmatY_B,2)/5:size(ampmatY_B,2)/25:size(ampmatY_B,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B,2)-size(ampmatY_B,2)/5 size(ampmatY_B,2)]) 
                hold on;plot([0 100],[97 97],'r--')
          
            else
                yticks=[size(ampmatY_B,2)-size(ampmatY_B,2)/10:size(ampmatY_B,2)/50:size(ampmatY_B,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B,2)-size(ampmatY_B,2)/10 size(ampmatY_B,2)])  
                hold on;plot([0 100],[197 197],'r--')
            
            end  
            set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');

       else
            yticks=[1:(size(ampmatY_B,2))/10:size(ampmatY_B,2) size(ampmatY_B,2)];
            set(gca,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if B_lograte<2, set(gca,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
       end
        xlabel('% throttle')
        ylabel('freq Hz')
        
        h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'yaw');
        set(h,'Color',[1 1 1],'fontsize',fontsz)
        grid on
        ax = gca;
        ax.GridColor = [1 1 1]; 
        if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
            ax.GridColor = [0 0 0]; % black on white background
            set(h,'Color',[0 0 0],'fontsize',fontsz)
        end
    
    end
    if guiHandles.Spec1Select.Value==8 | guiHandles.Spec1Select.Value==9 | guiHandles.Spec1Select.Value==10 | guiHandles.Spec1Select.Value==11
        h=subplot('position',Spec1PosB3);
        set(gca,'xticklabels',{})
        xlabel('')
        delete(h)
        subplot('position',Spec1PosB2);
        set(gca,'xticklabels',{'0','20','40','60','80','100' })
        xlabel('% throttle')
    end 
    catch
    end
    %show color map if in spec only plots
    if guiHandles.PlotSelect.Value==2
        subplot('position',posInfo.Spec1PosB1)
        hCbar3= colorbar('NorthOutside');
        set(hCbar3,'Position', [hCbar3pos])     
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  SPT 2  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(filenameA)   
    try
     
    clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
     
    xticks=[1 size(ampmatR_A2,1)/5:size(ampmatR_A2,1)/5:size(ampmatR_A2,1)];

    h1=subplot('position',posInfo.Spec2PosA1);cla
    imagesc(flipud(ampmatR_A2'))
    % color maps
    if guiHandles.ColormapSelect.Value<12
        colormap(char(guiHandles.ColormapSelect.String(guiHandles.ColormapSelect.Value)))
    end
    % user defined colormaps
    if guiHandles.ColormapSelect.Value==12, colormap(parulaMod); end
    % more perceptually linear, gamma corrected
    if guiHandles.ColormapSelect.Value==13, colormap(linearREDcmap); end 
    if guiHandles.ColormapSelect.Value==14, colormap(linearGREYcmap); end
    
    if guiHandles.Sub100HzCheck2.Value
        if A_lograte<2, 
            yticks=[size(ampmatR_A2,2)-size(ampmatR_A2,2)/5:size(ampmatR_A2,2)/25:size(ampmatR_A2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A2,2)-size(ampmatR_A2,2)/5 size(ampmatR_A2,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
           
        else
            yticks=[size(ampmatR_A2,2)-size(ampmatR_A2,2)/10:size(ampmatR_A2,2)/50:size(ampmatR_A2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A2,2)-size(ampmatR_A2,2)/10 size(ampmatR_A2,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
            
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');

   else
        yticks=[1:(size(ampmatR_A2,2))/10:size(ampmatR_A2,2) size(ampmatR_A2,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if A_lograte<2, set(gca,'yticklabels',[{}]), end
   end
    %xlabel('% throttle')
  %  ylabel('freq Hz')
   
    if guiHandles.Spec2Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor1'); end
    if guiHandles.Spec2Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor3'); end
    if guiHandles.Spec2Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'roll'); end
    
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end
    
    h=title(['A: ' char(guiHandles.Spec2Select.String(guiHandles.Spec2Select.Value))]);    
    set(h,'fontsize',fontsz)
    
    catch
    end
    
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
  
    try
        
    h1=subplot('position',posInfo.Spec2PosA2);cla
    imagesc(flipud(ampmatP_A2'))
   if guiHandles.Sub100HzCheck2.Value
        if A_lograte<2, 
            yticks=[size(ampmatP_A2,2)-size(ampmatP_A2,2)/5:size(ampmatP_A2,2)/25:size(ampmatP_A2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A2,2)-size(ampmatP_A2,2)/5 size(ampmatP_A2,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
        else
            yticks=[size(ampmatP_A2,2)-size(ampmatP_A2,2)/10:size(ampmatP_A2,2)/50:size(ampmatP_A2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A2,2)-size(ampmatP_A2,2)/10 size(ampmatP_A2,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
    else
        yticks=[1:(size(ampmatP_A2,2))/10:size(ampmatP_A2,2) size(ampmatP_A2,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if A_lograte<2, set(gca,'yticklabels',[{}]), end
   end

  %  ylabel('freq Hz')
  
    if guiHandles.Spec2Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor2'); end
    if guiHandles.Spec2Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor4'); end
    if guiHandles.Spec2Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'pitch'); end
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end
    
    catch
    end

    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
    
    try
        
    if guiHandles.Spec2Select.Value~=8 & guiHandles.Spec2Select.Value~=9 & guiHandles.Spec2Select.Value~=10 & guiHandles.Spec2Select.Value~=11
        h1=subplot('position',posInfo.Spec2PosA3);cla
        imagesc(flipud(ampmatY_A2'))
       if guiHandles.Sub100HzCheck2.Value
            if A_lograte<2, 
                yticks=[size(ampmatY_A2,2)-size(ampmatY_A2,2)/5:size(ampmatY_A2,2)/25:size(ampmatY_A2,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A2,2)-size(ampmatY_A2,2)/5 size(ampmatY_A2,2)]) 
                hold on;plot([0 100],[97 97],'r--')
                  
            else
                yticks=[size(ampmatY_A2,2)-size(ampmatY_A2,2)/10:size(ampmatY_A2,2)/50:size(ampmatY_A2,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A2,2)-size(ampmatY_A2,2)/10 size(ampmatY_A2,2)]) 
                hold on;plot([0 100],[197 197],'r--')
            
            end  
            set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
       else
            yticks=[1:(size(ampmatY_A2,2))/10:size(ampmatY_A2,2) size(ampmatY_A2,2)];
            set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if A_lograte<2, set(gca,'yticklabels',[{}]), end
       end
        if isempty(filenameB) | guiHandles.PlotSelect.Value==2,
            set(gca,'xticklabels',{0 20 40 60 80 100 })
            xlabel('% throttle')
        else
            set(gca,'xticklabels',{})
            xlabel('')
        end
        %ylabel('freq Hz')
     
        h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'yaw');
        set(h,'Color',[1 1 1],'fontsize',fontsz)     
        grid on
        ax = gca;
        ax.GridColor = [1 1 1]; 
        if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
            ax.GridColor = [0 0 0]; % black on white background
            set(h,'Color',[0 0 0],'fontsize',fontsz)
        end
    end
    if guiHandles.Spec2Select.Value==8 | guiHandles.Spec2Select.Value==9 | guiHandles.Spec2Select.Value==10 | guiHandles.Spec2Select.Value==11
        h=subplot('position',Spec2PosA3);
        set(gca,'xticklabels',{})
        xlabel('')
        delete(h)
        subplot('position',Spec2PosA2);
        set(gca,'xticklabels',{'0','20','40','60','80','100' })
        xlabel('% throttle')
    end
    catch
    end
      %%%%%%%%%%%%%%%%%%%
    % color bar for spec2 at the top 
    subplot('position',posInfo.Spec2PosA1)
    hCbar2= colorbar('NorthOutside');
    set(hCbar2,'Position', [hCbar2pos])
    %%%%%%%%%%%%%%%%%%%
    
end

if ~isempty(filenameB) 
    try
    
    clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat

     xticks=[1 size(ampmatR_B2,1)/5:size(ampmatR_B2,1)/5:size(ampmatR_B2,1)];

    h1=subplot('position',posInfo.Spec2PosB1);cla
    imagesc(flipud(ampmatR_B2'))
   if guiHandles.Sub100HzCheck2.Value
        if B_lograte<2, 
            yticks=[size(ampmatR_B2,2)-size(ampmatR_B2,2)/5:size(ampmatR_B2,2)/25:size(ampmatR_B2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B2,2)-size(ampmatR_B2,2)/5 size(ampmatR_B2,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
        else
            yticks=[size(ampmatR_B2,2)-size(ampmatR_B2,2)/10:size(ampmatR_B2,2)/50:size(ampmatR_B2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B2,2)-size(ampmatR_B2,2)/10 size(ampmatR_B2,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');

   else
       yticks=[1:(size(ampmatR_B2,2))/10:size(ampmatR_B2,2) size(ampmatR_B2,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(gca,'yticklabels',[{}]), end
   end
    %xlabel('% throttle')
    %ylabel('freq Hz')
    if guiHandles.Spec2Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor1'); end
    if guiHandles.Spec2Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor3'); end
    if guiHandles.Spec2Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'roll'); end
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end
    
    h=title(['B: ' char(guiHandles.Spec2Select.String(guiHandles.Spec2Select.Value))]);    
    set(h,'fontsize',fontsz)

    catch
    end
    
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
  
    try
        
    h1=subplot('position',posInfo.Spec2PosB2);cla
    imagesc(flipud(ampmatP_B2'))
   if guiHandles.Sub100HzCheck2.Value
        if B_lograte<2, 
            yticks=[size(ampmatP_B2,2)-size(ampmatP_B2,2)/5:size(ampmatP_B2,2)/25:size(ampmatP_B2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B2,2)-size(ampmatP_B2,2)/5 size(ampmatP_B2,2)]) 
            hold on;plot([0 100],[97 97],'r--')
          
        else
            yticks=[size(ampmatP_B2,2)-size(ampmatP_B2,2)/10:size(ampmatP_B2,2)/50:size(ampmatP_B2,2)];
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B2,2)-size(ampmatP_B2,2)/10 size(ampmatP_B2,2)]) 
            hold on;plot([0 100],[197 197],'r--')
            
        end  
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');

   else
        yticks=[1:(size(ampmatP_B2,2))/10:size(ampmatP_B2,2) size(ampmatP_B2,2)];
        set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(gca,'yticklabels',[{}]), end
   end
   % ylabel('freq Hz')
  
   if guiHandles.Spec2Select.Value==10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor2'); end
    if guiHandles.Spec2Select.Value==11, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'motor4'); end
    if guiHandles.Spec2Select.Value<10, h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'pitch'); end
    set(h,'Color',[1 1 1],'fontsize',fontsz)
    grid on
    ax = gca;
    ax.GridColor = [1 1 1]; 
    if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
        ax.GridColor = [0 0 0]; % black on white background
        set(h,'Color',[0 0 0],'fontsize',fontsz)
    end

    catch
    end

    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat

    try
        
    if guiHandles.Spec2Select.Value~=8 & guiHandles.Spec2Select.Value~=9 & guiHandles.Spec2Select.Value~=10 & guiHandles.Spec2Select.Value~=11
         h1=subplot('position',posInfo.Spec2PosB3);cla
        imagesc(flipud(ampmatY_B2'))
       if guiHandles.Sub100HzCheck2.Value
            if B_lograte<2, 
                yticks=[size(ampmatY_B2,2)-size(ampmatY_B2,2)/5:size(ampmatY_B2,2)/25:size(ampmatY_B2,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B2,2)-size(ampmatY_B2,2)/5 size(ampmatY_B2,2)]) 
                hold on;plot([0 100],[97 97],'r--')
          
            else
                yticks=[size(ampmatY_B2,2)-size(ampmatY_B2,2)/10:size(ampmatY_B2,2)/50:size(ampmatY_B2,2)];
                set(gca,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B2,2)-size(ampmatY_B2,2)/10 size(ampmatY_B2,2)])  
                hold on;plot([0 100],[197 197],'r--')
            
            end  
            set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');
 
       else
            yticks=[1:(size(ampmatY_B2,2))/10:size(ampmatY_B2,2) size(ampmatY_B2,2)];
            set(gca,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');
            set(gca,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if B_lograte<2, set(gca,'yticklabels',[{}]), end
       end
        xlabel('% throttle')      
        %ylabel('freq Hz') 
        h=text(xticks(1)+1,yticks(1)+(mode(diff(yticks))/2),'yaw');
        set(h,'Color',[1 1 1],'fontsize',fontsz)
        grid on
        ax = gca;
        ax.GridColor = [1 1 1]; 
        if guiHandles.ColormapSelect.Value==13 | guiHandles.ColormapSelect.Value==14
            ax.GridColor = [0 0 0]; % black on white background
            set(h,'Color',[0 0 0],'fontsize',fontsz)
        end    
    end
    if guiHandles.Spec2Select.Value==8 | guiHandles.Spec2Select.Value==9 | guiHandles.Spec2Select.Value==10 | guiHandles.Spec2Select.Value==11
        h=subplot('position',Spec2PosB3);
        set(gca,'xticklabels',{})
        xlabel('')
        delete(h)
        subplot('position',Spec2PosB2);
        set(gca,'xticklabels',{'0','20','40','60','80','100' })
        xlabel('% throttle')
    end
    catch
    end
     %show color map if in spec only plots
    if guiHandles.PlotSelect.Value==2
        subplot('position',posInfo.Spec2PosB1)
        hCbar4= colorbar('NorthOutside');
        set(hCbar4,'Position', [hCbar4pos])     
    end
end

%% step resp + spec  3
if guiHandles.PlotSelect.Value==3
    %delete other panels
    delete(subplot(3,3,1));
    delete(subplot(3,3,4));
    delete(subplot(3,3,7));
    delete(subplot(3,6,1));
    delete(subplot(3,6,7));
    delete(subplot(3,6,13));
    set(guiHandles.checkbox0,'visible','off')
    set(guiHandles.checkbox1,'visible','off')
    set(guiHandles.checkbox2,'visible','off')
    set(guiHandles.checkbox3,'visible','off')
    set(guiHandles.checkbox4,'visible','off')
    set(guiHandles.checkbox5,'visible','off')
    set(guiHandles.checkbox6,'visible','off')
    set(guiHandles.checkbox7,'visible','off')
    set(guiHandles.checkbox8,'visible','off')
    set(guiHandles.checkbox9,'visible','off')

    posInfo.step1=[0.14 0.84 0.160 0.118];
    posInfo.step2=[0.14 0.71 0.160 0.118];
    posInfo.step3=[0.14 0.58 0.160 0.118];
    posInfo.step4=[0.14 0.38 0.160 0.118];
    posInfo.step5=[0.14 0.25 0.160 0.118];
    posInfo.step6=[0.14 0.12 0.160 0.108];

    lowerLim=.7;
    upperLim=1.4;
    rcDecelerationThresh=400;

    %%%%%%%%%%%%% step resp A %%%%%%%%%%%%%
    if ~isempty(filenameA)
        h2=subplot('position',posInfo.step1);cla

        samp_timeA=round(mean(diff(tta)));
        clear stepnfo resp_segments_norm 
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpA.RCRate(1,:), DATtmpA.PIDerr(1,:), rcDecelerationThresh, samp_timeA, lowerLim, upperLim); % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
           h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
        set(h, 'color',[colorA],'linewidth',2)
    
        h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
        h=text(420, 1.35, ['PIDF: ' char(string(rollPIDF_A(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.85,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .6,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .35,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)  
        h=text(420, .1,   ['ResponseDelay: ' num2str(ResponseDelayR_A)]);set(h,'fontsize',fontsz) 
        catch
            hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        h=text(5,1.25,['roll']);
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        axis([0 400 0 1.4])

        h2=subplot('position',posInfo.step2);cla
       
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpA.RCRate(2,:), DATtmpA.PIDerr(2,:), rcDecelerationThresh, samp_timeA, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on
        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
        set(h, 'color',[colorA],'linewidth',2)
    
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
        h=text(420, 1.3, ['PIDF: ' char(string(pitchPIDF_A(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.05, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.8,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .55,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .3,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz) 
        h=text(420, .05,   ['ResponseDelay: ' num2str(ResponseDelayP_A)]);set(h,'fontsize',fontsz) 
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['pitch']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
   
        h2=subplot('position',posInfo.step3);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpA.RCRate(3,:), DATtmpA.PIDerr(3,:), rcDecelerationThresh, samp_timeA, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on
        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end

        set(h, 'color',[colorA],'linewidth',2)
         h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
         h=text(420, 1.25, ['PIDF: ' char(string(yawPIDF_A(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.75,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .5,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .25,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)
        h=text(420, 0,   ['ResponseDelay: ' num2str(ResponseDelayY_A)]);set(h,'fontsize',fontsz) 
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        h=xlabel('time (ms)');
        set(h,'fontsize',fontsz)
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['yaw']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
       
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        ylabel({'Response'; 'Strength'})
        xlabel('time (ms)')
        axis([0 400 0 1.4])
    end

    %%%%%%%%%%%%% step resp B %%%%%%%%%%%%%
    if ~isempty(filenameB)
        samp_timeB=round(mean(diff(ttb)));

        h2=subplot('position',posInfo.step4);cla
        clear stepnfo resp_segments_norm
        try 
        [resp_segments_norm, t] = PTstepcalc(DATtmpB.RCRate(1,:), DATtmpB.PIDerr(1,:), rcDecelerationThresh, samp_timeB, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
    
        set(h, 'color',[colorB],'linewidth',2)
         h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
         h=text(420, 1.35, ['PIDF: ' char(string(rollPIDF_B(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.85,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .6,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .35,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)
        h=text(420, .1,   ['ResponseDelay: ' num2str(ResponseDelayR_B)]);set(h,'fontsize',fontsz) 
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['roll ']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])

        h2=subplot('position',posInfo.step5);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpB.RCRate(2,:), DATtmpB.PIDerr(2,:), rcDecelerationThresh, samp_timeB, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
    
        set(h, 'color',[colorB],'linewidth',2)
         h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
         h=text(420, 1.3, ['PIDF: ' char(string(pitchPIDF_B(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.05, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.8,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .55,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .3,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)
        h=text(420, .05,   ['ResponseDelay: ' num2str(ResponseDelayP_B)]);set(h,'fontsize',fontsz)
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['pitch']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
       
        h2=subplot('position',posInfo.step6);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpB.RCRate(3,:), DATtmpB.PIDerr(3,:), rcDecelerationThresh, samp_timeB, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
    
        set(h, 'color',[colorB],'linewidth',2)
        h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
        h=text(420, 1.25, ['PIDF: ' char(string(yawPIDF_B(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.75,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .5,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .25,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz) 
        h=text(420, 0,   ['ResponseDelay: ' num2str(ResponseDelayY_B)]);set(h,'fontsize',fontsz)
        catch
            hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        h=xlabel('time (ms)');
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['yaw']);
        set(h,'fontsize',fontsz)
    
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        h=xlabel('time (ms)');
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
    end
end

%% PIDerr 4
if guiHandles.PlotSelect.Value==4
set(guiHandles.checkbox0,'visible','off')
set(guiHandles.checkbox1,'visible','off')
set(guiHandles.checkbox2,'visible','off')
set(guiHandles.checkbox3,'visible','off')
set(guiHandles.checkbox4,'visible','off')
set(guiHandles.checkbox5,'visible','off')
set(guiHandles.checkbox6,'visible','off')
set(guiHandles.checkbox7,'visible','off')
set(guiHandles.checkbox8,'visible','off')
set(guiHandles.checkbox9,'visible','off')

    h2=subplot(3,3,1);
    cla

    for i=1:10
        try
        thr=(DATtmpA.RCRate(4,:)>((i-1)*10) & DATtmpA.RCRate(4,:)<=(i*10));
        Tst_a_R_m(i)=nanmean(abs(DATtmpA.PIDerr(1,RC_PID_Thresh_A & thr)));
        Tst_a_P_m(i)=nanmean(abs(DATtmpA.PIDerr(2,RC_PID_Thresh_A & thr)));
        Tst_a_Y_m(i)=nanmean(abs(DATtmpA.PIDerr(3,RC_PID_Thresh_A & thr)));
        Tst_a_R_sd(i)=nanstd(abs(DATtmpA.PIDerr(1,RC_PID_Thresh_A & thr))) / sqrt(length(find(thr==1)));
        Tst_a_P_sd(i)=nanstd(abs(DATtmpA.PIDerr(2,RC_PID_Thresh_A & thr))) / sqrt(length(find(thr==1)));
        Tst_a_Y_sd(i)=nanstd(abs(DATtmpA.PIDerr(3,RC_PID_Thresh_A & thr))) / sqrt(length(find(thr==1)));
        catch
        end
        try
        thrb=(DATtmpB.RCRate(4,:)>((i-1)*10) & DATtmpB.RCRate(4,:)<=(i*10));     
        Tst_b_R_m(i)=nanmean(abs(DATtmpB.PIDerr(1,RC_PID_Thresh_B & thrb)));
        Tst_b_P_m(i)=nanmean(abs(DATtmpB.PIDerr(2,RC_PID_Thresh_B & thrb)));
        Tst_b_Y_m(i)=nanmean(abs(DATtmpB.PIDerr(3,RC_PID_Thresh_B & thrb)));
        Tst_b_R_sd(i)=nanstd(abs(DATtmpB.PIDerr(1,RC_PID_Thresh_B & thrb))) / sqrt(length(find(thrb==1)));
        Tst_b_P_sd(i)=nanstd(abs(DATtmpB.PIDerr(2,RC_PID_Thresh_B & thrb))) / sqrt(length(find(thrb==1)));
        Tst_b_Y_sd(i)=nanstd(abs(DATtmpB.PIDerr(3,RC_PID_Thresh_B & thrb))) / sqrt(length(find(thrb==1)));
        catch
        end
    end


    posA=.8:1:9.8;
    posB=1.2:1:10.2;
    try
        h=errorbar([posA],[Tst_a_R_m ], [Tst_a_R_sd ] );hold on
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posA], (Tst_a_R_m));
        set(h, 'facecolor',[colorA],'facealpha',.8,'BarWidth',.4)
    catch
    end
    try
        h=errorbar([posB],[ Tst_b_R_m], [ Tst_b_R_sd] );
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posB], (Tst_b_R_m));
        set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
    catch
    end
    set(h2,'xtick',[0:2:10], 'xticklabel',{'0' '20','40', '60', '80', '100'});
    set(h2,'tickdir','out','xminortick','on','yminortick','on');
    set(h2,'fontsize',fontsz);
    box off
    ylabel(['mean |R error| ^o/s'])

    %xlabel('% throttle ')
    axis([0 11 0 30])
%     h=title('mean |PID error|');
%     set(h,'fontsize',fontsz)


    h2=subplot(3,3,4);
    cla
    try
        h=errorbar([posA],[Tst_a_P_m ], [Tst_a_P_sd ] );hold on
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posA], (Tst_a_P_m));
        set(h, 'facecolor',[colorA],'facealpha',.8,'BarWidth',.4)
    catch
    end
    try
        h=errorbar([posB],[ Tst_b_P_m], [ Tst_b_P_sd] );
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posB], (Tst_b_P_m));
        set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
    catch
    end
    set(h2,'xtick',[0:2:10], 'xticklabel',{'0' '20','40', '60', '80', '100'});
    set(h2,'tickdir','out','xminortick','on','yminortick','on');
    set(h2,'fontsize',fontsz);
    box off
    ylabel(['mean |P error| ^o/s'])

    %xlabel('% throttle ')
    axis([0 11 0 30])

    h2=subplot(3,3,7);
    cla
    try
    h=errorbar([posA],[Tst_a_Y_m ], [Tst_a_Y_sd ] );hold on
    set(h, 'color','k', 'LineStyle','none');
    h=bar([posA], (Tst_a_Y_m));
    set(h, 'facecolor',[colorA],'facealpha',.8,'BarWidth',.4)
    catch
    end
    try
    h=errorbar([posB],[ Tst_b_Y_m], [ Tst_b_Y_sd] );
    set(h, 'color','k', 'LineStyle','none');
    h=bar([posB], (Tst_b_Y_m));
    set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
    catch
    end

    set(h2,'xtick',[0:2:10], 'xticklabel',{'0' '20','40', '60', '80', '100'});
    set(h2,'tickdir','out','xminortick','on','yminortick','on');
    set(h2,'fontsize',fontsz);
    box off
    ylabel(['mean |Y error| ^o/s'])

    xlabel('% throttle ')
    axis([0 11 0 30]) 
      
end


%%
cd(filepath)
cd(saveDirectory)
FigDoesNotExist=1;
n=0;
while FigDoesNotExist,
    n=n+1;
    FigDoesNotExist=isfile([saveDirectory '-' int2str(n) '.png']);
end
figname=[saveDirectory '-' int2str(n) '.png'];
saveas(gcf, figname);

cd(filepath)


else
    guiHandles.PlotSelect.Value=1;
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end

