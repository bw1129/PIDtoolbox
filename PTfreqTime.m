%% PTtimeFreq - time freq spectrogram

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    

%% update fonts 
set(PTspecfig3, 'pointer', 'watch')

figure(PTspecfig3)
prop_max_screen=(max([PTspecfig3.Position(3) PTspecfig3.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);

f = fields(guiHandlesSpec3);
for i = 1 : size(f,1)
    eval(['guiHandlesSpec3.' f{i} '.FontSize=fontsz;']);
end

specSmoothFactors = [1 5 10 20];
timeSmoothFactors = [1 2 5 10];

if guiHandlesSpec3.sub100HzfreqTime.Value
    fLim_freqTime = 100;
else
    fLim_freqTime = 1000;
end

s1={'gyroADC';'debug';'axisD';'axisDpf';'axisP';'piderr';'setpoint';'pidsum'};
datSelectionString=[s1];
axisLabel ={'Roll'; 'Pitch' ; 'Yaw'};
for i = 1 : 3
    delete(subplot('position',posInfo.Spec3Pos(i,:))); 
    try
    if ~updateSpec      
        eval(['dat = T{guiHandlesSpec3.FileSelect.Value}.' char(datSelectionString(guiHandlesSpec3.SpecList.Value)) '_' int2str(i-1) '_(tIND{guiHandlesSpec3.FileSelect.Value})'';';]) 
        [Tm F specMat{i}] = PTtimeFreqCalc(dat', A_lograte(guiHandlesSpec3.FileSelect.Value), specSmoothFactors(guiHandlesSpec3.smoothFactor_select.Value), timeSmoothFactors(guiHandlesSpec3.subsampleFactor_select.Value));
    end
    
    h2=subplot('position',posInfo.Spec3Pos(i,:));
    h = imagesc(specMat{i});

    set(gca,'Clim',[ClimScale3], 'fontsize',fontsz,'fontweight','bold')
    title('');
    a=get(gca,'Ylabel');
    a.String = ['Frequency (Hz) ' axisLabel{i}];
    a=get(gca,'Xlabel');
    a.String = 'Time (sec)';
    F2 = F(F<=fLim_freqTime);
    freqStr = flipud(int2str((0: F2(end) / 5: F2(end))'));
    timeStr = int2str((0: round(Tm(end)) / 10: round(Tm(end)))');
    
    st = find(fliplr(F<=fLim_freqTime),1, 'first');
    nd = find(fliplr(F<=fLim_freqTime),1, 'last');
    set(gca,'YLim', [st nd])
    set(gca,'Ytick', [st : (nd-st) / 5: nd], 'YTickLabel',[freqStr], 'YMinorTick', 'on', 'Xtick', [0 : round( (size(specMat{i},2)-1) / 10) : size(specMat{i},2)],'XTickLabel',[timeStr], 'XMinorTick', 'on', 'TickDir', 'out');
        
    if guiHandlesSpec3.ColormapSelect.Value<8,
        colormap(char(guiHandlesSpec3.ColormapSelect.String(guiHandlesSpec3.ColormapSelect.Value)));
    end
    % new
    if guiHandlesSpec3.ColormapSelect.Value==8, colormap(viridis); end
    if guiHandlesSpec3.ColormapSelect.Value==9, colormap(linearREDcmap); end 
    if guiHandlesSpec3.ColormapSelect.Value==10, colormap(linearGREYcmap); end
    cbar = colorbar('EastOutside');
    cbar.Label.String = 'Power Spectral density (dB)';
  
    if i == 3 && (strcmp(char(datSelectionString(guiHandlesSpec3.SpecList.Value)), 'axisD') || strcmp(char(datSelectionString(guiHandlesSpec3.SpecList.Value)), 'axisDpf'))
        delete(subplot('position',posInfo.Spec3Pos(i,:))); 
    end
    box off
    
    catch
        delete(subplot('position',posInfo.Spec3Pos(i,:))); 
    end
end
updateSpec = 0;

set(PTspecfig3, 'pointer', 'arrow')

