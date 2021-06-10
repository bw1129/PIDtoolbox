%% PTdispSetupInfo - script to 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster) 
    if Nfiles < 2 
        str=strings(size(dataA(guiHandles.FileNumDispA.Value).SetupInfo,1),1);
        str(:)=':'; str2=strcat(dataA(guiHandles.FileNumDispA.Value).SetupInfo(:,1), char(str));
        setupA=strcat(str2, string(dataA(guiHandles.FileNumDispA.Value).SetupInfo(:,2))); 
    else
        str=strings(size(dataA(guiHandles.FileNumDispA.Value).SetupInfo,1),1);
        str(:)=':'; str2=strcat(dataA(guiHandles.FileNumDispA.Value).SetupInfo(:,1), char(str));
        setupA=strcat(str2, string(dataA(guiHandles.FileNumDispA.Value).SetupInfo(:,2))); 
        
        str=strings(size(dataA(guiHandles.FileNumDispB.Value).SetupInfo,1),1);
        str(:)=':'; str2=strcat(dataA(guiHandles.FileNumDispB.Value).SetupInfo(:,1), char(str));
        setupB=strcat(str2, string(dataA(guiHandles.FileNumDispB.Value).SetupInfo(:,2)));
     end

     t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupA))]);
     set(t,'units','normalized','OuterPosition',[.02 .05 .45 .9],'FontSize',fontsz, 'ColumnName', [fnameMaster])
    if Nfiles > 1
          t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupB))]);
          set(t,'units','normalized','OuterPosition',[.52 .05 .45 .9],'FontSize',fontsz, 'ColumnName', fnameMaster{guiHandles.FileNumDispB.Value})
    end
end

    