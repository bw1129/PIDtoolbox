%% PTplotSpec - script that computes and plots spectrograms 


% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster) 
   
prop_max_screen=(max([PTspecfig.Position(3) PTspecfig.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);
%% update fonts 
guiHandlesSpec.computeSpec.FontSize=fontsz;
guiHandlesSpec.checkbox2d.FontSize=fontsz;
guiHandlesSpec.ColormapSelect.FontSize=fontsz;
guiHandlesSpec.smoothFactor_select.FontSize=fontsz;
guiHandlesSpec.saveFig2.FontSize=fontsz;
guiHandlesSpec.resetSpec.FontSize=fontsz;
guiHandlesSpec.specPresets.FontSize=fontsz;
guiHandlesSpec.controlFreqCutoff_text.FontSize=fontsz;
guiHandlesSpec.controlFreq1Cutoff.FontSize=fontsz;
guiHandlesSpec.controlFreq2Cutoff.FontSize=fontsz;
guiHandlesSpec.checkboxPSD.FontSize=fontsz;

guiHandlesSpec.climMax_text.FontSize=fontsz;
guiHandlesSpec.climMax_input.FontSize=fontsz;
guiHandlesSpec.climMax_text2.FontSize=fontsz;
guiHandlesSpec.climMax_input2.FontSize=fontsz;
guiHandlesSpec.climMax_text3.FontSize=fontsz;
guiHandlesSpec.climMax_input3.FontSize=fontsz;
guiHandlesSpec.climMax_text4.FontSize=fontsz;
guiHandlesSpec.climMax_input4.FontSize=fontsz;

guiHandlesSpec.SpecSelect{1}.FontSize=fontsz;
guiHandlesSpec.SpecSelect{2}.FontSize=fontsz;
guiHandlesSpec.SpecSelect{3}.FontSize=fontsz;
guiHandlesSpec.SpecSelect{4}.FontSize=fontsz;
guiHandlesSpec.FileSelect{1}.FontSize=fontsz;
guiHandlesSpec.FileSelect{2}.FontSize=fontsz;
guiHandlesSpec.FileSelect{3}.FontSize=fontsz;
guiHandlesSpec.FileSelect{4}.FontSize=fontsz;
guiHandlesSpec.Sub100HzCheck{1}.FontSize=fontsz;
guiHandlesSpec.Sub100HzCheck{2}.FontSize=fontsz;
guiHandlesSpec.Sub100HzCheck{3}.FontSize=fontsz;
guiHandlesSpec.Sub100HzCheck{4}.FontSize=fontsz;

guiHandlesSpec.AphasedelayText1 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{1}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{1}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText1]);
guiHandlesSpec.AphasedelayText2 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{2}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{2}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText2]);
guiHandlesSpec.AphasedelayText3 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{3}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{3}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText3]);
guiHandlesSpec.AphasedelayText4 = uicontrol(PTspecfig,'style','text','string',['Gyro: ' PhaseDelay_A{guiHandlesSpec.FileSelect{4}.Value} 'ms Dterm: ' PhaseDelay2_A{guiHandlesSpec.FileSelect{4}.Value} 'ms'],'fontsize',fontsz,'TooltipString', [TooltipString_phase],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.AphasedelayText4]);

guiHandlesSpec.climMax_input = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 1))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 1)=str2num(guiHandlesSpec.climMax_input.String);updateSpec=1;PTplotSpec;');

guiHandlesSpec.climMax_input2 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 2))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input2],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 2)=str2num(guiHandlesSpec.climMax_input2.String);updateSpec=1;PTplotSpec;');
 
guiHandlesSpec.climMax_input3 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 3))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input3],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 3)=str2num(guiHandlesSpec.climMax_input3.String);updateSpec=1;PTplotSpec;');
 
guiHandlesSpec.climMax_input4 = uicontrol(PTspecfig,'style','edit','string',[num2str(climScale(guiHandlesSpec.checkboxPSD.Value+1, 4))],'fontsize',fontsz,'TooltipString',[TooltipString_scale],'units','normalized','outerposition',[posInfo.climMax_input4],...
     'callback','@textinput_call2; climScale(guiHandlesSpec.checkboxPSD.Value+1, 4)=str2num(guiHandlesSpec.climMax_input4.String);updateSpec=1;PTplotSpec;');

%%

s1={'';'gyroADC';'debug';'piderr';'setpoint';'axisP';'axisD';'axisDpf';'pidsum'};

datSelectionString=[s1];

clear vars
for i=1:4
    vars(i)=guiHandlesSpec.SpecSelect{i}.Value;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%% compute fft %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if guiHandlesSpec.SpecSelect{1}.Value>1 | guiHandlesSpec.SpecSelect{2}.Value>1 | guiHandlesSpec.SpecSelect{3}.Value>1 | guiHandlesSpec.SpecSelect{4}.Value>1
    set(PTspecfig, 'pointer', 'watch')
    if updateSpec==0 
        clear s dat ampmat amp2d freq a RC smat amp2d freq2d Throt
        p=0;
         hw = waitbar(0,['please wait... ' ]); 

        for k=1:length(vars)       
            s=char(datSelectionString(vars(k)));
            for a=1:3,    
                if  ( ( ~isempty(strfind(s,'axisD'))) & a==3) | isempty(s)
                    p=p+1;
                    smat{p}=[];%string
                    ampmat{p}=[];%spec matrix
                    freq{p}=[];% freq matrix
                    amp2d{p}=[];%spec 2d
                    freq2d{p}=[];% freq2d                 
                else   
                    eval(['dat{k}(a,:) = T{guiHandlesSpec.FileSelect{k}.Value}.' char(datSelectionString(vars(k))) '_' int2str(a-1) '_(tIND{guiHandlesSpec.FileSelect{k}.Value});';])                    
                    Throt=T{guiHandlesSpec.FileSelect{k}.Value}.setpoint_3_(tIND{guiHandlesSpec.FileSelect{k}.Value}) / 10;% throttle
                    lograte = A_lograte(guiHandlesSpec.FileSelect{k}.Value);%in kHz
                    p=p+1;
                    waitbar(p/12, hw, ['processing spectrogram... '  int2str(p) ]); 
                    smat{p}=s;
                    [freq{p} ampmat{p}]=PTthrSpec(Throt, dat{k}(a,:), lograte, guiHandlesSpec.checkboxPSD.Value); % compute matrices 
                    [freq2d{p} amp2d{p}]=PTSpec2d(dat{k}(a,:),lograte, guiHandlesSpec.checkboxPSD.Value); %compute 2d amp spec at same time
               end
            end 
        end
        close(hw)
    end
else
    hwarn=warndlg({'Dropdowns set to ''NONE''.'; 'Please select a preset or specific variables to analyze.'});
    pause(3);
    try
        close(hwarn);
    catch
    end
end

if guiHandlesSpec.checkbox2d.Value==0 && ~isempty(ampmat)
    figure(PTspecfig);
    %%%%% plot spec mattrices
    c1=[1 1 1 2 2 2 3 3 3 4 4 4];
    c2=[1 2 3 1 2 3 1 2 3 1 2 3];
    baselineY = [0 -40];
    ftr = fspecial('gaussian',[guiHandlesSpec.smoothFactor_select.Value*5 guiHandlesSpec.smoothFactor_select.Value],4);
    for p=1:size(ampmat,2)   
        delete(subplot('position',posInfo.SpecPos(p,:)));      
        if ~isempty(ampmat{p})
            delete(subplot('position',posInfo.SpecPos(p,:)));
            h1=subplot('position',posInfo.SpecPos(p,:)); cla
            img = flipud((filter2(ftr, ampmat{p} ))') + baselineY(guiHandlesSpec.checkboxPSD.Value+1);
            imagesc(img); 

            lograte=A_lograte(guiHandlesSpec.FileSelect{c1(p)}.Value);

             axLabel={'roll';'pitch';'yaw'};
            
            if guiHandlesSpec.Sub100HzCheck{c1(p)}.Value==1
            hold on;h=plot([0 100],[size(ampmat{p},2)-round(Flim1/3.33) size(ampmat{p},2)-round(Flim1/3.33)],'y--');set(h,'linewidth',2) 
            hold on;h=plot([0 100],[size(ampmat{p},2)-round(Flim2/3.33) size(ampmat{p},2)-round(Flim2/3.33)],'y--');set(h,'linewidth',2)
                % sub100Hz scaling
                if lograte>1
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[size(ampmat{p},2)-size(ampmat{p},2)/10:size(ampmat{p},2)/50:size(ampmat{p},2)];
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmat{p},2)-size(ampmat{p},2)/10 size(ampmat{p},2)])  
                    set(h1,'fontsize',fontsz,'CLim',[baselineY(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    a=[];a2=[];a=filter2(ftr, ampmat{p}) + baselineY(guiHandlesSpec.checkboxPSD.Value+1);
                    a2 = a(:,(round(Flim1/3.33))+1:(round(Flim2/3.33)));
                    meanspec=nanmean(a2(:));
                    peakspec=max(max(a(:,(round(Flim1/3.33))+1:(round(Flim2/3.33)))));              
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                        h=text(64,size(ampmat{p},2)*.904,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.912,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.904,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.912,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                    end
                    h=text(xticks(1)+1,size(ampmat{p},2)*.904,axLabel{c2(p)});
                    set(h,'Color',[1 1 1],'fontsize',fontsz,'fontweight','bold') 
                else
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[size(ampmat{p},2)-size(ampmat{p},2)/5:size(ampmat{p},2)/25:size(ampmat{p},2)];
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmat{p},2)-size(ampmat{p},2)/5 size(ampmat{p},2)])
                    set(h1,'fontsize',fontsz,'CLim',[baselineY(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    a=[];a2=[];a=filter2(ftr, ampmat{p}) + baselineY(guiHandlesSpec.checkboxPSD.Value+1);
                    a2 = a(:,(round(Flim1/3.33))+1:(round(Flim2/3.33)));
                    meanspec=nanmean(a2(:));
                    peakspec=max(max(a(:,(round(Flim1/3.33))+1:(round(Flim2/3.33)))));
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10          
                        h=text(64,size(ampmat{p},2)*.808,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.825,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.808,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.825,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                    end  
                    h=text(xticks(1)+1,size(ampmat{p},2)*.808,axLabel{c2(p)});
                    set(h,'Color',[1 1 1],'fontsize',fontsz,'fontweight','bold')   
                end                      
            else % full scaling
                if lograte>1
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[1:(size(ampmat{p},2))/10:size(ampmat{p},2) size(ampmat{p},2)];
                    set(h1,'fontsize',fontsz,'CLim',[baselineY(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[1 size(ampmat{p},2)])
                    a=[];a2=[];a=filter2(ftr, ampmat{p}) + baselineY(guiHandlesSpec.checkboxPSD.Value+1);
                    a2 = a(:,30:300);
                    meanspec=nanmean(a2(:));
                    peakspec=max(max(a(:,30:300)));
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                    end
                else
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[1:(size(ampmat{p},2))/10:size(ampmat{p},2) size(ampmat{p},2)];
                    set(h1,'fontsize',fontsz,'CLim',[baselineY(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'YTick',[yticks],'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[1 size(ampmat{p},2)])  
                    a=[];a2=[];a=filter2(ftr, ampmat{p}) + baselineY(guiHandlesSpec.checkboxPSD.Value+1);
                    a2 = a(:,30:150);
                    meanspec=nanmean(a2(:));
                    peakspec=max(max(a(:,30:150)));
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz,'fontweight','bold');
                    end
                end      
                h=text(xticks(1)+1,size(ampmat{p},2)*.04,axLabel{c2(p)});
                set(h,'Color',[1 1 1],'fontsize',fontsz,'fontweight','bold')   
            end
            
                        
            grid on
            ax = gca;
            ax.GridColor = [1 1 1]; 
            if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                ax.GridColor = [0 0 0]; % black on white background
                set(h,'Color',[0 0 0],'fontsize',fontsz,'fontweight','bold')             
            end
             ylabel('Frequency (Hz)','fontweight','bold') 
             xlabel('% Throttle','fontweight','bold') 
        end 
    end

    % color bar2 at the top 
    try
    delete(hCbar1);delete(hCbar2);delete(hCbar3);delete(hCbar4)
    catch
    end
    if vars(1)>1 % 1=none
        subplot('position',posInfo.SpecPos(1,:));
        hCbar1= colorbar('NorthOutside');
        set(hCbar1,'Position', [posInfo.hCbar1pos]);
    end
    if vars(2)>1 % 1=none
        subplot('position',posInfo.SpecPos(4,:));
        hCbar2= colorbar('NorthOutside');
        set(hCbar2,'Position', [posInfo.hCbar2pos])
    end
    if vars(3)>1 % 1=none
        subplot('position',posInfo.SpecPos(7,:));
        hCbar3= colorbar('NorthOutside');
        set(hCbar3,'Position', [posInfo.hCbar3pos])
    end
    if vars(4)>1 % 1=none
        subplot('position',posInfo.SpecPos(10,:));
        hCbar4= colorbar('NorthOutside');
        set(hCbar4,'Position', [posInfo.hCbar4pos])
    end

    % color maps
    % standard set
    if guiHandlesSpec.ColormapSelect.Value<8,
        colormap(char(guiHandlesSpec.ColormapSelect.String(guiHandlesSpec.ColormapSelect.Value)));
    end
    % new
    if guiHandlesSpec.ColormapSelect.Value==8, colormap(viridis); end
    if guiHandlesSpec.ColormapSelect.Value==9, colormap(linearREDcmap); end 
    if guiHandlesSpec.ColormapSelect.Value==10, colormap(linearGREYcmap); end

end

if guiHandlesSpec.checkbox2d.Value==1 && ~isempty(amp2d)
    figure(PTspecfig);
    try
    delete(hCbar1);delete(hCbar2);delete(hCbar3);delete(hCbar4)
    catch
    end
    baselineYlines = [0 -50];
    c1=[1 1 1 2 2 2 3 3 3 4 4 4];
    c2=[1 2 3 1 2 3 1 2 3 1 2 3]; 
    %%%%% plot 2d amp spec
    for p=1:size(amp2d,2)
         axLabel={'roll';'pitch';'yaw'};
       
        delete(subplot('position',posInfo.SpecPos(p,:)));
        if ~isempty(amp2d{p})
            h2=subplot('position',posInfo.SpecPos(p,:)); cla
            h=plot(freq2d{p}, smooth(amp2d{p}, log10(size(amp2d{p},1)) * (guiHandlesSpec.smoothFactor_select.Value^2), 'lowess'));hold on
            set(h, 'linewidth', guiHandles.linewidth.Value)
            set(h2,'fontsize',fontsz,'fontweight','bold')
            if guiHandlesSpec.specPresets.Value <= 3
                set(h,'Color',[SpecLineCols(c1(p),:,1)])
            end
            if guiHandlesSpec.specPresets.Value > 4 && guiHandlesSpec.specPresets.Value <= 6
                set(h,'Color',[SpecLineCols(c1(p),:,2)])
            end
            if guiHandlesSpec.specPresets.Value > 6
                set(h,'Color',[SpecLineCols(c1(p),:,3)])
            end
            if max(freq2d{p})<=500,
                if guiHandlesSpec.Sub100HzCheck{c1(p)}.Value==1
                    set(h2,'xtick',[0 20 40 60 80 100],'yminortick','on')
                    axis([0 100 baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+3, c1(p))])
                    h=plot([round(Flim1) round(Flim1)],[baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'k--');
                    set(h,'linewidth',1)
                    h=plot([round(Flim2) round(Flim2)],[baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'k--');
                    set(h,'linewidth',1)
                else    
                    set(h2,'xtick',[0 100 200 300 400 500], 'yminortick','on')
                    axis([0 500 baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))])
                end
            else
                if guiHandlesSpec.Sub100HzCheck{c1(p)}.Value==1
                    set(h2,'xtick',[0 20 40 60 80 100], 'yminortick','on')
                    axis([0 100 baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))])
                    h=plot([round(Flim1) round(Flim1)],[baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'k--');
                    set(h,'linewidth',1)
                    h=plot([round(Flim2) round(Flim2)],[baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))],'k--');
                    set(h,'linewidth',1)
                else    
                    set(h2,'xtick',[0 200 400 600 800 1000],'yminortick','on')
                    axis([0 1000 baselineYlines(guiHandlesSpec.checkboxPSD.Value+1) climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))])
                end
            end 
            xlabel('Frequency (Hz)')
            if guiHandlesSpec.checkboxPSD.Value
                ylabel(['PSD (dB)'])
            else
                ylabel(['Amplitude'])
            end
                

            h=text(2,climScale(guiHandlesSpec.checkboxPSD.Value+1, c1(p))*.95,axLabel{c2(p)});
            set(h,'Color',[.2 .2 .2],'fontsize',fontsz,'fontweight','bold')

            grid on
        end
    end
end
set(PTspecfig, 'pointer', 'arrow')
updateSpec=0;

end

