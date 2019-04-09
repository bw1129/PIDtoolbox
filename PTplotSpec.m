%% PTplotSpec - script that computes and plots spectrograms 


% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) || ~isempty(filenameB)
   
%% update fonts 
prop_max_screen=(max([PTspecfig.Position(3) PTspecfig.Position(4)]));
fontsz2=round(screensz_multiplier*prop_max_screen);

guiHandlesSpec.computeSpec.FontSize=fontsz2;
guiHandlesSpec.checkbox2d.FontSize=fontsz2;
guiHandlesSpec.percentMotor.FontSize=fontsz2;
guiHandlesSpec.ColormapSelect.FontSize=fontsz2;
guiHandlesSpec.smoothFactor_select.FontSize=fontsz2;
guiHandlesSpec.subsampleFactor.FontSize=fontsz2;
guiHandlesSpec.AphasedelayText.FontSize=fontsz2;
guiHandlesSpec.BphasedelayText.FontSize=fontsz2;
guiHandlesSpec.saveFig2.FontSize=fontsz2;

guiHandlesSpec.climMax_text.FontSize=fontsz2;
guiHandlesSpec.climMax_input.FontSize=fontsz2;
guiHandlesSpec.climMax_text2.FontSize=fontsz2;
guiHandlesSpec.climMax_input2.FontSize=fontsz2;
guiHandlesSpec.climMax_text3.FontSize=fontsz2;
guiHandlesSpec.climMax_input3.FontSize=fontsz2;
guiHandlesSpec.climMax_text4.FontSize=fontsz2;
guiHandlesSpec.climMax_input4.FontSize=fontsz2;

guiHandlesSpec.SpecSelect{1}.FontSize=fontsz2;
guiHandlesSpec.SpecSelect{2}.FontSize=fontsz2;
guiHandlesSpec.SpecSelect{3}.FontSize=fontsz2;
guiHandlesSpec.SpecSelect{4}.FontSize=fontsz2;
guiHandlesSpec.Sub100HzCheck{1}.FontSize=fontsz2;
guiHandlesSpec.Sub100HzCheck{2}.FontSize=fontsz2;
guiHandlesSpec.Sub100HzCheck{3}.FontSize=fontsz2;
guiHandlesSpec.Sub100HzCheck{4}.FontSize=fontsz2;


%%
if A_debugmode==DSHOT_RPM_TELEMETRY % DSHOT_RPM_TELEMETRY
    s1={'';'DATtmpA.GyroFilt';'DATtmpA.PIDerr';'DATtmpA.RCRate';'DATtmpA.Pterm';'DATtmpA.DtermFilt';'DATtmpA.DtermRaw';'DATtmpA.Motor';'DATtmpA.Motor';'DATtmpA.debug';'DATtmpA.debug'};
else
    s1={'';'DATtmpA.GyroFilt';'DATtmpA.debug';'DATtmpA.PIDerr';'DATtmpA.RCRate';'DATtmpA.Pterm';'DATtmpA.DtermFilt';'DATtmpA.DtermRaw';'DATtmpA.Motor';'DATtmpA.Motor'};
end
if B_debugmode==DSHOT_RPM_TELEMETRY % DSHOT_RPM_TELEMETRY
    s2={'DATtmpB.GyroFilt';'DATtmpB.PIDerr';'DATtmpB.RCRate';'DATtmpB.Pterm';'DATtmpB.DtermFilt';'DATtmpB.DtermRaw';'DATtmpB.Motor';'DATtmpB.Motor';'DATtmpB.debug';'DATtmpB.debug'};  
else
    s2={'DATtmpB.GyroFilt';'DATtmpB.debug';'DATtmpB.PIDerr';'DATtmpB.RCRate';'DATtmpB.Pterm';'DATtmpB.DtermFilt';'DATtmpB.DtermRaw';'DATtmpB.Motor';'DATtmpB.Motor'};
end
datSelectionString=[s1; s2];

set(PTspecfig, 'pointer', 'watch')

clear vars
for i=1:4
    vars(i)=guiHandlesSpec.SpecSelect{i}.Value;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%% compute fft %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if updateSpec==0
   % hw = waitbar(.05,'computing fft for spectrograms...');    
   % frames = java.awt.Frame.getFrames();
   % frames(end).setAlwaysOnTop(1);
    clear dat ampmat amp2d freq a 
    p=0;
    for k=1:length(vars)       
        s=char(datSelectionString(vars(k)));
        for a=1:3,
            if  ((~isempty(strfind(s,'Dterm')) | ~isempty(strfind(s,'Motor')) | (~isempty(strfind(s,'DATtmpA.debug')) & A_debugmode==DSHOT_RPM_TELEMETRY) | (~isempty(strfind(s,'DATtmpB.debug')) & B_debugmode==DSHOT_RPM_TELEMETRY) ) & a==3) | isempty(s)
                p=p+1;
                smat{p}=[];%string
                ampmat{p}=[];%spec matrix
                freq{p}=[];% freq matrix
                amp2d{p}=[];%spec 2d
                freq2d{p}=[];% freq2d 
            else
                if ~isempty(strfind(s,'DATtmpA'))
                    eval(['dat{k}(a,:)=' char(datSelectionString(vars(k))) '(a,:);';])
                    if guiHandlesSpec.percentMotor.Value==2  
                        T=mean(DATtmpA.Motor);% motor output
                    else
                        T=DATtmpA.RCRate(4,:);% throttle
                    end
                    sampFreq=A_lograte;%in kHz
                else
                    eval(['dat{k}(a,:)=' char(datSelectionString(vars(k))) '(a,:);';])
                    if guiHandlesSpec.percentMotor.Value==2
                        T=mean(DATtmpB.Motor); % motor output
                    else
                        T=DATtmpB.RCRate(4,:); % throttle
                    end
                    sampFreq=B_lograte;%in kHz
                end
                p=p+1;
                smat{p}=s;
                [freq{p} ampmat{p}]=PTthrSpec(T,dat{k}(a,:),sampFreq, p, 12, guiHandlesSpec.subsampleFactor.Value); % compute matrices
                [freq2d{p} amp2d{p}]=PTSpec2d(dat{k}(a,:),sampFreq); %compute 2d amp spec at same time
            end
        end 
    end
   % close(hw);
end

if guiHandlesSpec.checkbox2d.Value==0 && ~isempty(ampmat)
    figure(PTspecfig);
    %%%%% plot spec mattrices
    c1=[1 1 1 2 2 2 3 3 3 4 4 4];
    c2=[1 2 3 1 2 3 1 2 3 1 2 3];
    ftr = fspecial('gaussian',[guiHandlesSpec.smoothFactor_select.Value*5 guiHandlesSpec.smoothFactor_select.Value],4);
    for p=1:size(ampmat,2)   
        delete(subplot('position',posInfo.SpecPos(p,:)));      
        if ~isempty(ampmat{p})
            delete(subplot('position',posInfo.SpecPos(p,:)));
            h1=subplot('position',posInfo.SpecPos(p,:)); cla
            
            imagesc(flipud((filter2(ftr, ampmat{p}))')) 
            hold on

            if strfind(smat{p},'DATtmpA')
                lograte=A_lograte;
            else
                lograte=B_lograte;
            end

             axLabel={'roll';'pitch';'yaw'};
            if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'Motors 1'), axLabel={'Motor 1';'Motor 2'}; end
            if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'Motors 3'), axLabel={'Motor 3';'Motor 4'}; end
            if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'RPM 1'), axLabel={'Motor 1';'Motor 2'}; end
            if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'RPM 3'), axLabel={'Motor 3';'Motor 4'}; end
            
            if guiHandlesSpec.Sub100HzCheck{c1(p)}.Value==1
            hold on;h=plot([0 100],[size(ampmat{p},2)-6 size(ampmat{p},2)-6],'y--');set(h,'linewidth',2)            
                % sub100Hz scaling
                if lograte>1
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[size(ampmat{p},2)-size(ampmat{p},2)/10:size(ampmat{p},2)/50:size(ampmat{p},2)];
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmat{p},2)-size(ampmat{p},2)/10 size(ampmat{p},2)])  
                    set(h1,'fontsize',fontsz2,'CLim',[0 climScale(c1(p))],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    a=[];a=(ampmat{p});
                    meanspec=mean(mean(a(:,7:30)));
                    peakspec=max(max(a(:,7:30)));              
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                        h=text(64,size(ampmat{p},2)*.904,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.912,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.904,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.912,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                    end
                    h=text(xticks(1)+1,size(ampmat{p},2)*.904,axLabel{c2(p)});
                    set(h,'Color',[1 1 1],'fontsize',fontsz2,'fontweight','bold') 
                else
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[size(ampmat{p},2)-size(ampmat{p},2)/5:size(ampmat{p},2)/25:size(ampmat{p},2)];
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[size(ampmat{p},2)-size(ampmat{p},2)/5 size(ampmat{p},2)])
                    set(h1,'fontsize',fontsz2,'CLim',[0 climScale(c1(p))],'YTick',[yticks],'yticklabels',[{100} {80} {60} {40} {20} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    a=[];a=(ampmat{p});
                    meanspec=mean(mean(a(:,7:30)));
                    peakspec=max(max(a(:,7:30)));
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10          
                        h=text(64,size(ampmat{p},2)*.808,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.825,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.808,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.825,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                    end  
                    h=text(xticks(1)+1,size(ampmat{p},2)*.808,axLabel{c2(p)});
                    set(h,'Color',[1 1 1],'fontsize',fontsz2,'fontweight','bold')   
                end                      
            else % full scaling
                if lograte>1
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[1:(size(ampmat{p},2))/10:size(ampmat{p},2) size(ampmat{p},2)];
                    set(h1,'fontsize',fontsz2,'CLim',[0 climScale(c1(p))],'YTick',[yticks],'yticklabels',[{1000} {''} {800} {''} {600} {''} {400} {''} {200} {''} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[1 size(ampmat{p},2)])
                    a=[];a=(ampmat{p});
                    meanspec=mean(mean(a(:,30:300)));
                    peakspec=max(max(a(:,30:300)));
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                    end
                else
                    xticks=[1 size(ampmat{p},1)/5:size(ampmat{p},1)/5:size(ampmat{p},1)];
                    yticks=[1:(size(ampmat{p},2))/10:size(ampmat{p},2) size(ampmat{p},2)];
                    set(h1,'fontsize',fontsz2,'CLim',[0 climScale(c1(p))],'YTick',[yticks],'yticklabels',[{500} {''} {400} {''} {300} {''} {200} {''} {100} {''} {0}],'XTick',[xticks],'xticklabels',{'0';'20';'40';'60';'80';'100'},'tickdir','out','xminortick','on','yminortick','on');
                    set(h1,'PlotBoxAspectRatioMode','auto','ylim',[1 size(ampmat{p},2)])  
                    a=[];a=(ampmat{p});
                    meanspec=mean(mean(a(:,30:150)));
                    peakspec=max(max(a(:,30:150)));
                    if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','k','fontsize',fontsz2,'fontweight','bold');
                    else
                        h=text(64,size(ampmat{p},2)*.04,['mean=' num2str(meanspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                        h=text(64,size(ampmat{p},2)*.13,['peak=' num2str(peakspec,3)]);
                        set(h,'Color','w','fontsize',fontsz2,'fontweight','bold');
                    end
                end      
                h=text(xticks(1)+1,size(ampmat{p},2)*.04,axLabel{c2(p)});
                set(h,'Color',[1 1 1],'fontsize',fontsz2,'fontweight','bold')   
            end
            
                        
            grid on
            ax = gca;
            ax.GridColor = [1 1 1]; 
            if guiHandlesSpec.ColormapSelect.Value==9 | guiHandlesSpec.ColormapSelect.Value==10
                ax.GridColor = [0 0 0]; % black on white background
                set(h,'Color',[0 0 0],'fontsize',fontsz2,'fontweight','bold')             
            end
             ylabel('freq Hz','fontweight','bold') 
             if guiHandlesSpec.percentMotor.Value==2  
                 xlabel('% motor output','fontweight','bold') 
             else   
                xlabel('% throttle','fontweight','bold') 
             end
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
    c2=[1 2 3 1 2 3 1 2 3 1 2 3]; 
    %%%%% plot 2d amp spec
    for p=1:size(amp2d,2)
         axLabel={'roll';'pitch';'yaw'};
         if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'Motors 1'), axLabel={'Motor 1';'Motor 2'};end
         if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'Motors 3'), axLabel={'Motor 3';'Motor 4'};end
         if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'RPM 1'), axLabel={'Motor 1';'Motor 2'}; end
         if strfind(char(guiHandlesSpec.SpecSelect{c1(p)}.String(vars(c1(p)))), 'RPM 3'), axLabel={'Motor 3';'Motor 4'}; end

        delete(subplot('position',posInfo.SpecPos(p,:)));
        if ~isempty(amp2d{p})
            h2=subplot('position',posInfo.SpecPos(p,:)); cla
            h=plot(freq2d{p}, amp2d{p});hold on
            set(h2,'fontsize',fontsz2,'fontweight','bold')
            if strfind(smat{p},'DATtmpA'), set(h,'Color',[colorA]), else, set(h,'Color',[colorB]), end
            if max(freq2d{p})<=500,
                if guiHandlesSpec.Sub100HzCheck{c1(p)}.Value==1
                    set(h2,'xtick',[0 20 40 60 80 100], 'ytick',[0 climScale(c1(p))*.25 climScale(c1(p))*.5 climScale(c1(p))*.75 climScale(c1(p))],'yminortick','on')
                    axis([0 100 0 climScale(c1(p))])
                    h=plot([20 20],[0 climScale(c1(p))],'y--');
                    set(h,'linewidth',2)
                else    
                    set(h2,'xtick',[0 100 200 300 400 500], 'ytick',[0 climScale(c1(p))*.25 climScale(c1(p))*.5 climScale(c1(p))*.75 climScale(c1(p))],'yminortick','on')
                    axis([0 500 0 climScale(c1(p))])
                end
            else
                if guiHandlesSpec.Sub100HzCheck{c1(p)}.Value==1
                    set(h2,'xtick',[0 20 40 60 80 100], 'ytick',[0 climScale(c1(p))*.25 climScale(c1(p))*.5 climScale(c1(p))*.75 climScale(c1(p))],'yminortick','on')
                    axis([0 100 0 climScale(c1(p))])
                    h=plot([20 20],[0 climScale(c1(p))],'y--');
                    set(h,'linewidth',2)
                else    
                    set(h2,'xtick',[0 200 400 600 800 1000], 'ytick',[0 climScale(c1(p))*.25 climScale(c1(p))*.5 climScale(c1(p))*.75 climScale(c1(p))],'yminortick','on')
                    axis([0 1000 0 climScale(c1(p))])
                end
            end 
            xlabel('freq hz')
            ylabel(['normalized amp'])

            h=text(2,climScale(c1(p))*.95,axLabel{c2(p)});
            set(h,'Color',[.2 .2 .2],'fontsize',fontsz2,'fontweight','bold')

            grid on
        end
    end
end

set(PTspecfig, 'pointer', 'arrow')
updateSpec=0;

end

