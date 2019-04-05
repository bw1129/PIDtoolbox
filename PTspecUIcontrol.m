%% PTspecUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(filenameA) || ~isempty(filenameB)
   
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
posInfo.percentMotor=[.09 .955 .06 .04];
posInfo.ColormapSelect=[.16 .955 .06 .04];
posInfo.smooth_select =[.23 .955 .06 .04];

posInfo.checkbox2d=[.30 .955 .06 .04];

posInfo.AphasedelayText=[.65 .976 .32 .022];
posInfo.BphasedelayText=[.65 .954 .32 .022];

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

PTspecfig=figure(2);
set(PTspecfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTspecfig.NumberTitle='off';
PTspecfig.Name= 'PIDtoolbox Spectral Analyses';
PTspecfig.InvertHardcopy='off';
set(PTspecfig,'color',bgcolor);

prop_max_screen=(max([PTspecfig.Position(3) PTspecfig.Position(4)]));
fontsz2=round(screensz_multiplier*prop_max_screen);

dcm_obj2 = datacursormode(PTspecfig);
set(dcm_obj2,'UpdateFcn',@PTdatatip);

specCrtlpanel = uipanel('Title','','FontSize',fontsz2,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.015 .9 .975 .1]);

guiHandlesSpec.computeSpec = uicontrol(PTspecfig,'string','run','fontsize',fontsz2,'units','normalized','outerposition',[posInfo.computeSpec],...
    'callback','PTplotSpec;');
guiHandlesSpec.computeSpec.BackgroundColor=[.3 .9 .3];

guiHandlesSpec.checkbox2d =uicontrol(PTspecfig,'Style','checkbox','String','2-D','fontsize',fontsz2,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkbox2d],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');

guiHandlesSpec.percentMotor = uicontrol(PTspecfig,'Style','popupmenu','string',{'%throttle'; '%motor'},...
    'fontsize',fontsz2,'units','normalized','outerposition', [posInfo.percentMotor],'callback','@selection2;');

guiHandlesSpec.saveFig2 = uicontrol(PTspecfig,'string','save fig','fontsize',fontsz2,'units','normalized','BackgroundColor',[.8 .8 .8],'outerposition',[posInfo.saveFig2],...
    'callback','guiHandlesSpec.saveFig2.FontWeight=''bold'';PTsaveFig;guiHandlesSpec.saveFig2.FontWeight=''normal'';'); 

guiHandlesSpec.Sub100HzCheck{1} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck1],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{2} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck2],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{3} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck3],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');
guiHandlesSpec.Sub100HzCheck{4} =uicontrol(PTspecfig,'Style','checkbox','String','<100Hz','fontsize',fontsz2,...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Sub100HzCheck4],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1;PTplotSpec;');

% create string list for SpecSelect
if A_debugmode==DSHOT_RPM_TELEMETRY % DSHOT_RPM_TELEMETRY
    sA={'NONE','Gyro [A]','PID error [A]','Set point [A]','Pterm [A]','Dterm [A]','Dterm (unfilt) [A]','Motors 1 2 [A]','Motors 3 4 [A]','RPM 1 2 [A]','RPM 3 4 [A]'};
else
    sA={'NONE','Gyro [A]','Gyro (unfilt) [A]','PID error [A]','Set point [A]','Pterm [A]','Dterm [A]','Dterm (unfilt) [A]','Motors 1 2 [A]','Motors 3 4 [A]'};
end
if B_debugmode==DSHOT_RPM_TELEMETRY
    sB={'Gyro [B]','PID error [B]','Set point [B]','Pterm [B]','Dterm [B]','Dterm (unfilt) [B]','Motors 1 2 [B]','Motors 3 4 [B]','RPM 1 2 [B]','RPM 3 4 [B]'};
else
    sB={'Gyro [B]','Gyro (unfilt) [B]','PID error [B]','Set point [B]','Pterm [B]','Dterm [B]','Dterm (unfilt) [B]','Motors 1 2 [B]','Motors 3 4 [B]'};
end
% combine strings
sAB=[sA sB];
    
guiHandlesSpec.SpecSelect{1} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'units','normalized','outerposition', [posInfo.hDropdn1pos],'callback','@selection2;');
guiHandlesSpec.SpecSelect{2} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'units','normalized','outerposition', [posInfo.hDropdn2pos],'callback','@selection2;');
guiHandlesSpec.SpecSelect{3} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'units','normalized','outerposition', [posInfo.hDropdn3pos],'callback','@selection2;');
guiHandlesSpec.SpecSelect{4} = uicontrol(PTspecfig,'Style','popupmenu','string',sAB,...
    'fontsize',fontsz2,'units','normalized','outerposition', [posInfo.hDropdn4pos],'callback','@selection2;');

guiHandlesSpec.SpecSelect{1}.Value=1;
guiHandlesSpec.SpecSelect{2}.Value=1;
guiHandlesSpec.SpecSelect{3}.Value=1;
guiHandlesSpec.SpecSelect{4}.Value=1;

guiHandlesSpec.smoothFactor_select = uicontrol(PTspecfig,'style','popupmenu','string',{'smoothing = 1' 'smoothing = 2' 'smoothing = 3' 'smoothing = 4' 'smoothing = 5'},'fontsize',fontsz2,'units','normalized','outerposition',[posInfo.smooth_select],...
     'callback','@selection2;updateSpec=1;PTplotSpec;');
guiHandlesSpec.smoothFactor_select.Value=3;

guiHandlesSpec.climMax_text = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text]);
guiHandlesSpec.climMax_input = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(1))],'fontsize',fontsz2,'units','normalized','outerposition',[posInfo.climMax_input],...
     'callback','@textinput_call2; climScale(1)=str2num(guiHandlesSpec.climMax_input.String);updateSpec=1;PTplotSpec;');

 guiHandlesSpec.climMax_text2 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text2]);
guiHandlesSpec.climMax_input2 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(2))],'fontsize',fontsz2,'units','normalized','outerposition',[posInfo.climMax_input2],...
     'callback','@textinput_call2; climScale(2)=str2num(guiHandlesSpec.climMax_input2.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.climMax_text3 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text3]);
guiHandlesSpec.climMax_input3 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(3))],'fontsize',fontsz2,'units','normalized','outerposition',[posInfo.climMax_input3],...
     'callback','@textinput_call2; climScale(3)=str2num(guiHandlesSpec.climMax_input3.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.climMax_text4 = uicontrol(PTspecfig,'style','text','string','scale','fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax_text4]);
guiHandlesSpec.climMax_input4 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(4))],'fontsize',fontsz2,'units','normalized','outerposition',[posInfo.climMax_input4],...
     'callback','@textinput_call2; climScale(4)=str2num(guiHandlesSpec.climMax_input4.String);updateSpec=1;PTplotSpec;');
 
 guiHandlesSpec.ColormapSelect = uicontrol(PTspecfig,'Style','popupmenu','string',{'parula','jet','hot','cool','gray','bone','copper','viridis','linearREDcmap','linearGREYcmap'},...
    'fontsize',fontsz2,'units','normalized','outerposition',[posInfo.ColormapSelect],'callback','@selection2;updateSpec=1; PTplotSpec;');
guiHandlesSpec.ColormapSelect.Value=3;% hot 3 viridis 12


%% get estimate of phase delay (computed on roll axis only since it's typically the most active)
% note, this is an estimate, given the many dynamic filter options in BF4.0+
% the reliability of the estimate depend to some degree on the amplitude modulation of the signals 
% (i.e., when there is stick input).
clear sampTime maxlag PhaseDelay_A PhaseDelay2_A 
if A_debugmode==GYRO_SCALED
    try
        sampTime=(mean(diff(tta)));%microsec
        maxlag=int8(round(3000/sampTime)); %~3ms delay
        PhaseDelay_A=finddelay(smooth(DATmainA.debug(1,:),50),smooth(DATmainA.GyroFilt(1,:),50),maxlag) * sampTime / 1000; % both signals smoothed equally, more reliable estimate
        if PhaseDelay_A<.1, PhaseDelay_A=[]; end % when garbage gets through

        PhaseDelay2_A=finddelay(smooth(DATmainA.DtermRaw(1,:),50),smooth(DATmainA.DtermFilt(1,:),50),maxlag) * sampTime / 1000;
        if PhaseDelay2_A<.1, PhaseDelay2_A=[]; end % when garbage gets through
        guiHandlesSpec.AphasedelayText = uicontrol(PTspecfig,'style','text','string',['[A] estimated phase delay (gyro/dterm/total): ' num2str(round(PhaseDelay_A*100)/100) ' / ' num2str(round(PhaseDelay2_A*100)/100) ' / ' num2str(round((PhaseDelay_A+PhaseDelay2_A)*100)/100) 'ms'],'fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText]);
    catch
        guiHandlesSpec.AphasedelayText = uicontrol(PTspecfig,'style','text','string',['[A] unable to estimate phase delay '],'fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText]);
    end
else
        guiHandlesSpec.AphasedelayText = uicontrol(PTspecfig,'style','text','string',['[A] unable to estimate phase delay '],'fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText]);
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

        guiHandlesSpec.BphasedelayText = uicontrol(PTspecfig,'style','text','string',['[B] estimated phase delay (gyro/dterm/total): ' num2str(round(PhaseDelay_B*100)/100) ' / ' num2str(round(PhaseDelay2_B*100)/100) ' / ' num2str(round((PhaseDelay_B+PhaseDelay2_B)*100)/100) 'ms'],'fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.BphasedelayText]);
    catch
        guiHandlesSpec.BphasedelayText = uicontrol(PTspecfig,'style','text','string',['[B] unable to estimate phase delay '],'fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.BphasedelayText]);
    end
else
       guiHandlesSpec.BphasedelayText = uicontrol(PTspecfig,'style','text','string',['[B] unable to estimate phase delay '],'fontsize',fontsz2,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.BphasedelayText]);
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


