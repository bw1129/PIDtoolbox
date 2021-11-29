%% PTspec2DUIcontrol - ui controls for spectral analyses plots

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
TooltipString_smooth=['Choose amount of smoothing'];
TooltipString_user=['Choose the variable you wish to plot'];
TooltipString_sub100=['Zoom data to show sub 100Hz details',...
    newline, 'Typically used to see propwash or mid-throttle vibration in e.g. Gyro/Pterm/PIDerror'];


%%%
PTcolormap;
% define
smat=[];%string
ampmat=[];%spec matrix
amp2d2=[];%spec 2d
freq2d2=[];% freq
  

clear posInfo.Spec2Pos
cols=[0.05 0.48];
rows=[0.69 0.395 0.1];
k=0;
for c=1 : size(cols,2)
    for r=1 : size(rows,2)
        k=k+1;
        if c == 1
            posInfo.Spec2Pos(k,:)=[cols(c) rows(r) 0.38 0.245];
        else
            posInfo.Spec2Pos(k,:)=[cols(c) rows(r) 0.38 0.245];
        end
    end
end

 
posInfo.fileListWindowSpec=[.898 .7 .088 .20];
posInfo.TermListWindowSpec=[.898 .55 .088 .14];

posInfo.computeSpec=            [.896 .522 .0455 .026];
posInfo.resetSpec=              [.942 .522 .0455 .026];
posInfo.spectrogramButton2=     [.896 .495 .0915 .026];
posInfo.spectrogramButton3=    [.896 .468 .0915 .026];
posInfo.saveFig2=               [.896 .441 .0915 .026]; % .896 .495 .092 .026
 
posInfo.smooth_select =         [.895 .395 .0915 .04];
posInfo.checkboxPSD=            [.925 .34 .04 .02];

posInfo.climMax1_text = [.91 .385 .035 .024];
posInfo.climMax1_input = [.915 .365 .025 .024];
posInfo.climMax2_text = [.94 .385 .035 .024];
posInfo.climMax2_input = [.945 .365 .025 .024];


climScale1=[0 ; -50 ];
climScale2=[0.5 ; 20];

PTspecfig2=figure(3);
set(PTspecfig2, 'units','normalized','outerposition',[.1 .1 .75 .8])
PTspecfig2.NumberTitle='off';
PTspecfig2.Name= ['PIDtoolbox (' PtbVersion ') - Spectral Analyzer'];
PTspecfig2.InvertHardcopy='off';
set(PTspecfig2,'color',bgcolor);


dcm_obj2 = datacursormode(PTspecfig2);
set(dcm_obj2,'UpdateFcn',@PTdatatip);

specCrtlpanel = uipanel('Title','select files (max 10)','FontSize',fontsz,...
              'BackgroundColor',[.95 .95 .95],...
              'Position',[.89 .33 .105 .59]);
 
guiHandlesSpec2.computeSpec = uicontrol(PTspecfig2,'string','Run','fontsize',fontsz,'TooltipString', [TooltipString_specRun],'units','normalized','outerposition',[posInfo.computeSpec],...
    'callback','PTplotSpec2D;');
guiHandlesSpec2.computeSpec.ForegroundColor=[colRun];

guiHandlesSpec2.resetSpec = uicontrol(PTspecfig2,'string','Reset','fontsize',fontsz,'TooltipString', ['Reset Spectral Tool'],'units','normalized','outerposition',[posInfo.resetSpec],...
    'callback',' for k = 1 : 6, delete(subplot(''position'',posInfo.Spec2Pos(k,:))), end; set(PTspecfig2, ''pointer'', ''arrow'');');
guiHandlesSpec2.resetSpec.ForegroundColor=[cautionCol];

guiHandlesSpec2.checkboxPSD =uicontrol(PTspecfig2,'Style','checkbox','String','PSD','fontsize',fontsz,'TooltipString', ['Power Spectral Density'],...
    'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.checkboxPSD],'callback', 'PTplotSpec2D;');
guiHandlesSpec2.checkboxPSD.Value = 1;

guiHandlesSpec2.saveFig2 = uicontrol(PTspecfig2,'string','Save Fig','fontsize',fontsz,'TooltipString',[TooltipString_saveFig],'units','normalized','ForegroundColor',[saveCol],'outerposition',[posInfo.saveFig2],...
    'callback','guiHandlesSpec2.saveFig2.FontWeight=''bold'';PTsaveFig;guiHandlesSpec2.saveFig2.FontWeight=''normal'';'); 

% create string list for SpecSelect
sA={'Gyro','Gyro prefilt','Dterm','Dterm prefilt','Pterm','PID error','Set point','PIDsum'};

guiHandlesSpec2.SpecList = uicontrol(PTspecfig2,'Style','listbox','string',[sA],'max',3,'min',1, 'fontsize',fontsz, 'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.TermListWindowSpec], 'callback', 'if length(guiHandlesSpec2.SpecList.Value) > 2, guiHandlesSpec2.SpecList.Value=1; end;');
guiHandlesSpec2.SpecList.Value =[1 2];
 
guiHandlesSpec2.FileSelect = uicontrol(PTspecfig2,'Style','listbox','string',[fnameMaster],'max', 10, 'min', 1, 'fontsize',fontsz,'TooltipString',[TooltipString_user],'units','normalized','outerposition', [posInfo.fileListWindowSpec], 'callback', 'if length(guiHandlesSpec2.FileSelect.Value) > 10, guiHandlesSpec2.FileSelect.Value=1; end;');

guiHandlesSpec2.smoothFactor_select = uicontrol(PTspecfig2,'style','popupmenu','string',{'smoothing low' 'smoothing low-med' 'smoothing medium' 'smoothing med-high' 'smoothing high'},'fontsize',fontsz,'TooltipString', [TooltipString_smooth], 'units','normalized','outerposition',[posInfo.smooth_select],...
     'callback','@selection2;updateSpec=1;PTplotSpec2D;');
guiHandlesSpec2.smoothFactor_select.Value=3;

guiHandlesSpec2.spectrogramButton2 = uicontrol(PTspecfig2,'string','Freq x Throttle','fontsize',fontsz,'TooltipString', ['Opens Freq x Throttle Spectrogram in New Window'], 'units','normalized','outerposition',[posInfo.spectrogramButton2],...
    'callback','PTspecUIcontrol;');
guiHandlesSpec2.spectrogramButton2.ForegroundColor=[colorA];

 guiHandlesSpec2.spectrogramButton3 = uicontrol(PTspecfig2,'string','Freq x Time','fontsize',fontsz,'TooltipString', ['Opens Freq x Time Spectrogram in New Window'], 'units','normalized','outerposition',[posInfo.spectrogramButton3],...
     'callback','PTfreqTimeUIcontrol;');
 guiHandlesSpec2.spectrogramButton3.ForegroundColor=[colorB];

guiHandlesSpec2.climMax1_text = uicontrol(PTspecfig2,'style','text','string','Y min','fontsize',fontsz,'TooltipString',['Y min'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax1_text]);
guiHandlesSpec2.climMax1_input = uicontrol(PTspecfig2,'style','edit','string',[num2str(climScale1(guiHandlesSpec2.checkboxPSD.Value+1, 1))],'fontsize',fontsz,'TooltipString',['Y min'],'units','normalized','outerposition',[posInfo.climMax1_input],...
     'callback','@textinput_call2; climScale1(guiHandlesSpec2.checkboxPSD.Value+1, 1)=str2num(guiHandlesSpec2.climMax1_input.String);updateSpec=1;PTplotSpec2D;');

 guiHandlesSpec2.climMax2_text = uicontrol(PTspecfig2,'style','text','string','Y max','fontsize',fontsz,'TooltipString',['Y max'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax2_text]);
guiHandlesSpec2.climMax2_input = uicontrol(PTspecfig2,'style','edit','string',[num2str(climScale2(guiHandlesSpec2.checkboxPSD.Value+1, 1))],'fontsize',fontsz,'TooltipString',['Y max'],'units','normalized','outerposition',[posInfo.climMax2_input],...
     'callback','@textinput_call2; climScale2(guiHandlesSpec2.checkboxPSD.Value+1, 1)=str2num(guiHandlesSpec2.climMax2_input.String);updateSpec=1;PTplotSpec2D;');


PhaseDelay_A={};PhaseDelay2_A={};
for k = 1 : Nfiles
    try 
        Fs=1000/A_lograte(k);% yields more consistent results (mode(diff(tta)));
        maxlag=int8(round(6000/Fs)); %~6ms delay

        clear d g1 g2
        g1 = smooth(T{k}.debug_0_(tIND{k}),50);
        g2 = smooth(T{k}.gyroADC_0_(tIND{k}),50);

        d = finddelay(g1 ,g2, maxlag); % both signals smoothed equally, more reliable estimate
        d = d * (Fs / 1000);
        if d<.1,  PhaseDelay_A{k} = ' '; else PhaseDelay_A{k} = num2str(d);end 

        clear d g1 g2
        g1 = smooth(T{k}.axisDpf_0_(tIND{k}),50);
        g2 = smooth(T{k}.axisD_0_(tIND{k}),50);
        d=finddelay(g1, g2, maxlag) ;
        d=d * (Fs / 1000);
        if d<.1, PhaseDelay2_A{k} = ' '; else PhaseDelay2_A{k} = num2str(d); end
    catch
        PhaseDelay_A{k} = ' ';
        PhaseDelay2_A{k} = ' ';
    end
end

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





