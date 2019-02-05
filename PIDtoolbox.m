%% PIDtoolbox - main  

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
executableDir = get_deployed_exec_dir();


PTfig = figure(1);

if ~exist('filenameA','var'), filenameA=[]; end
if ~exist('filenameB','var'), filenameB=[]; end

maxDegsec=1500;
minPIDerror=0;
maxPIDerror=50;
use_randsamp=0;
smp_sze=100;
choose_epoch=0;
epoch1_A=[];
epoch2_A=[];
epoch1_B=[];
epoch2_B=[];
climMultiplier=1;
climMultiplier2=1;
climMaxA=[];
climMaxB=[];
climMaxA2=[];
climMaxB2=[];
waitbarFid=[];
updateSpec=0;

colorA=[.93 .5 .3];
colorB=[.3 .65 .95];

%use_phsCorrErr=0;
flightSpec=0;
screensz = get(0,'ScreenSize');

%set(PTfig, 'Position', [10, 10, screensz(3)*.5, screensz(4)*.5]);
set(PTfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTfig.NumberTitle='off';
PTfig.Name= 'PID toolbox';

pause(.2)% need to wait for figure to open before extracting screen values

screensz_multiplier = sqrt(screensz(3)^2+screensz(4)^2) * .006;
prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);

posInfo.fnameAText = [.8 .96 .2 .04];
posInfo.fnameBText = [.8 .93 .2 .04];
posInfo.fileA=[.81 .89 .085 .04];
posInfo.fileB=[.81 .845 .085 .04];
posInfo.runAll=[.9 .89 .085 .04];
posInfo.refreshcall=[.9 .845 .085 .04];

posInfo.Sub100HzCheck1=[0.81 0.79 .1 .025];
posInfo.Sub100HzCheck2=[.9 .79 .1 .025];
posInfo.Spec1Select=[.81 .745 .085 .04];
posInfo.Spec2Select=[.9 .745 .085 .04];
posInfo.climMax_text = [.8 .7 .1 .04];
posInfo.climMax_input = [.81 .675 .085 .04];
posInfo.climMax_text2 = [.895 .7 .1 .04]; 
posInfo.climMax_input2 = [.9 .675 .085 .04];

posInfo.ColormapSelect=[.81 .63 .085 .04];
posInfo.BreakoutPlotButton=[.9 .63 .085 .04];

posInfo.Epoch1_A_text = [.81 .58 .07 .04];
posInfo.Epoch1_A_Input = [.81 .555 .085 .04];
posInfo.Epoch2_A_text = [.9 .58 .07 .04];
posInfo.Epoch2_A_Input = [.9 .555 .085 .04]; 
posInfo.Epoch1_B_text = [.81 .51 .07 .04];
posInfo.Epoch1_B_Input =[.81 .485 .085 .04];
posInfo.Epoch2_B_text = [.9 .51 .07 .04];
posInfo.Epoch2_B_Input = [.9 .485 .085 .04];
posInfo.maxSticktext=[.8 .44 .1 .04];
posInfo.maxStick=[.81 .41 .085 .04];
posInfo.DispInfoButton=[.9 .41 .085 .04];


% posInfo.AlooptimeText  = [.8 .43 .18 .04];
% posInfo.BlooptimeText = [.8 .4 .18 .04];
posInfo.AphasedelayText=[.81 .37 .18 .04];
posInfo.BphasedelayText=[.81 .34 .18 .04];

posInfo.checkbox0=[.12 .965 .1 .025];
posInfo.checkbox1=[.12 .94 .1 .025];
posInfo.checkbox2=[.185 .965 .1 .025];
posInfo.checkbox3=[.185 .94 .1 .025];
posInfo.checkbox4=[.23 .965 .1 .025];
posInfo.checkbox5=[.23 .94 .1 .025];
posInfo.checkbox6=[.3 .965 .1 .025];
posInfo.checkbox7=[.3 .94 .1 .025];
posInfo.checkbox8=[.36 .965 .06 .025];
posInfo.checkbox9=[.36 .94 .06 .025];

posInfo.PlotSelect=[.01 .96 .1 .025];

% ColorSet=colormap(jet);%hsv jet gray lines colorcube
% j=[1     8    17    20    23    27   45    50    58    64];
ColorSet=[.6 .6 .6;..., % gray - Gyro raw
  0   0  0;..., % black - Gyro filt
  0  .7  0;..., % green - Pterm
 .8  .65 .1;..., % yellow - I term
 .3  .7  .9;..., % light blue - Dterm raw
 .1  .2  .8;..., % dark blue -Dterm Filt
 .6  .3  .3;..., % brown - Fterm 
 .8  0  .2;..., % dark red
 .9  .2  .9;..., % light purple
 .6 0 1];    % dark purple
j=[1 2 3 4 5 6 7 8 9 10];

k=1;
for i=1:10,
    eval(['line.col' int2str(k-1) '=ColorSet(j(i),:);']);
    k=k+1;
end

%%% user defined colormap, similar to plasmatree, for user familiarity
a=colormap(parula);
parulaMod=[a(:,1) a(:,2) a(:,3)*.6];


guiHandles.checkbox0=uicontrol(PTfig,'Style','checkbox','String','Gyro unfilt','fontsize',fontsz,'ForegroundColor',[line.col0],...
    'units','normalized','outerposition',[posInfo.checkbox0],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox1=uicontrol(PTfig,'Style','checkbox','String','Gyro filt','fontsize',fontsz,'ForegroundColor',[line.col1],...
    'units','normalized','outerposition',[posInfo.checkbox1],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox2=uicontrol(PTfig,'Style','checkbox','String','Pterm','fontsize',fontsz,'ForegroundColor',[line.col2],...
    'units','normalized','outerposition',[posInfo.checkbox2],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox3=uicontrol(PTfig,'Style','checkbox','String','Iterm','fontsize',fontsz,'ForegroundColor',[line.col3],...
    'units','normalized','outerposition',[posInfo.checkbox3],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox4=uicontrol(PTfig,'Style','checkbox','String','Dterm unfilt','fontsize',fontsz,'ForegroundColor',[line.col4],...
    'units','normalized','outerposition',[posInfo.checkbox4],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox5=uicontrol(PTfig,'Style','checkbox','String','Dterm filt','fontsize',fontsz,'ForegroundColor',[line.col5],...
    'units','normalized','outerposition',[posInfo.checkbox5],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox6=uicontrol(PTfig,'Style','checkbox','String','Fterm','fontsize',fontsz,'ForegroundColor',[line.col6],...
    'units','normalized','outerposition',[posInfo.checkbox6],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox7=uicontrol(PTfig,'Style','checkbox','String','Set point','fontsize',fontsz,'ForegroundColor',[line.col7],...
    'units','normalized','outerposition',[posInfo.checkbox7],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox8=uicontrol(PTfig,'Style','checkbox','String','PID sum','fontsize',fontsz,'ForegroundColor',[line.col8],...
    'units','normalized','outerposition',[posInfo.checkbox8],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox9=uicontrol(PTfig,'Style','checkbox','String','PID error','fontsize',fontsz,'ForegroundColor',[line.col9],...
    'units','normalized','outerposition',[posInfo.checkbox9],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), PTplotRaw; end');
guiHandles.checkbox0.Value=1;
guiHandles.checkbox1.Value=1;

guiHandles.DispInfoButton = uicontrol(PTfig,'string','setup info','fontsize',fontsz,'units','normalized','outerposition',[posInfo.DispInfoButton],...
    'callback','PTdispSetupInfo;');
guiHandles.DispInfoButton.BackgroundColor=[ .8 .8 .8];

guiHandles.PlotSelect = uicontrol(PTfig,'Style','popupmenu','string',{'1. Main + spectrogram','2. Spectrogram only','3. Step Resp + spectrogram', '4. |PIDerror| + spectrogram'},...
    'fontsize',fontsz,'units','normalized','outerposition',[posInfo.PlotSelect],'callback',';@selection; zoom off;PTplotRaw;updateSpec=1; PTplotSpec;');

guiHandles.fileA = uicontrol(PTfig,'string','select file A','fontsize',fontsz,'units','normalized','outerposition',[posInfo.fileA],...
    'callback','[filenameA, filepath] = uigetfile({''*.csv''});filenameAtmp=[];');
%   'callback','[filenameA, filepath] = uigetfile({''*.csv'' ; ''*.BBL'' ; ''*.BFL'' });filenameAtmp=[];');
guiHandles.fileA.BackgroundColor=[colorA];
guiHandles.fileB = uicontrol(PTfig,'string','select file B','fontsize',fontsz,'units','normalized','outerposition',[posInfo.fileB],...
    'callback','[filenameB, filepath] = uigetfile({''*.csv''});filenameBtmp=[];');
%   'callback','[filenameB, filepath] = uigetfile({''*.csv'' ; ''*.BBL'' ; ''*.BFL'' });filenameBtmp=[];');

guiHandles.fileB.BackgroundColor=[colorB]; 
guiHandles.runAll = uicontrol(PTfig,'string','load+run','fontsize',fontsz,'units','normalized','outerposition',[posInfo.runAll],...
    'callback','PTload; PTprocess;PTplotRaw;PTplotSpec;'); 
guiHandles.runAll.BackgroundColor=[.3 .9 .3];
guiHandles.refreshcall = uicontrol(PTfig,'string','refresh','fontsize',fontsz,'units','normalized','outerposition',[posInfo.refreshcall],...
    'callback','zoom off;PTprocess;PTplotRaw;PTplotSpec;');
guiHandles.refreshcall.BackgroundColor=[1 .95 .1];

guiHandles.Sub100HzCheck1 =uicontrol(PTfig,'Style','checkbox','String','<100Hz','fontsize',fontsz,...
    'units','normalized','outerposition',[posInfo.Sub100HzCheck1],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1; PTplotSpec;');
guiHandles.Sub100HzCheck2 =uicontrol(PTfig,'Style','checkbox','String','<100Hz','fontsize',fontsz,...
    'units','normalized','outerposition',[posInfo.Sub100HzCheck2],'callback','if (~isempty(filenameA) | ~isempty(filenameB)), end;updateSpec=1; PTplotSpec;');

guiHandles.Spec1Select = uicontrol(PTfig,'Style','popupmenu','string',{'Gyro unfiltered','Gyro filtered','PID error','Set point','Error-SetPt spec','Gyro-SetPt spec','Dterm unfiltered','Dterm filtered','Motors 1 2','Motors 3 4'},...
    'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Spec1Select],'callback','@selection;');
guiHandles.Spec2Select = uicontrol(PTfig,'Style','popupmenu','string',{'Gyro unfiltered','Gyro filtered','PID error','Set point','Error-SetPt spec','Gyro-SetPt spec','Dterm unfiltered','Dterm filtered','Motors 1 2','Motors 3 4'},...
    'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Spec2Select],'callback','@selection;');
guiHandles.Spec2Select.Value=2;

guiHandles.ColormapSelect = uicontrol(PTfig,'Style','popupmenu','string',{'parula','jet','hot','cool','spring','summer','autumn','winter','gray','bone','copper','parulaMod'},...
    'fontsize',fontsz,'units','normalized','outerposition',[posInfo.ColormapSelect],'callback','@selection;updateSpec=1; PTplotSpec;');
guiHandles.ColormapSelect.Value=12;% hot parulaMod

guiHandles.BreakoutPlotButton = uicontrol(PTfig,'string','save fig','fontsize',fontsz,'units','normalized','outerposition',[posInfo.BreakoutPlotButton],...
    'callback','PTplotBreakout;');
guiHandles.BreakoutPlotButton.BackgroundColor=[ .8 .8 .8];

guiHandles.climMax_text = uicontrol(PTfig,'style','text','string','Hmap1 scale','fontsize',fontsz,'units','normalized','outerposition',[posInfo.climMax_text]);
guiHandles.climMax_input = uicontrol(PTfig,'style','edit','string',[num2str(climMultiplier)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.climMax_input],...
     'callback','@textinput_call; climMultiplier=str2num(guiHandles.climMax_input.String);updateSpec=1; PTplotSpec;');
 
 
guiHandles.climMax_text2 = uicontrol(PTfig,'style','text','string','Hmap2 scale','fontsize',fontsz,'units','normalized','outerposition',[posInfo.climMax_text2]);
guiHandles.climMax_input2 = uicontrol(PTfig,'style','edit','string',[num2str(climMultiplier2)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.climMax_input2],...
     'callback','@textinput_call; climMultiplier2=str2num(guiHandles.climMax_input2.String);updateSpec=1; PTplotSpec;');
 
guiHandles.maxSticktext = uicontrol(PTfig,'style','text','string','max stick deg/s','fontsize',fontsz,'units','normalized','outerposition',[posInfo.maxSticktext]);
guiHandles.maxStick = uicontrol(PTfig,'style','edit','string',[int2str(maxDegsec)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.maxStick],...
     'callback','@textinput_call; maxDegsec=str2num(guiHandles.maxStick.String);maxPIDerror=maxDegsec; zoom off;PTprocess;PTplotRaw;updateSpec=1; PTplotSpec;');

guiHandles.Epoch1_A_text = uicontrol(PTfig,'style','text','string','A start (s)','fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_A_text]);
guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
     'callback','@textinput_call; epoch1_A=str2num(guiHandles.Epoch1_A_Input.String);PTprocess;PTplotRaw;updateSpec=1; PTplotSpec;');
guiHandles.Epoch2_A_text = uicontrol(PTfig,'style','text','string','A end (s)','fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_text]);
guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
     'callback','@textinput_call;epoch2_A=str2num(guiHandles.Epoch2_A_Input.String);PTprocess;PTplotRaw;updateSpec=1; PTplotSpec;');
 
guiHandles.Epoch1_B_text = uicontrol(PTfig,'style','text','string','B start (s)','fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_B_text]);
guiHandles.Epoch1_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_B_Input],...
     'callback','@textinput_call; epoch1_B=str2num(guiHandles.Epoch1_B_Input.String);PTprocess;PTplotRaw;updateSpec=1; PTplotSpec; ');
guiHandles.Epoch2_B_text = uicontrol(PTfig,'style','text','string','B end (s)','fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_text]);
guiHandles.Epoch2_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_Input],...
     'callback','@textinput_call; epoch2_B=str2num(guiHandles.Epoch2_B_Input.String);PTprocess;PTplotRaw;updateSpec=1; PTplotSpec;');

 
function getList(hObj,event)
v=get(hObj,'value')
end

function textinput_call(src,eventdata)
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


function execDir = get_deployed_exec_dir()
    % Returns the directory of the currently running executable, if deployed,
    % an empty string if not deployed (or if unable to determine the directory)
    execDir = '';
    if isdeployed
        [status, execDir] = system('path');
        if status == 0
            execDir = char(regexpi(execDir, 'Path=(.*?);', 'tokens', 'once'));
        end
    else
       execDir = pwd;
    end
end



%%%%% to do
% 
