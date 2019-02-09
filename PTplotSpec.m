%% PTplotSpec - script that computes and plots spectrograms 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(filenameA) | ~isempty(filenameB)

PTfig(1);

prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));
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
guiHandles.checkbox0.FontSize=fontsz;
guiHandles.checkbox1.FontSize=fontsz;
guiHandles.checkbox2.FontSize=fontsz;
guiHandles.checkbox3.FontSize=fontsz;
guiHandles.checkbox4.FontSize=fontsz;
guiHandles.checkbox5.FontSize=fontsz;
guiHandles.checkbox6.FontSize=fontsz;
guiHandles.checkbox7.FontSize=fontsz;
guiHandles.checkbox8.FontSize=fontsz;
guiHandles.checkbox9.FontSize=fontsz;
if ~isempty(filenameA), guiHandles.fileA.FontWeight='Bold'; else, guiHandles.fileA.FontWeight='Normal'; end
if ~isempty(filenameB), guiHandles.fileB.FontWeight='Bold'; else, guiHandles.fileB.FontWeight='Normal'; end

%%
if ~isempty(filenameA)
guiHandles.fnameAText = uicontrol(PTfig,'style','text','string',['A:' filenameA],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.fnameAText]);
%AlooptimeText = uicontrol(PTfig,'style','text','string',['A:gyro ' int2str(A_looptime/1000) 'kHz / log ' int2str(A_lograte) 'kHz'],'fontsize',fontsz,'units','normalized','outerposition',[posAlooptimeText]);
end
if ~isempty(filenameB)
guiHandles.fnameBText = uicontrol(PTfig,'style','text','string',['B:' filenameB],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.fnameBText]);
%BlooptimeText = uicontrol(PTfig,'style','text','string',['B:gyro ' int2str(B_looptime/1000) 'kHz / log ' int2str(B_lograte) 'kHz'],'fontsize',fontsz,'units','normalized','outerposition',[posBlooptimeText]);
end

if exist('PhaseDelay_A','var')
guiHandles.AphasedelayText = uicontrol(PTfig,'style','text','string',['PsD-A(gyro/dterm/total):' num2str(round(PhaseDelay_A*100)/100) '/' num2str(round(PhaseDelay2_A*100)/100) '/' num2str(round((PhaseDelay_A+PhaseDelay2_A)*100)/100) 'ms'],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.AphasedelayText]);
end
if exist('PhaseDelay_B','var')
guiHandles.BphasedelayText = uicontrol(PTfig,'style','text','string',['PsD-B(gyro/dterm/total):' num2str(round(PhaseDelay_B*100)/100) '/' num2str(round(PhaseDelay2_B*100)/100) '/' num2str(round((PhaseDelay_B+PhaseDelay2_B)*100)/100) 'ms'],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.BphasedelayText]);
end

%%
datSelectionStringA={'DATtmpA.GyroFilt';'DATtmpA.GyroRaw';'DATtmpA.PIDerr';'DATtmpA.RCRate';'DATtmpA.ErrSPt';'DATtmpA.GyrSPt';'DATtmpA.Pterm';'DATtmpA.DtermFilt';'DATtmpA.DtermRaw';'DATtmpA.Motor';'DATtmpA.Motor'};
datSelectionStringB={'DATtmpB.GyroFilt';'DATtmpB.GyroRaw';'DATtmpB.PIDerr';'DATtmpB.RCRate';'DATtmpB.ErrSPt';'DATtmpB.GyrSPt';'DATtmpB.Pterm';'DATtmpB.DtermFilt';'DATtmpB.DtermRaw';'DATtmpB.Motor';'DATtmpB.Motor'};


if guiHandles.PlotSelect.Value==2 % clear all for spec only plots
delete(subplot('position',posInfo.Spec1PosA1))
delete(subplot('position',posInfo.Spec1PosA2))
delete(subplot('position',posInfo.Spec1PosA3))
delete(subplot('position',posInfo.Spec2PosA1))
delete(subplot('position',posInfo.Spec2PosA2))
delete(subplot('position',posInfo.Spec2PosA3))
delete(subplot('position',posInfo.Spec1PosB1))
delete(subplot('position',posInfo.Spec1PosB2))
delete(subplot('position',posInfo.Spec1PosB3))
delete(subplot('position',posInfo.Spec2PosB1))
delete(subplot('position',posInfo.Spec2PosB2))
delete(subplot('position',posInfo.Spec2PosB3))   
    
posInfo.Spec1PosA1=[0.05 0.65 0.16 0.23];
posInfo.Spec1PosA2=[0.05 0.4 0.16 0.23];
posInfo.Spec1PosA3=[0.05 0.15 0.16 0.23];
posInfo.Spec2PosA1=[0.225 0.65 0.16 0.23];
posInfo.Spec2PosA2=[0.225 0.4 0.16 0.23];
posInfo.Spec2PosA3=[0.225 0.15 0.16 0.23];

posInfo.Spec1PosB1=[0.44 0.65 0.16 0.23];
posInfo.Spec1PosB2=[0.44 0.4 0.16 0.23];
posInfo.Spec1PosB3=[0.44 0.15 0.16 0.23];
posInfo.Spec2PosB1=[0.615 0.65 0.16 0.23];
posInfo.Spec2PosB2=[0.615 0.4 0.16 0.23];
posInfo.Spec2PosB3=[0.615 0.15 0.16 0.23];

hCbar1pos=[0.05 0.91 0.1600  0.01];
hCbar2pos=[0.225 0.91 0.1600  0.01];
hCbar3pos=[0.44 0.91 0.1600  0.01];
hCbar4pos=[0.615 0.91 0.1600  0.01];

else
 
posInfo.Spec1PosA1=[0.465 0.81 0.160 0.125];
posInfo.Spec1PosA2=[0.465 0.67 0.160 0.125];
posInfo.Spec1PosA3=[0.465 0.53 0.160 0.125];
posInfo.Spec1PosB1=[0.465 0.365 0.160 0.125];
posInfo.Spec1PosB2=[0.465 0.225 0.160 0.125];
posInfo.Spec1PosB3=[0.465 0.085 0.160 0.125];

posInfo.Spec2PosA1=[0.6350 0.81 0.160 0.125];
posInfo.Spec2PosA2=[0.6350 0.67 0.160 0.125];
posInfo.Spec2PosA3=[0.6350 0.53 0.160 0.125];
posInfo.Spec2PosB1=[0.6350 0.365 0.160 0.125];
posInfo.Spec2PosB2=[0.6350 0.225 0.160 0.125];
posInfo.Spec2PosB3=[0.6350 0.085 0.160 0.125];

hCbar1pos=[0.4650 0.9650 0.1600  0.01];
hCbar2pos=[0.6350 0.9650 0.1600  0.01];

end

if updateSpec==0
hw = waitbar(.2,'computing fft for throttle x freq heatmaps...'); %   
frames = java.awt.Frame.getFrames();
frames(end).setAlwaysOnTop(1);
end

set(PTfig, 'pointer', 'watch')
pause(.2)

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  SPT 1  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
clear vars
vars=guiHandles.Spec1Select.Value; % difference spectrograms
if guiHandles.Spec1Select.Value==5, vars=[3 4]; end 
if guiHandles.Spec1Select.Value==6, vars=[2 4]; end

if ~isempty(filenameA) 
    
    try   
    if updateSpec==0
        clear data1A data2A data3A  
        if guiHandles.Spec1Select.Value<10
            for k=1:length(vars)
                eval(['data1A{k}=' char(datSelectionStringA(vars(k))) '(1,RC_PID_Thresh_A);';])
                eval(['data2A{k}=' char(datSelectionStringA(vars(k))) '(2,RC_PID_Thresh_A);';])
                if guiHandles.Spec1Select.Value<8, eval(['data3A{k}=' char(datSelectionStringA(vars(k))) '(3,RC_PID_Thresh_A);';]), end
            end
        end
         if guiHandles.Spec1Select.Value==10
            eval(['data1A{1}=' char(datSelectionStringA(vars(k))) '(1,RC_PID_Thresh_A);';])
            eval(['data2A{1}=' char(datSelectionStringA(vars(k))) '(2,RC_PID_Thresh_A);';])
         end
         if guiHandles.Spec1Select.Value==11
            eval(['data1A{1}=' char(datSelectionStringA(vars(k))) '(3,RC_PID_Thresh_A);';])
            eval(['data2A{1}=' char(datSelectionStringA(vars(k))) '(4,RC_PID_Thresh_A);';])
        end

        T1=DATtmpA.RCRate(4,RC_PID_Thresh_A);
    end

    multiplier=.2;
    sampFreq=A_lograte*1000;

     clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat

     if updateSpec==0
         waitbar(.25,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal'); 
         for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data1A{k},sampFreq);
         end    
        if guiHandles.Spec1Select.Value==5 | guiHandles.Spec1Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatR_A=temp;
        else
            temp=ampmat{1}; 
            clear ampmat
            ampmatR_A=temp;
        end
    end
    xticks=[1 size(ampmatR_A,1)/5:size(ampmatR_A,1)/5:size(ampmatR_A,1)];
    
    if updateSpec==0, figure(1); end
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
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A,2)-size(ampmatR_A,2)/5 size(ampmatR_A,2)]) 
             hold on;plot([0 100],[97 97],'r--')
            
%          h=text(35,97 ,'commanded motion'); set(h,'color','r')
%             h=text(35,83 ,'uncommanded motion');set(h,'color','y')
        else
            yticks=[size(ampmatR_A,2)-size(ampmatR_A,2)/10:size(ampmatR_A,2)/50:size(ampmatR_A,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A,2)-size(ampmatR_A,2)/10 size(ampmatR_A,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
%              h=text(35,197 ,'commanded motion'); set(h,'color','r')
%             h=text(35,183 ,'uncommanded motion');set(h,'color','y')
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
       
    else
         yticks=[1:(size(ampmatR_A,2))/10:size(ampmatR_A,2) size(ampmatR_A,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
         set(h1,'PlotBoxAspectRatioMode','auto','ylim',[1 size(ampmatR_A,2)])
        if A_lograte<2, set(h1,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
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
    
    h=title(['A: ' char(guiHandles.Spec1Select.String(guiHandles.Spec1Select.Value))]);
    set(h,'fontsize',fontsz)
    catch
    end
    clear a b AMP FREQS segment_length segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat 

    try
    if updateSpec==0
        waitbar(.3,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');  
        for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data2A{k},sampFreq);
        end

        if guiHandles.Spec1Select.Value==5 | guiHandles.Spec1Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatP_A=temp;
        else
            temp=ampmat{1}; 
            clear ampmat
            ampmatP_A=temp;
        end
    end

    if updateSpec==0, figure(1); end
    h1=subplot('position',posInfo.Spec1PosA2);cla
    imagesc(flipud(ampmatP_A'))
   if guiHandles.Sub100HzCheck1.Value
        if A_lograte<2, 
            yticks=[size(ampmatP_A,2)-size(ampmatP_A,2)/5:size(ampmatP_A,2)/25:size(ampmatP_A,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A,2)-size(ampmatP_A,2)/5 size(ampmatP_A,2)]) 
            hold on;plot([0 100],[97 97],'r--')   
        
           
        else
            yticks=[size(ampmatP_A,2)-size(ampmatP_A,2)/10:size(ampmatP_A,2)/50:size(ampmatP_A,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A,2)-size(ampmatP_A,2)/10 size(ampmatP_A,2)])  
            hold on;plot([0 100],[197 197],'r--')
            
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        
   else
        yticks=[1:(size(ampmatP_A,2))/10:size(ampmatP_A,2) size(ampmatP_A,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if A_lograte<2, set(h1,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
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

        if updateSpec==0
            waitbar(.35,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
            for k=1:length(vars)
                ampmat{k}=PTthrSpec(T1,data3A{k},sampFreq);
            end
            if guiHandles.Spec1Select.Value==5 | guiHandles.Spec1Select.Value==6, 
                temp=ampmat{1}-ampmat{2}; 
                clear ampmat
                ampmatY_A=temp;
            else
                temp=ampmat{1}; 
                clear ampmat
                ampmatY_A=temp;
            end
        end
        
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec1PosA3);cla
        imagesc(flipud(ampmatY_A'))
        if guiHandles.Sub100HzCheck1.Value
            if A_lograte<2, 
                yticks=[size(ampmatY_A,2)-size(ampmatY_A,2)/5:size(ampmatY_A,2)/25:size(ampmatY_A,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A,2)-size(ampmatY_A,2)/5 size(ampmatY_A,2)]) 
                hold on;plot([0 100],[97 97],'r--')
            
            else
                yticks=[size(ampmatY_A,2)-size(ampmatY_A,2)/10:size(ampmatY_A,2)/50:size(ampmatY_A,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A,2)-size(ampmatY_A,2)/10 size(ampmatY_A,2)])  
                hold on;plot([0 100],[197 197],'r--')
                
            end  
            set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
            
        else
           yticks=[1:(size(ampmatY_A,2))/10:size(ampmatY_A,2) size(ampmatY_A,2)];
            set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if A_lograte<2, set(h1,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
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
         if updateSpec==0, figure(1); end
         h1=subplot('position',posInfo.Spec1PosA3);
        set(h1,'xticklabels',{})
        xlabel('')
        delete(h1)
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec1PosA2);
        set(h1,'xticklabels',{'0','20','40','60','80','100' })
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

clear vars
vars=guiHandles.Spec1Select.Value;
if guiHandles.Spec1Select.Value==5, vars=[3 4]; end
if guiHandles.Spec1Select.Value==6, vars=[2 4]; end

if ~isempty(filenameB)   
    try
       
    if updateSpec==0
        clear data1B data2B data3B 
        if guiHandles.Spec1Select.Value<10
            for k=1:length(vars)
                eval(['data1B{k}=' char(datSelectionStringB(vars(k))) '(1,RC_PID_Thresh_B);';])
                eval(['data2B{k}=' char(datSelectionStringB(vars(k))) '(2,RC_PID_Thresh_B);';])
                if guiHandles.Spec1Select.Value<8, eval(['data3B{k}=' char(datSelectionStringB(vars(k))) '(3,RC_PID_Thresh_B);';]), end
            end
        end
        if guiHandles.Spec1Select.Value==10
            eval(['data1B{1}=' char(datSelectionStringB(vars(k))) '(1,RC_PID_Thresh_B);';])
            eval(['data2B{1}=' char(datSelectionStringB(vars(k))) '(2,RC_PID_Thresh_B);';])
         end
         if guiHandles.Spec1Select.Value==11
            eval(['data1B{1}=' char(datSelectionStringB(vars(k))) '(3,RC_PID_Thresh_B);';])
            eval(['data2B{1}=' char(datSelectionStringB(vars(k))) '(4,RC_PID_Thresh_B);';])
        end

        T1=DATtmpB.RCRate(4,RC_PID_Thresh_B);
    end

    sampFreq=B_lograte*1000;   
  
     clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat

     if updateSpec==0
         waitbar(.45,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
         for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data1B{k},sampFreq);
         end
        if guiHandles.Spec1Select.Value==5 | guiHandles.Spec1Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatR_B=temp;
        else
            temp=ampmat{1}; 
            clear ampmat
            ampmatR_B=temp;
        end
     end
    
    xticks=[1 size(ampmatR_B,1)/5:size(ampmatR_B,1)/5:size(ampmatR_B,1)];
    if updateSpec==0, figure(1); end
    h1=subplot('position',posInfo.Spec1PosB1);cla
    imagesc(flipud(ampmatR_B'))
   if guiHandles.Sub100HzCheck1.Value
        if B_lograte<2, 
            yticks=[size(ampmatR_B,2)-size(ampmatR_B,2)/5:size(ampmatR_B,2)/25:size(ampmatR_B,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B,2)-size(ampmatR_B,2)/5 size(ampmatR_B,2)]) 
            hold on;plot([0 100],[97 97],'r--')
        
%         h=text(35,97 ,'commanded motion'); set(h,'color','r')
%             h=text(35,83 ,'uncommanded motion');set(h,'color','y')
        else
            yticks=[size(ampmatR_B,2)-size(ampmatR_B,2)/10:size(ampmatR_B,2)/50:size(ampmatR_B,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B,2)-size(ampmatR_B,2)/10 size(ampmatR_B,2)])  
               hold on;plot([0 100],[197 197],'r--')
                
%                   h=text(35,197 ,'commanded motion'); set(h,'color','r')
%             h=text(35,183 ,'uncommanded motion');set(h,'color','y')
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        
   else
        yticks=[1:(size(ampmatR_B,2))/10:size(ampmatR_B,2) size(ampmatR_B,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(h1,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
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
    if updateSpec==0
        waitbar(.5,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
        for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data2B{k},sampFreq);
        end
        if guiHandles.Spec1Select.Value==5 | guiHandles.Spec1Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatP_B=temp;
         else
            temp=ampmat{1}; 
            clear ampmat
            ampmatP_B=temp;
        end
    end
   if updateSpec==0, figure(1); end 
    h1=subplot('position',posInfo.Spec1PosB2);cla
    imagesc(flipud(ampmatP_B'))
   if guiHandles.Sub100HzCheck1.Value
        if B_lograte<2, 
            yticks=[size(ampmatP_B,2)-size(ampmatP_B,2)/5:size(ampmatP_B,2)/25:size(ampmatP_B,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B,2)-size(ampmatP_B,2)/5 size(ampmatP_B,2)]) 
             hold on;plot([0 100],[97 97],'r--')
        
        else
            yticks=[size(ampmatP_B,2)-size(ampmatP_B,2)/10:size(ampmatP_B,2)/50:size(ampmatP_B,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B,2)-size(ampmatP_B,2)/10 size(ampmatP_B,2)])  
            hold on;plot([0 100],[197 197],'r--')
                
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
       
   else
        yticks=[1:(size(ampmatP_B,2))/10:size(ampmatP_B,2) size(ampmatP_B,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(h1,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
   end
   ylabel('freq Hz')
   xlabel('');
   
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

        if updateSpec==0
            waitbar(.55,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
            for k=1:length(vars)
                ampmat{k}=PTthrSpec(T1,data3B{k},sampFreq);
            end
            if guiHandles.Spec1Select.Value==5 | guiHandles.Spec1Select.Value==6, 
                temp=ampmat{1}-ampmat{2}; 
                clear ampmat
                ampmatY_B=temp;
             else
                temp=ampmat{1}; 
                clear ampmat
                ampmatY_B=temp;
            end
        end
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec1PosB3);cla
        imagesc(flipud(ampmatY_B'))
       if guiHandles.Sub100HzCheck1.Value
            if B_lograte<2, 
                yticks=[size(ampmatY_B,2)-size(ampmatY_B,2)/5:size(ampmatY_B,2)/25:size(ampmatY_B,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B,2)-size(ampmatY_B,2)/5 size(ampmatY_B,2)]) 
                hold on;plot([0 100],[97 97],'r--')
            
               
            else
                yticks=[size(ampmatY_B,2)-size(ampmatY_B,2)/10:size(ampmatY_B,2)/50:size(ampmatY_B,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B,2)-size(ampmatY_B,2)/10 size(ampmatY_B,2)])  
                 hold on;plot([0 100],[197 197],'r--')
                
            end  
            set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');
            
       else
            yticks=[1:(size(ampmatY_B,2))/10:size(ampmatY_B,2) size(ampmatY_B,2)];
            set(h1,'fontsize',fontsz,'CLim',[0 climScale],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if B_lograte<2, set(h1,'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}]), end
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
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec1PosB3);
        set(h1,'xticklabels',{})
        xlabel('')
        delete(h1)
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec1PosB2);
        set(h1,'xticklabels',{'0','20','40','60','80','100' })
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
clear vars
vars=guiHandles.Spec2Select.Value;
if guiHandles.Spec2Select.Value==5, vars=[3 4]; end
if guiHandles.Spec2Select.Value==6, vars=[2 4]; end

if ~isempty(filenameA)   
    try      
    
    if updateSpec==0
        clear data1A data2A data3A
        if guiHandles.Spec2Select.Value<10
            for k=1:length(vars)
                eval(['data1A{k}=' char(datSelectionStringA(vars(k))) '(1,RC_PID_Thresh_A);';])
                eval(['data2A{k}=' char(datSelectionStringA(vars(k))) '(2,RC_PID_Thresh_A);';])
                if guiHandles.Spec2Select.Value<8, eval(['data3A{k}=' char(datSelectionStringA(vars(k))) '(3,RC_PID_Thresh_A);';]), end
            end
        end
        if guiHandles.Spec2Select.Value==10
            eval(['data1A{1}=' char(datSelectionStringA(vars(k))) '(1,RC_PID_Thresh_A);';])
            eval(['data2A{1}=' char(datSelectionStringA(vars(k))) '(2,RC_PID_Thresh_A);';])
         end
         if guiHandles.Spec2Select.Value==11
            eval(['data1A{1}=' char(datSelectionStringA(vars(k))) '(3,RC_PID_Thresh_A);';])
            eval(['data2A{1}=' char(datSelectionStringA(vars(k))) '(4,RC_PID_Thresh_A);';])
        end

        T1=DATtmpA.RCRate(4,RC_PID_Thresh_A);
    end
    
    multiplier=.2;
    sampFreq=A_lograte*1000;
    
    catch
    end
    
    clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat

    try
    if updateSpec==0
        waitbar(.6,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
        for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data1A{k},sampFreq);
        end
        if guiHandles.Spec2Select.Value==5 | guiHandles.Spec2Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatR_A2=temp;
         else
            temp=ampmat{1}; 
            clear ampmat
            ampmatR_A2=temp;
        end
    end
   
    xticks=[1 size(ampmatR_A2,1)/5:size(ampmatR_A2,1)/5:size(ampmatR_A2,1)];
    if updateSpec==0, figure(1); end
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
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A2,2)-size(ampmatR_A2,2)/5 size(ampmatR_A2,2)]) 
              hold on;plot([0 100],[97 97],'r--')
              
         
        else
            yticks=[size(ampmatR_A2,2)-size(ampmatR_A2,2)/10:size(ampmatR_A2,2)/50:size(ampmatR_A2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_A2,2)-size(ampmatR_A2,2)/10 size(ampmatR_A2,2)]) 
            hold on;plot([0 100],[197 197],'r--')
                
               
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
      
   else
        yticks=[1:(size(ampmatR_A2,2))/10:size(ampmatR_A2,2) size(ampmatR_A2,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if A_lograte<2, set(h1,'yticklabels',[{}]), end
   end
    %xlabel('% throttle')
  %  ylabel('freq Hz')
    xlabel('');    
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
    if updateSpec==0
        waitbar(.65,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');        
        for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data2A{k},sampFreq);
        end
        if guiHandles.Spec2Select.Value==5 | guiHandles.Spec2Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatP_A2=temp;
         else
            temp=ampmat{1}; 
            clear ampmat
            ampmatP_A2=temp;
        end
    end
    if updateSpec==0, figure(1); end
    h1=subplot('position',posInfo.Spec2PosA2);cla
    imagesc(flipud(ampmatP_A2'))
   if guiHandles.Sub100HzCheck2.Value
        if A_lograte<2, 
            yticks=[size(ampmatP_A2,2)-size(ampmatP_A2,2)/5:size(ampmatP_A2,2)/25:size(ampmatP_A2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A2,2)-size(ampmatP_A2,2)/5 size(ampmatP_A2,2)]) 
            hold on;plot([0 100],[97 97],'r--')
         
        else
            yticks=[size(ampmatP_A2,2)-size(ampmatP_A2,2)/10:size(ampmatP_A2,2)/50:size(ampmatP_A2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_A2,2)-size(ampmatP_A2,2)/10 size(ampmatP_A2,2)])  
            hold on;plot([0 100],[197 197],'r--')
                
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
   
   else
        yticks=[1:(size(ampmatP_A2,2))/10:size(ampmatP_A2,2) size(ampmatP_A2,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if A_lograte<2, set(h1,'yticklabels',[{}]), end
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

         if updateSpec==0
             waitbar(.7,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
             for k=1:length(vars)
                ampmat{k}=PTthrSpec(T1,data3A{k},sampFreq);
             end
            if guiHandles.Spec2Select.Value==5 | guiHandles.Spec2Select.Value==6, 
                temp=ampmat{1}-ampmat{2}; 
                clear ampmat
                ampmatY_A2=temp;
             else
                temp=ampmat{1}; 
                clear ampmat
                ampmatY_A2=temp;
            end
        end
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec2PosA3);cla
        imagesc(flipud(ampmatY_A2'))
       if guiHandles.Sub100HzCheck2.Value
            if A_lograte<2, 
                yticks=[size(ampmatY_A2,2)-size(ampmatY_A2,2)/5:size(ampmatY_A2,2)/25:size(ampmatY_A2,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A2,2)-size(ampmatY_A2,2)/5 size(ampmatY_A2,2)]) 
                 hold on;plot([0 100],[97 97],'r--')
         
            else
                yticks=[size(ampmatY_A2,2)-size(ampmatY_A2,2)/10:size(ampmatY_A2,2)/50:size(ampmatY_A2,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_A2,2)-size(ampmatY_A2,2)/10 size(ampmatY_A2,2)])  
                hold on;plot([0 100],[197 197],'r--')
                
            end  
            set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{},'xminortick','on','yminortick','on','tickdir','out');
      
       else
            yticks=[1:(size(ampmatY_A2,2))/10:size(ampmatY_A2,2) size(ampmatY_A2,2)];
            set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{},'xminortick','on','yminortick','on','tickdir','out');
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if A_lograte<2, set(h1,'yticklabels',[{}]), end
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
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec2PosA3);
        set(h1,'xticklabels',{})
        xlabel('')
        delete(h1)
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec2PosA2);
        set(h1,'xticklabels',{'0','20','40','60','80','100' })
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

clear vars
vars=guiHandles.Spec2Select.Value;
if guiHandles.Spec2Select.Value==5, vars=[3 4]; end
if guiHandles.Spec2Select.Value==6, vars=[2 4]; end

if ~isempty(filenameB)  
    try
        
    if updateSpec==0
        clear data1B data2B data3B 
        if guiHandles.Spec2Select.Value<10
            for k=1:length(vars)
                eval(['data1B{k}=' char(datSelectionStringB(vars(k))) '(1,RC_PID_Thresh_B);';])
                eval(['data2B{k}=' char(datSelectionStringB(vars(k))) '(2,RC_PID_Thresh_B);';])
                if guiHandles.Spec2Select.Value<8, eval(['data3B{k}=' char(datSelectionStringB(vars(k))) '(3,RC_PID_Thresh_B);';]), end
            end
        end
       if guiHandles.Spec2Select.Value==10
            eval(['data1B{1}=' char(datSelectionStringB(vars(k))) '(1,RC_PID_Thresh_B);';])
            eval(['data2B{1}=' char(datSelectionStringB(vars(k))) '(2,RC_PID_Thresh_B);';])
         end
         if guiHandles.Spec2Select.Value==11
            eval(['data1B{1}=' char(datSelectionStringB(vars(k))) '(3,RC_PID_Thresh_B);';])
            eval(['data2B{1}=' char(datSelectionStringB(vars(k))) '(4,RC_PID_Thresh_B);';])
        end

        T1=DATtmpB.RCRate(4,RC_PID_Thresh_B);
    end

    sampFreq=B_lograte*1000;  
   
    clear a b AMP FREQS segment_length fftTemp segment_vector GyroRawSegments GyroRawSegmentsFFT Throttle_m fA PA temp ampmat
    if updateSpec==0
        waitbar(.75,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
        for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data1B{k},sampFreq);
        end
        if guiHandles.Spec2Select.Value==5 | guiHandles.Spec2Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatR_B2=temp;
         else
            temp=ampmat{1}; 
            clear ampmat
            ampmatR_B2=temp;
        end
    end

    xticks=[1 size(ampmatR_B2,1)/5:size(ampmatR_B2,1)/5:size(ampmatR_B2,1)];
    if updateSpec==0, figure(1); end
    h1=subplot('position',posInfo.Spec2PosB1);cla
    imagesc(flipud(ampmatR_B2'))
   if guiHandles.Sub100HzCheck2.Value
        if B_lograte<2, 
            yticks=[size(ampmatR_B2,2)-size(ampmatR_B2,2)/5:size(ampmatR_B2,2)/25:size(ampmatR_B2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B2,2)-size(ampmatR_B2,2)/5 size(ampmatR_B2,2)]) 
              hold on;plot([0 100],[97 97],'r--')
        
        else
            yticks=[size(ampmatR_B2,2)-size(ampmatR_B2,2)/10:size(ampmatR_B2,2)/50:size(ampmatR_B2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatR_B2,2)-size(ampmatR_B2,2)/10 size(ampmatR_B2,2)]) 
             hold on;plot([0 100],[197 197],'r--')
                
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
  
   else
       yticks=[1:(size(ampmatR_B2,2))/10:size(ampmatR_B2,2) size(ampmatR_B2,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(h1,'yticklabels',[{}]), end
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
    if updateSpec==0
        waitbar(.8,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');   
        for k=1:length(vars)
            ampmat{k}=PTthrSpec(T1,data2B{k},sampFreq);
        end
        if guiHandles.Spec2Select.Value==5 | guiHandles.Spec2Select.Value==6, 
            temp=ampmat{1}-ampmat{2}; 
            clear ampmat
            ampmatP_B2=temp;
         else
            temp=ampmat{1}; 
            clear ampmat
            ampmatP_B2=temp;
        end
    end
    if updateSpec==0, figure(1); end
    h1=subplot('position',posInfo.Spec2PosB2);cla
    imagesc(flipud(ampmatP_B2'))
   if guiHandles.Sub100HzCheck2.Value
        if B_lograte<2, 
            yticks=[size(ampmatP_B2,2)-size(ampmatP_B2,2)/5:size(ampmatP_B2,2)/25:size(ampmatP_B2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B2,2)-size(ampmatP_B2,2)/5 size(ampmatP_B2,2)]) 
            hold on;plot([0 100],[97 97],'r--')
         
        else
            yticks=[size(ampmatP_B2,2)-size(ampmatP_B2,2)/10:size(ampmatP_B2,2)/50:size(ampmatP_B2,2)];
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatP_B2,2)-size(ampmatP_B2,2)/10 size(ampmatP_B2,2)])  
              hold on;plot([0 100],[197 197],'r--')
                
        end  
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
   
   else
        yticks=[1:(size(ampmatP_B2,2))/10:size(ampmatP_B2,2) size(ampmatP_B2,2)];
        set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ },'xminortick','on','yminortick','on','tickdir','out');
        set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
        if B_lograte<2, set(h1,'yticklabels',[{}]), end
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
        if updateSpec==0
            waitbar(.85,hw,'computing fft for throttle x freq heatmaps...','windowstyle', 'modal');
            for k=1:length(vars)
                ampmat{k}=PTthrSpec(T1,data3B{k},sampFreq);
            end
            if guiHandles.Spec2Select.Value==5 | guiHandles.Spec2Select.Value==6, 
                temp=ampmat{1}-ampmat{2}; 
                clear ampmat
                ampmatY_B2=temp;
             else
                temp=ampmat{1}; 
                clear ampmat
                ampmatY_B2=temp;
            end
        end
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec2PosB3);cla
        imagesc(flipud(ampmatY_B2'))
       if guiHandles.Sub100HzCheck2.Value
            if B_lograte<2, 
                yticks=[size(ampmatY_B2,2)-size(ampmatY_B2,2)/5:size(ampmatY_B2,2)/25:size(ampmatY_B2,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B2,2)-size(ampmatY_B2,2)/5 size(ampmatY_B2,2)]) 
                hold on;plot([0 100],[97 97],'r--')
         
            else
                yticks=[size(ampmatY_B2,2)-size(ampmatY_B2,2)/10:size(ampmatY_B2,2)/50:size(ampmatY_B2,2)];
                set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmatY_B2,2)-size(ampmatY_B2,2)/10 size(ampmatY_B2,2)])  
                      hold on;plot([0 100],[197 197],'r--')
                
            end  
            set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{ '0','20','40','60','80','100'},'xminortick','on','yminortick','on','tickdir','out');
       
       else
            yticks=[1:(size(ampmatY_B2,2))/10:size(ampmatY_B2,2) size(ampmatY_B2,2)];
            set(h1,'fontsize',fontsz,'CLim',[0 climScale2],'YTick',[yticks],'yticklabels',[{}],'XTick',[xticks],'xticklabels',{'0','20','40','60','80','100' },'xminortick','on','yminortick','on','tickdir','out');
            set(h1,'PlotBoxAspectRatioMode','auto','ylim',[min(yticks) max(yticks)])
            if B_lograte<2, set(h1,'yticklabels',[{}]), end
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
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec2PosB3);
        set(h1,'xticklabels',{})
        xlabel('')
        delete(h1)
        if updateSpec==0, figure(1); end
        h1=subplot('position',posInfo.Spec2PosB2);
        set(h1,'xticklabels',{'0','20','40','60','80','100' })
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
% reset
updateSpec=0;

try
close(hw)
catch
end
set(PTfig, 'pointer', 'arrow')

else
% reset
updateSpec=0;
end
