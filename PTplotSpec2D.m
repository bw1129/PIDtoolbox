%% PTplotSpec2D - script that computes and plots spectrograms 


% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster) 
%% update fonts 
prop_max_screen=(max([PTspecfig2.Position(3) PTspecfig2.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);

f = fields(guiHandlesSpec2);
for i = 1 : size(f,1)
    eval(['guiHandlesSpec2.' f{i} '.FontSize=fontsz;']);
end

spec2Crtlpanel.FontSize = fontsz;

guiHandlesSpec2.climMax1_text = uicontrol(PTspecfig2,'style','text','string','Y min','fontsize',fontsz,'TooltipString',['Y min'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax1_text]);
guiHandlesSpec2.climMax1_input = uicontrol(PTspecfig2,'style','edit','string',[num2str(climScale1(guiHandlesSpec2.checkboxPSD.Value+1, 1))],'fontsize',fontsz,'TooltipString',['Y min'],'units','normalized','outerposition',[posInfo.climMax1_input],...
     'callback','@textinput_call2; climScale1(guiHandlesSpec2.checkboxPSD.Value+1, 1)=str2num(guiHandlesSpec2.climMax1_input.String);updateSpec=1;PTplotSpec2D;');

 guiHandlesSpec2.climMax2_text = uicontrol(PTspecfig2,'style','text','string','Y max','fontsize',fontsz,'TooltipString',['Y max'],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.climMax2_text]);
guiHandlesSpec2.climMax2_input = uicontrol(PTspecfig2,'style','edit','string',[num2str(climScale2(guiHandlesSpec2.checkboxPSD.Value+1, 1))],'fontsize',fontsz,'TooltipString',['Y max'],'units','normalized','outerposition',[posInfo.climMax2_input],...
     'callback','@textinput_call2; climScale2(guiHandlesSpec2.checkboxPSD.Value+1, 1)=str2num(guiHandlesSpec2.climMax2_input.String);updateSpec=1;PTplotSpec2D;');


%%

s1={'gyroADC';'debug';'axisD';'axisDpf';'axisP';'piderr';'setpoint';'pidsum'};

datSelectionString=[s1];
axesOptionsSpec = find([guiHandlesSpec2.plotR.Value guiHandlesSpec2.plotP.Value guiHandlesSpec2.plotY.Value]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%% compute fft %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(PTspecfig2, 'pointer', 'watch')

clear s dat a RC smat amp2d2 freq2d2 
p=0;
hw = waitbar(0,['please wait... ' ]); 
for k = 1 : length(guiHandlesSpec2.SpecList.Value)      
    s = char(datSelectionString(guiHandlesSpec2.SpecList.Value(k)));
    for f = 1 : size(guiHandlesSpec2.FileSelect.Value,2)
        for a = axesOptionsSpec    
            if  ( ( ~isempty(strfind(s,'axisD'))) & a==3) | isempty(s)
                p=p+1;
                smat{p}=[];%string
                amp2d2{p}=[];%spec 2d
                freq2d2{p}=[];% freq2d2                 
            else   
                p = p + 1;
                clear dat
                eval(['dat = T{guiHandlesSpec2.FileSelect.Value(f)}.' char(datSelectionString(guiHandlesSpec2.SpecList.Value(k))) '_' int2str(a-1) '_(tIND{guiHandlesSpec2.FileSelect.Value(f)})'';';])                    
                lograte = A_lograte(guiHandlesSpec2.FileSelect.Value(f));%in kHz
                waitbar(p, hw, ['processing spectrogram... '  int2str(p) ]); 
                smat{p}=s;
                eval(['[freq2d2{p}.f' int2str(f) ' amp2d2{p}.f' int2str(f) ' ]=PTSpec2d(dat,lograte, guiHandlesSpec2.checkboxPSD.Value);']) %compute 2d amp spec at same time
            end
       end
    end 
end
close(hw)




figure(PTspecfig2);
baselineYlines = [0 -50];
multilineStyle = {'-' ; ':'; '--'};
rpyLineStyle = {'-' ; '--'; ':'};

delete(subplot('position',posInfo.Spec2Pos(1,:))) 
delete(subplot('position',posInfo.Spec2Pos(2,:)))
delete(subplot('position',posInfo.Spec2Pos(3,:)))
delete(subplot('position',posInfo.Spec2Pos(4,:)))
delete(subplot('position',posInfo.Spec2Pos(5,:)))
delete(subplot('position',posInfo.Spec2Pos(6,:)))
%%%%% plot 2d amp spec
axLabel={'Roll';'Pitch';'Yaw'};

p = 0; 
for k = 1 : length(guiHandlesSpec2.SpecList.Value)      
    s = char(datSelectionString(k));
    for f = 1 : size(guiHandlesSpec2.FileSelect.Value,2)
        cnt = 0;
        for a = axesOptionsSpec 
            cnt = cnt + 1;
            p = p + 1;
            if ~isempty(freq2d2)
                if ~isempty(freq2d2{p}) && ~isempty(amp2d2{p})
                    
                    if guiHandlesSpec2.RPYcomboSpec.Value == 0
                        
                        h2=subplot('position',posInfo.Spec2Pos(a,:)); 
                        eval(['h=plot(freq2d2{p}.f' int2str(f) ', smooth(amp2d2{p}.f' int2str(f) ', log10(size(amp2d2{p}.f' int2str(f) ',1)) * (guiHandlesSpec2.smoothFactor_select.Value^3), ''lowess''));hold on'])
                        hold on
                        set(h, 'linewidth', guiHandles.linewidth.Value/2,'linestyle',multilineStyle{k})
                        set(h2,'fontsize',fontsz)
                        set(h,'Color',[multiLineCols(f,:)]) 
                        eval(['m = (A_lograte(guiHandlesSpec2.FileSelect.Value(f)) * 1000) / 2;'])
                        set(h2,'xtick',[0:m/10:m], 'yminortick','on')
                        axis([0 m climScale1(guiHandlesSpec2.checkboxPSD.Value+1) climScale2(guiHandlesSpec2.checkboxPSD.Value+1)])             
                        xlabel('Frequency (Hz)','fontweight','bold');
                        if guiHandlesSpec2.checkboxPSD.Value
                            ylabel(['Power Spectral Density (dB)'],'fontweight','bold');
                        else
                            ylabel(['Amplitude'],'fontweight','bold');
                        end
                        if a == 1
                            title('Full Spectrum','fontweight','bold');
                        end
                        if p < 4
                        h=text(2,climScale2(guiHandlesSpec2.checkboxPSD.Value+1)*.92,axLabel{a});
                        set(h,'Color',[.2 .2 .2],'fontsize',fontsz,'fontweight','bold');
                        end
                        grid on

                        h2=subplot('position',posInfo.Spec2Pos(a+3,:)); 
                        eval(['h=plot(freq2d2{p}.f' int2str(f) ', smooth(amp2d2{p}.f' int2str(f) ', log10(size(amp2d2{p}.f' int2str(f) ',1)) * (guiHandlesSpec2.smoothFactor_select.Value^3), ''lowess''));hold on'])
                        hold on
                        set(h, 'linewidth', guiHandles.linewidth.Value/2,'linestyle',multilineStyle{k})
                        set(h2,'fontsize',fontsz)
                        set(h,'Color',[multiLineCols(f,:)]) 
                        eval(['m = (A_lograte(guiHandlesSpec2.FileSelect.Value(f)) * 1000) / 2;'])
                        set(h2,'xtick',[0 20 40 60 80 100],'yminortick','on')
                        axis([0 100 climScale1(guiHandlesSpec2.checkboxPSD.Value+1) climScale2(guiHandlesSpec2.checkboxPSD.Value+1)]) 
                        xlabel('Frequency (Hz)','fontweight','bold');
                        if guiHandlesSpec2.checkboxPSD.Value
                            ylabel(['Power Spectral Density (dB)'],'fontweight','bold');
                        else
                            ylabel(['Amplitude'],'fontweight','bold');
                        end
                        if a == 1
                            title('Sub 100Hz','fontweight','bold');
                        end
                        if p < 4
                        h=text(1,climScale2(guiHandlesSpec2.checkboxPSD.Value+1)*.92,axLabel{a});
                        set(h,'Color',[.2 .2 .2],'fontsize',fontsz,'fontweight','bold');
                        end
                        
                        %%%%%%%%%%%%%%%%%%% Plot Latencies %%%%%%%%%%%%%%%
                        if guiHandlesSpec2.Delay.Value == 1 && a == 1
                            if debugmode(guiHandlesSpec2.FileSelect.Value(f)) == GYRO_SCALED || debugmode(guiHandlesSpec2.FileSelect.Value(f)) == 1 || debugmode(guiHandlesSpec2.FileSelect.Value(f)) == 0 
                                h=text(65, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['Gyro Filter: ' Debug01{guiHandlesSpec2.FileSelect.Value(f)} 'ms | Dterm Filter: ' FilterDelayDterm{guiHandlesSpec2.FileSelect.Value(f)} 'ms']);
                                set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz);
                            else
                                h=text(65, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['Gyro Filter: ' 'ms | Dterm Filter: ' FilterDelayDterm{guiHandlesSpec2.FileSelect.Value(f)} 'ms']);
                                set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz);
                            end
                        end
                        if guiHandlesSpec2.Delay.Value == 2
                            h=text(80, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['SP-Gyro: ' int2str(SPGyroDelay(guiHandlesSpec2.FileSelect.Value(f), a)) 'ms']);
                            set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz); 
                        end
                        if guiHandlesSpec2.Delay.Value == 3  && a == 1
                            if debugmode(guiHandlesSpec2.FileSelect.Value(f)) == RC_INTERPOLATION || debugmode(guiHandlesSpec2.FileSelect.Value(f)) == FEEDFORWARD 
                                h=text(75, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['SP smoothing delay: ' Debug02{guiHandlesSpec2.FileSelect.Value(f)} 'ms']);
                                set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz);
                            else
                                h=text(80, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['debug mode not set ']);
                                set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz);
                            end    
                        end
                         if guiHandlesSpec2.Delay.Value == 4 && a == 1
                            if debugmode(guiHandlesSpec2.FileSelect.Value(f)) == GYRO_SCALED || debugmode(guiHandlesSpec2.FileSelect.Value(f)) == 1 || debugmode(guiHandlesSpec2.FileSelect.Value(f)) == 0 
                                h=text(65, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['Gyro Phase: ' num2str(gyro_phase_shift_deg(guiHandlesSpec2.FileSelect.Value(f))) 'deg | Dterm Phase: ' num2str(dterm_phase_shift_deg(guiHandlesSpec2.FileSelect.Value(f))) 'deg']);
                                set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz);
                            else
                                h=text(65, climScale2(guiHandlesSpec2.checkboxPSD.Value+1)-(f*4), ['Gyro Phase: ' 'deg | Dterm Phase: ' num2str(dterm_phase_shift_deg(uiHandlesSpec2.FileSelect.Value(f))) 'deg']);
                                set(h,'Color',[multiLineCols(f,:)],'fontsize',fontsz);
                            end
                        end

                    
                    else
                        % combine R P Y
                        h2=subplot('position',[0.0500    0.1000    0.800    0.840]); 
                        eval(['h=plot(freq2d2{p}.f' int2str(f) ', smooth(amp2d2{p}.f' int2str(f) ', log10(size(amp2d2{p}.f' int2str(f) ',1)) * (guiHandlesSpec2.smoothFactor_select.Value^3), ''lowess''));hold on'])
                        hold on
                        if k == 1
                            set(h, 'linewidth', guiHandles.linewidth.Value/1.4,'linestyle',rpyLineStyle{cnt})
                        end
                        if k == 2
                            set(h, 'linewidth', guiHandles.linewidth.Value/2.6,'linestyle',rpyLineStyle{cnt})
                        end
                        set(h2,'fontsize',fontsz)
                        set(h,'Color',[multiLineCols(f,:)]) 
                        eval(['m = (A_lograte(guiHandlesSpec2.FileSelect.Value(f)) * 1000) / 2;'])
                        set(h2,'xtick',[0:m/10:m], 'yminortick','on')
                        axis([0 m climScale1(guiHandlesSpec2.checkboxPSD.Value+1) climScale2(guiHandlesSpec2.checkboxPSD.Value+1)])             
                        xlabel('Frequency (Hz)','fontweight','bold');
                        if guiHandlesSpec2.checkboxPSD.Value
                            ylabel(['Power Spectral Density (dB)'],'fontweight','bold');
                        else
                            ylabel(['Amplitude'],'fontweight','bold');
                        end
                        if a == 1
                            title('Full Spectrum','fontweight','bold');
                        end
                        grid on

                    
                    end
                    
                    grid on

                else
                end
            end
        end
    end
end

l=0;legnd={};
l2=0;
for m = 1 : length(guiHandlesSpec2.SpecList.Value)
    for n = 1 : length(guiHandlesSpec2.FileSelect.Value)
        l = l + 1;
        clear fstr fltDelayStr
        fstr = char(guiHandlesSpec2.FileSelect.String(guiHandlesSpec2.FileSelect.Value(n)));
        if size(fstr,2) > 12, fstr = fstr(1,1:12); end % only use first 20 characters of file name
        if guiHandlesSpec2.RPYcomboSpec.Value == 0
            legnd{l} = [char(guiHandlesSpec2.SpecList.String(guiHandlesSpec2.SpecList.Value(m))) ' | ' fstr];     
        else
            for a = axesOptionsSpec
                l2 = l2 + 1;
                legnd{l2} = [axLabel{a} ' | ' char(guiHandlesSpec2.SpecList.String(guiHandlesSpec2.SpecList.Value(m))) ' | ' fstr ];
            end
        end
    end
end
if ~isempty(freq2d2) && ~isempty(amp2d2)
    if guiHandlesSpec2.RPYcomboSpec.Value == 0
        h=legend(legnd);     
        h.Position = [0.88 0.33-h.Position(4) h.Position(3:4)];
    else
        h=legend(legnd, 'Location','NorthEast')
    end
end


set(PTspecfig2, 'pointer', 'arrow')
updateSpec=0;
end


