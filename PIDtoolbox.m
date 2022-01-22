 %% PIDtoolbox - main  
%  script for main control panel and log viewer
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
clear

PtbVersion='v0.5';

t = now;
currentDate = char(datetime(t,'ConvertFrom','datenum'));
currentDate = currentDate(1:strfind(currentDate,' ')-1);

set(0,'defaultUicontrolFontName', 'Helvetica') %calibri Helvetica
set(0,'defaultUicontrolFontSize', 10)

executableDir = pwd;
%addpath(executableDir)

BF=1;
GYRO_SCALED=6;

try
    fid = fopen('logfileDir.txt');
    logfileDir = fscanf(fid,'%s');
    fclose(fid);   
catch
    logfileDir=[];
end

%%%% assign main figure handle and define some UI variables 
PTfig = figure(1);
PTfig.InvertHardcopy='off';
bgcolor=[.95 .95 .95];
set(PTfig,'color',bgcolor);

wikipage='https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide';

if ~exist('filenameA','var'), filenameA=[]; end

expandON=0;
use_randsamp=0;
smp_sze=100;
choose_epoch=0;
epoch1_A=[];
epoch2_A=[];
tIND = [];
maxY =  500;
updateSpec=0;
A_debugmode=0;%default to gyro_scaled
filepathA=[];
filenameA={};

hexpand1=[];
hexpand2=[];
hexpand3=[];

errmsg=[];

plotall_flag=-1;

colorA=[.8 .1 .1];
colorA2=[.48 .0 .72];
colorB=[.12 .48 .96];
colorC=[1 .2 .2];
colorD=[.1 1 .2];

colRun = [0 .6 .3];
saveCol = [.1 .1 .1];
setUpCol = [.1 .1 .1];
cautionCol = [0.7    0.4    0];
%use_phsCorrErr=0;
flightSpec=0;
screensz = get(0,'ScreenSize');
screensz(3) = round(1.78 * screensz(4)); % force 16:9


%set(PTfig, 'Position', [10, 10, screensz(3)*.5, screensz(4)*.5]);
set(PTfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTfig.NumberTitle='off';
PTfig.Name= ['PIDtoolbox (' PtbVersion ') - Log Viewer'];

pause(.1)% need to wait for figure to open before extracting screen values

screensz_multiplier = sqrt(screensz(4)^2) * .01; % based on vertical dimension only, to deal with for ultrawide monitors
prop_max_screen = PTfig.Position(4);
fontsz = (screensz_multiplier*prop_max_screen);
markerSz = round(screensz_multiplier * 0.7);

controlpanel = uipanel('Title','Control Panel','FontSize',fontsz,...
             'BackgroundColor',[.95 .95 .95],...
             'Position',[.89 .615 .105 .305]);

posInfo.firmware =[.8965 .86 .091 .04];          
posInfo.fileA=[.896 .845 .0455 .026];
posInfo.clr=[.942 .845 .0455 .026];
posInfo.fnameAText = [.8965 .8 .091 .04];

posInfo.startEndButton=[.896 .79 .095 .026];

LogStDefault = 2;% default ignore first 2 seconds of logfile
LogNdDefault = 1;% default ignore last 1 second of logfile

posInfo.lineSmooth = [.895 .76 .046 .026];
posInfo.linewidth = [.943 .76 .046 .026];

posInfo.spectrogramButton=[.895 .733 .093 .026];
posInfo.TuningButton=[.895 .705 .093 .026];
posInfo.DispInfoButton=[.895 .678 .046 .026];
posInfo.saveFig=[.943 .678 .046 .026];
posInfo.wiki=[.895 .651 .093 .026];
posInfo.PIDtuningService=[.895 .623 .093 .026];

fnameMaster = {}; 
fcnt = 0;

NmultiLineCols=10;
cmap=flipud(colormap(jet));
multiLineCols=(downsample(cmap,ceil(length(cmap)/NmultiLineCols)));
for i = 4 : 7
    multiLineCols(i,:) = multiLineCols(i,:) * .76;
end

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
 1  .2  .9;..., % light purple
 .4 0 .9;...,    % dark purple
 .9 0 0;..., %M1 
 1  .6 0;..., %M2
0  0 .9;..., %M3
.1  1  .8;..., %M4
 0 0 0;..., % throttle
 0 0 0]; % all
j=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];

k=1;
for i=1:length(j)
    eval(['linec.col' int2str(k-1) '=ColorSet(j(i),:);']);
    k=k+1;
end

%%% tooltips
TooltipString_files=['Select the .BBL or .BFL file you wish to analyze. ' , newline,...
    'Warning: blackbox_decode must be in the same folder as the selected log file!' , newline,...
    'It usually does not matter where the PIDtoolbox program file is located.'];

TooltipString_loadRun=['Select one or more files to analyze. '];
TooltipString_Epochs=['Input the desired start and end points (in seconds) of the selected log file' , newline, 'Note: the selected time window denotes the data used for all other analyses.' , newline, 'The shaded regions indicate ignored data.'];
TooltipString_spec=['Opens spectral analysis tool in new window'];
TooltipString_step=['Opens step response tool in new window'];
TooltipString_setup=['Displays detailed setup information in new window'];
TooltipString_saveFig=['Saves current figure', newline,'Note: Clicking the ''Save fig'' button for the first time creates a folder using the log file names'];
TooltipString_wiki=['Link to the PIDtoolbox wiki in Github'];
TooltipString_selectButton = ['With box checked, position mouse over desired start position,' , newline, 'then mouse click, then desired end position, then mouse click again;' , newline, 'to escape, deselect then click anywhere'];

%%%

guiHandles.Firmware = uicontrol(PTfig,'Style','popupmenu','string',[{'Betaflight logfiles'; 'Emuflight logfiles'; 'INAV logfiles'}], 'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.firmware]);

guiHandles.fileA = uicontrol(PTfig,'string','Select ','fontsize',fontsz,'TooltipString', [TooltipString_loadRun], 'units','normalized','outerposition',[posInfo.fileA],...
     'callback','guiHandles.fileA.FontWeight=''Bold''; try, if ~isempty(logfileDir), cd(logfileDir), end, catch, end; [filenameA, filepathA] = uigetfile({''*.BBL;*.BFL;*.TXT''}, ''MultiSelect'',''on''); if isstr(filenameA), filenameA={filenameA}; end; if iscell(filenameA), PTload; PTviewerUIcontrol; PTplotLogViewer; end'); 
guiHandles.fileA.ForegroundColor=[colRun];

guiHandles.clr = uicontrol(PTfig,'string','Reset','fontsize',fontsz,'TooltipString', ['clear all data'], 'units','normalized','outerposition',[posInfo.clr],...
     'callback','clear T dataA tta A_lograte epoch1_A epoch2_A SetupInfo rollPIDF pitchPIDF yawPIDF filenameA fnameMaster; fcnt = 0; filenameA={};fnameMaster = {}; try, delete(subplot(''position'',posInfo.linepos1)); delete(subplot(''position'',posInfo.linepos2)); delete(subplot(''position'',posInfo.linepos3)); catch, end; guiHandles.FileNum.String='' ''; guiHandles.Epoch1_A_Input.String='' ''; guiHandles.Epoch2_A_Input.String='' '';PIDtoolbox;'); 
guiHandles.clr.ForegroundColor=[cautionCol];

guiHandles.startEndButton = uicontrol(PTfig,'style','checkbox', 'string','select start/end points ','fontsize',fontsz,'TooltipString', [TooltipString_selectButton], 'units','normalized','outerposition',[posInfo.startEndButton],...
    'callback','if ~isempty(filenameA) && guiHandles.startEndButton.Value, [x y] = ginput(1); epoch1_A(guiHandles.FileNum.Value) = round(x(1)*10)/10; PTplotLogViewer; [x y] = ginput(1); epoch2_A(guiHandles.FileNum.Value) = round(x(1)*10)/10; PTplotLogViewer, end'); 

guiHandles.FileNum = uicontrol(PTfig,'Style','popupmenu','string',[filenameA], 'fontsize',fontsz, 'units','normalized','outerposition', [posInfo.fnameAText]);
guiHandles.FileNum.String=' ';

guiHandles.lineSmooth = uicontrol(PTfig,'Style','popupmenu','string',{'line smooth off','line smooth low','line smooth med','line smooth med-high','line smooth high'},...
    'fontsize',fontsz,'TooltipString', ['zero-phase filter lines'], 'units','normalized','outerposition', [posInfo.lineSmooth],'callback','@selection; if ~isempty(filenameA), PTplotLogViewer; end');
 guiHandles.lineSmooth.Value = 1;

guiHandles.linewidth = uicontrol(PTfig,'Style','popupmenu','string',{'line width 1','line width 2','line width 3','line width 4','line width 5'},...
    'fontsize',fontsz, 'TooltipString', ['line thickness'], 'units','normalized','outerposition', [posInfo.linewidth],'callback','@selection; if ~isempty(filenameA), PTplotLogViewer; end');
 guiHandles.linewidth.Value = 3;
 
guiHandles.spectrogramButton = uicontrol(PTfig,'string','Spectral Analyzer','fontsize',fontsz,'TooltipString', [TooltipString_spec],'units','normalized','outerposition',[posInfo.spectrogramButton],...
    'callback','PTspec2DUIcontrol;');
guiHandles.spectrogramButton.ForegroundColor=[colorA];

guiHandles.TuningButton = uicontrol(PTfig,'string','Step Resp Tool','fontsize',fontsz,'TooltipString', [TooltipString_step],'units','normalized','outerposition',[posInfo.TuningButton],...
    'callback','PTtuneUIcontrol');
guiHandles.TuningButton.ForegroundColor=[colorB];

guiHandles.DispInfoButton = uicontrol(PTfig,'string','Setup Info','fontsize',fontsz,'TooltipString', [TooltipString_setup],'units','normalized','outerposition',[posInfo.DispInfoButton],...
    'callback','PTdispSetupInfoUIcontrol;PTdispSetupInfo;');
guiHandles.DispInfoButton.ForegroundColor=[setUpCol];

guiHandles.saveFig = uicontrol(PTfig,'string','Save Fig','fontsize',fontsz, 'TooltipString',[TooltipString_saveFig], 'units','normalized','outerposition',[posInfo.saveFig],...
    'callback','guiHandles.saveFig.FontWeight=''bold'';PTsaveFig; guiHandles.saveFig.FontWeight=''normal'';'); 
guiHandles.saveFig.ForegroundColor=[saveCol];

guiHandles.wiki = uicontrol(PTfig,'string','User Guide','fontsize',fontsz,'FontName','arial','FontAngle','normal','TooltipString', [TooltipString_wiki],'units','normalized','outerposition',[posInfo.wiki],...
    'callback','web(wikipage);'); 
guiHandles.wiki.ForegroundColor=[cautionCol];

guiHandles.PIDtuningService = uicontrol(PTfig,'string','Donate','fontsize',fontsz ,'FontName','arial','FontAngle','normal','TooltipString', ['Donate to the PIDtoolbox project'],'units','normalized','outerposition',[posInfo.PIDtuningService],...
    'callback','web(''https://www.paypal.com/paypalme/PIDtoolbox'');'); 
guiHandles.PIDtuningService.ForegroundColor=[cautionCol];


%% functions

% functions
function selection(src,event)
    val = c.Value;
    str = c.String;
    str{val};
   % disp(['Selection: ' str{val}]);
end

function textinput_call(src)
str=get(src,'String');
    if isempty(str2num(str))
        set(src,'string','0');
        warndlg('Input must be numerical');  
    end
end



