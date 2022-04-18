%% PTsaveSettings

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

%% create saveDirectory
if ~isempty(fnameMaster) 
  

%%
set(gcf, 'pointer', 'watch')
try
    cd(main_directory)
    clear defaults
    if ~isfile('PTBdefaults.txt')
        clear var
        var(1,:) = [{'firmware'  1}];
        var(2,:) = [{'LogViewer-SinglePanel' 0}];
        var(3,:) = [{'LogViewer-plotR' 1}];
        var(4,:) = [{'LogViewer-plotP' 1}];
        var(5,:) = [{'LogViewer-plotY' 1}];
        var(6,:) = [{'LogViewer-lineSmooth' 1}];
        var(7,:) = [{'LogViewer-lineWidth' 3}];  
        var(8,:) = [{'LogViewer-Ymax' 500}];
        var(9,:) = [{'LogViewer-Ncolors' 8}]; 
        var(10,:) = [{'spec2D-term1' 1}];
        var(11,:) = [{'spec2D-term2' 2}];
        var(12,:) = [{'spec2D-smoothing' 3}];
        var(13,:) = [{'spec2D-delay' 1}];
        var(14,:) = [{'spec2D-plotR' 1}];
        var(15,:) = [{'spec2D-plotP' 1}];
        var(16,:) = [{'spec2D-plotY' 1}];
        var(17,:) = [{'spec2D-SinglePanel' 0}];    
        var(18,:) = [{'FreqXthr-Column1' 3}];
        var(19,:) = [{'FreqXthr-Column2' 2}];
        var(20,:) = [{'FreqXthr-Column3' 8}];
        var(21,:) = [{'FreqXthr-Column4' 7}]; 
        var(22,:) = [{'FreqXthr-Preset' 1}];
        var(23,:) = [{'FreqXthr-Colormap' 3}];
        var(24,:) = [{'FreqXthr-Smoothing' 3}];
        var(25,:) = [{'FreqxTime-Preset' 2}];
        var(26,:) = [{'FreqxTime-FreqSmoothing' 2}];
        var(27,:) = [{'FreqxTime-TimeSmoothing' 2}];
        var(28,:) = [{'FreqxTime-Colormap' 3}];
        var(29,:) = [{'StepResp-plotR' 1}];
        var(30,:) = [{'StepResp-plotP' 1}];
        var(31,:) = [{'StepResp-plotY' 1}];
        var(32,:) = [{'StepResp-SinglePanel' 0}];
        var(33,:) = [{'StepResp-Ymax' 1.75}];

        defaults = cell2table(var, 'VariableNames',{'Parameters' ; 'Values'});
    else
        defaults = readtable('PTBdefaults.txt');
    end
catch
end

try
    defaults(:,2).Values(1) = guiHandles.Firmware.Value;
    defaults(:,2).Values(2) = guiHandles.RPYcomboLV.Value;
    defaults(:,2).Values(3) = guiHandles.plotR.Value;
    defaults(:,2).Values(4) = guiHandles.plotP.Value;
    defaults(:,2).Values(5) = guiHandles.plotY.Value;
    defaults(:,2).Values(6) = guiHandles.lineSmooth.Value;
    defaults(:,2).Values(7) = guiHandles.linewidth.Value;
    defaults(:,2).Values(8) = str2num(guiHandles.maxY_input.String);
    defaults(:,2).Values(9) = str2num(guiHandles.nCols_input.String);
catch
end
try
    defaults(:,2).Values(10) = guiHandlesSpec2.SpecList.Value(1);
    defaults(:,2).Values(11) = guiHandlesSpec2.SpecList.Value(2);
    defaults(:,2).Values(12) = guiHandlesSpec2.smoothFactor_select.Value;
    defaults(:,2).Values(13) = guiHandlesSpec2.Delay.Value;
    defaults(:,2).Values(14) = guiHandlesSpec2.plotR.Value;
    defaults(:,2).Values(15) = guiHandlesSpec2.plotP.Value;
    defaults(:,2).Values(16) = guiHandlesSpec2.plotY.Value;
    defaults(:,2).Values(17) = guiHandlesSpec2.RPYcomboSpec.Value;
catch
end
try
    defaults(:,2).Values(18) = guiHandlesSpec.SpecSelect{1}.Value;
    defaults(:,2).Values(19) = guiHandlesSpec.SpecSelect{2}.Value;
    defaults(:,2).Values(20) = guiHandlesSpec.SpecSelect{3}.Value;
    defaults(:,2).Values(21) = guiHandlesSpec.SpecSelect{4}.Value;
    defaults(:,2).Values(22) = guiHandlesSpec.specPresets.Value;
    defaults(:,2).Values(23) = guiHandlesSpec.ColormapSelect.Value;
    defaults(:,2).Values(24) = guiHandlesSpec.smoothFactor_select.Value;
catch
end

try
    defaults(:,2).Values(25) = guiHandlesSpec3.SpecList.Value;
    defaults(:,2).Values(26) = guiHandlesSpec3.smoothFactor_select.Value;
    defaults(:,2).Values(27) = guiHandlesSpec3.subsampleFactor_select.Value;
    defaults(:,2).Values(28) = guiHandlesSpec3.ColormapSelect.Value;
catch
end
try
    defaults(:,2).Values(29) = guiHandlesTune.plotR.Value;
    defaults(:,2).Values(30) = guiHandlesTune.plotP.Value;
    defaults(:,2).Values(31) = guiHandlesTune.plotY.Value;
    defaults(:,2).Values(32) = guiHandlesTune.RPYcombo.Value;
    defaults(:,2).Values(33) = str2num(guiHandlesTune.maxYStepInput.String);
catch
end

try
    writetable(defaults, 'PTBdefaults')
catch
end

try    
    fid = fopen('logfileDir.txt','r');
    logfile_directory = fscanf(fid, '%c');
    fclose(fid);
catch
    logfile_directory = [pwd '/'];
end

ldr = ['logfileDirectory: ' logfile_directory ];

try
    defaults = readtable('PTBdefaults.txt');
    a = char([cellstr([char(defaults.Parameters) num2str(defaults.Values)]); {rdr}; {mdr}; {ldr}]);
    t = uitable(PTfig,'ColumnWidth',{500},'ColumnFormat',{'char'},'Data',[cellstr(a)]);
    set(t,'units','normalized','OuterPosition',[.89 vPos-.82 .105 .3],'FontSize',fontsz*.8, 'ColumnName', [''])
catch
    defaults = ' '; 
    a = char(['Unable to set user defaults '; {rdr}; {mdr}; {ldr}]);
    t = uitable(PTfig,'ColumnWidth',{500},'ColumnFormat',{'char'},'Data',[cellstr(a)]);
    set(t,'units','normalized','OuterPosition',[.89 vPos-.82 .105 .3],'FontSize',fontsz*.8, 'ColumnName', [''])
end

clear var

set(gcf, 'pointer', 'arrow')

else
     warndlg('Please select file(s)');
end