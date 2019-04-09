%% PIDtoolbox - main  
%  script for main control panel and log viewer
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

executableDir = pwd;
% c = pathsep;
% if ~endsWith(getenv('PATH'), executableDir, 'IgnoreCase',true)
%     setenv('PATH', [getenv('PATH') c executableDir]);
% end

%%%% assign main figure handle and define some UI variables 
PTfig = figure(1);
PTfig.InvertHardcopy='off';
bgcolor=[.95 .95 .95];
set(PTfig,'color',bgcolor);

wikipage='https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide';

if ~exist('filenameA','var'), filenameA=[]; end
if ~exist('filenameB','var'), filenameB=[]; end

expandON=0;
use_randsamp=0;
smp_sze=100;
choose_epoch=0;
epoch1_A=[];
epoch2_A=[];
epoch1_B=[];
epoch2_B=[];
updateSpec=0;
A_debugmode=6;%default to gyro_scaled
B_debugmode=6;
filepathA=[];
filepathB=[];
filenameA=[];
filenameB=[];

hexpand1=[];
hexpand2=[];
hexpand3=[];
hexpand4=[];
hexpand5=[];
hexpand6=[];

plotall_flag=-1;

colorA=[.93 .5 .3];
colorB=[.3 .65 .95];

%use_phsCorrErr=0;
flightSpec=0;
screensz = get(0,'ScreenSize');

%set(PTfig, 'Position', [10, 10, screensz(3)*.5, screensz(4)*.5]);
set(PTfig, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTfig.NumberTitle='off';
PTfig.Name= 'PIDtoolbox Log Viewer';

pause(.2)% need to wait for figure to open before extracting screen values

screensz_multiplier = sqrt(screensz(3)^2+screensz(4)^2) * .0064;
prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);

controlpanel = uipanel('Title','Control Panel','FontSize',fontsz,...
             'BackgroundColor',[.95 .95 .95],...
             'Position',[.89 .36 .105 .56]); 

         
posInfo.fnameAText = [.89 .955 .11 .04];
posInfo.fnameBText = [.89 .92 .11 .04];
posInfo.fileA=[.9 .85 .085 .04];
posInfo.fileB=[.9 .805 .085 .04];
posInfo.runAll=[.9 .76 .085 .04]; 

posInfo.Epoch1_A_text = [.895 .72 .05 .03];
posInfo.Epoch1_A_Input = [.901 .68 .04 .04];
posInfo.Epoch2_A_text = [.94 .72 .05 .03];
posInfo.Epoch2_A_Input = [.945 .68 .04 .04]; 

posInfo.Epoch1_B_text = [.895 .65 .05 .03];
posInfo.Epoch1_B_Input =[.901 .61 .04 .04];
posInfo.Epoch2_B_text = [.94 .65 .05 .03];
posInfo.Epoch2_B_Input = [.945 .61 .04 .04];

posInfo.spectrogramButton=[.9 .555 .085 .04];
posInfo.PIDerrButton=[.9 .51 .085 .04];
posInfo.TuningButton=[.9 .465 .085 .04];
posInfo.DispInfoButton=[.9 .420 .085 .04];
posInfo.saveFig=[.9 .375 .085 .04];
posInfo.wiki=[.9 .025 .085 .04];


% posInfo.AlooptimeText  = [.8 .43 .18 .04];
% posInfo.BlooptimeText = [.8 .4 .18 .04];

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
 .6 0 1;...,    % dark purple
 .9 0 0;..., %M1 
 1  .6 0;..., %M2
0  0 .9;..., %M3
.1  1  .8;..., %M4
 .5 .5 .5;..., % throttle
 0 0 0]; % all
j=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];

k=1;
for i=1:length(j)
    eval(['linec.col' int2str(k-1) '=ColorSet(j(i),:);']);
    k=k+1;
end

guiHandles.fileA = uicontrol(PTfig,'string','select file [A]','fontsize',fontsz,'units','normalized','outerposition',[posInfo.fileA],...
     'callback','[filenameA, filepathA] = uigetfile({''*.BBL;*.BFL'' });if filepathA==0, filepathA=[]; filenameA=[]; end, filenameAtmp=[];'); 
guiHandles.fileA.BackgroundColor=colorA;
guiHandles.fileB = uicontrol(PTfig,'string','select file [B]','fontsize',fontsz,'units','normalized','outerposition',[posInfo.fileB],...
     'callback','[filenameB, filepathB] = uigetfile({''*.BBL;*.BFL'' });if filepathB==0, filepathB=[]; filenameB=[]; end, filenameBtmp=[];'); 
guiHandles.fileB.BackgroundColor=colorB; 
guiHandles.runAll = uicontrol(PTfig,'string','load+run','fontsize',fontsz,'units','normalized','outerposition',[posInfo.runAll],...
    'callback','guiHandles.runAll.FontWeight=''bold'';PTload;PTprocess;PTviewerUIcontrol; PTplotLogViewer;guiHandles.runAll.FontWeight=''normal'';'); 
guiHandles.runAll.BackgroundColor=[.3 .9 .3];
 
guiHandles.Epoch1_A_text = uicontrol(PTfig,'style','text','string','[A] st(s)','fontsize',fontsz,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch1_A_text]);
guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',int2str(epoch1_A),'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
     'callback','@textinput_call; epoch1_A=str2num(guiHandles.Epoch1_A_Input.String);PTprocess;PTplotLogViewer; ');
guiHandles.Epoch2_A_text = uicontrol(PTfig,'style','text','string','[A] end(s)','fontsize',fontsz,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch2_A_text]);
guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',int2str(epoch2_A),'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
     'callback','@textinput_call;epoch2_A=str2num(guiHandles.Epoch2_A_Input.String);PTprocess;PTplotLogViewer; ');
guiHandles.Epoch1_B_text = uicontrol(PTfig,'style','text','string','[B] st(s)','fontsize',fontsz,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch1_B_text]);
guiHandles.Epoch1_B_Input = uicontrol(PTfig,'style','edit','string',int2str(epoch1_B),'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_B_Input],...
     'callback','@textinput_call; epoch1_B=str2num(guiHandles.Epoch1_B_Input.String);PTprocess;PTplotLogViewer;  ');
guiHandles.Epoch2_B_text = uicontrol(PTfig,'style','text','string','[B] end(s)','fontsize',fontsz,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch2_B_text]);
guiHandles.Epoch2_B_Input = uicontrol(PTfig,'style','edit','string',int2str(epoch2_B),'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_Input],...
     'callback','@textinput_call; epoch2_B=str2num(guiHandles.Epoch2_B_Input.String);PTprocess;PTplotLogViewer; ');

guiHandles.spectrogramButton = uicontrol(PTfig,'string','spectrogram','fontsize',fontsz,'units','normalized','outerposition',[posInfo.spectrogramButton],...
    'callback','PTspecUIcontrol;');
guiHandles.spectrogramButton.BackgroundColor=[ .8 .8 .8];
guiHandles.PIDerrButton = uicontrol(PTfig,'string','PID error','fontsize',fontsz,'units','normalized','outerposition',[posInfo.PIDerrButton],...
     'callback','PTerrUIcontrol;PTplotPIDerror'); 
guiHandles.PIDerrButton.BackgroundColor=[ .8 .8 .8];
guiHandles.TuningButton = uicontrol(PTfig,'string','step resp','fontsize',fontsz,'units','normalized','outerposition',[posInfo.TuningButton],...
    'callback','PTtuneUIcontrol');
guiHandles.TuningButton.BackgroundColor=[ .8 .8 .8];
guiHandles.DispInfoButton = uicontrol(PTfig,'string','setup info','fontsize',fontsz,'units','normalized','outerposition',[posInfo.DispInfoButton],...
    'callback','PTdispSetupInfo;');
guiHandles.DispInfoButton.BackgroundColor=[ .8 .8 .8];

guiHandles.saveFig = uicontrol(PTfig,'string','save fig','fontsize',fontsz,'units','normalized','outerposition',[posInfo.saveFig],...
    'callback','guiHandles.saveFig.FontWeight=''bold'';PTsaveFig; guiHandles.saveFig.FontWeight=''normal'';'); 
guiHandles.saveFig.BackgroundColor=[ .8 .8 .8];

guiHandles.wiki = uicontrol(PTfig,'string','Wiki','fontsize',fontsz,'units','normalized','outerposition',[posInfo.wiki],...
    'callback','try, system([''start chrome '' wikipage]), catch, web(wikipage), end'); 
guiHandles.wiki.BackgroundColor=[1 1 .2];


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



