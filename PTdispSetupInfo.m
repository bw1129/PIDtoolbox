%% PTdispSetupInfo 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster) 
    if Nfiles < 2 
        str=strings(size(dataA(guiHandlesInfo.FileNumDispA.Value).SetupInfo,1),1);
        str(:)=':'; str2=strcat(dataA(guiHandlesInfo.FileNumDispA.Value).SetupInfo(:,1), char(str));
        setupA=strcat(str2, string(dataA(guiHandlesInfo.FileNumDispA.Value).SetupInfo(:,2))); 
    else
        str=strings(size(dataA(guiHandlesInfo.FileNumDispA.Value).SetupInfo,1),1);
        str(:)=':'; str2=strcat(dataA(guiHandlesInfo.FileNumDispA.Value).SetupInfo(:,1), char(str));
        setupA=strcat(str2, string(dataA(guiHandlesInfo.FileNumDispA.Value).SetupInfo(:,2))); 
        
        str=strings(size(dataA(guiHandlesInfo.FileNumDispB.Value).SetupInfo,1),1);
        str(:)=':'; str2=strcat(dataA(guiHandlesInfo.FileNumDispB.Value).SetupInfo(:,1), char(str));
        setupB=strcat(str2, string(dataA(guiHandlesInfo.FileNumDispB.Value).SetupInfo(:,2)));
    end
     
    BGCol = [];
    try
        for i = 1 : size(setupA,1)
            if strcmp(setupA{i}, setupB{i})
                BGCol(i,:) = [1 1 1];
            else
                BGCol(i,:) = [1 .7 .7];
            end
        end
    catch
        BGCol=[1 1 1];
    end
    u=[];
    u = (sum(BGCol,2)/3) < 1;

    if guiHandlesInfo.checkboxDIFF.Value == 1
         t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupA(u)))]);
         set(t,'units','normalized','OuterPosition',[.02 .05 .45 .9],'FontSize',fontsz, 'ColumnName', [fnameMaster{guiHandlesInfo.FileNumDispA.Value}])
         set(t,'BackgroundColor', [1 .7 .7])
        if Nfiles > 1
              t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupB(u)))]);
              set(t,'units','normalized','OuterPosition',[.52 .05 .45 .9],'FontSize',fontsz, 'ColumnName', fnameMaster{guiHandlesInfo.FileNumDispB.Value})
              set(t,'BackgroundColor', [1 .7 .7])
        end
    else
        t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupA))]);
         set(t,'units','normalized','OuterPosition',[.02 .05 .45 .9],'FontSize',fontsz, 'ColumnName', [fnameMaster{guiHandlesInfo.FileNumDispA.Value}])
         set(t,'BackgroundColor', [BGCol])
        if Nfiles > 1
              t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupB))]);
              set(t,'units','normalized','OuterPosition',[.52 .05 .45 .9],'FontSize',fontsz, 'ColumnName', fnameMaster{guiHandlesInfo.FileNumDispB.Value})
              set(t,'BackgroundColor', [BGCol])
        end
    end
end

    