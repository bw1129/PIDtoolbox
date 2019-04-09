%% PTdispSetupInfo - script to 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
if ~isempty(filenameA) || ~isempty(filenameB)

    PTdisp=figure(5);
    screensz = get(0,'ScreenSize');
    set(PTdisp, 'units','normalized','outerposition',[.1 .1 .75 .8])
    PTdisp.NumberTitle='off';
    PTdisp.Name= 'PIDtoolbox Setup Info';
    set(PTdisp,'color',bgcolor)

    prop_max_screen=(max([PTdisp.Position(3) PTdisp.Position(4)]));
    fontsz5=14;
    columnWidth=800*prop_max_screen;

    if ~isempty(filenameA)
        if size(dataA.SetupInfo,2)>1
            str=strings(size(dataA.SetupInfo,1),1);
            str(:)=':'; str2=strcat(dataA.SetupInfo(:,1), char(str));
            setupA=strcat(str2, string(dataA.SetupInfo(:,2)));
        else
            setupA=dataA.SetupInfo;
        end
    end
    if ~isempty(filenameB)
        if size(dataB.SetupInfo,2)>1
            str=strings(size(dataB.SetupInfo,1),1);
            str(:)=':'; str2=strcat(dataB.SetupInfo(:,1), char(str));
            setupB=strcat(str2, string(dataB.SetupInfo(:,2)));
        else
            setupB=dataB.SetupInfo;
        end
    end

    if ~isempty(filenameA) & ~isempty(filenameB)  
        if length(setupA)==length(setupB)      
            t = uitable('ColumnName',{filenameA; filenameB},'ColumnWidth',{columnWidth columnWidth},'ColumnFormat',{'char' 'char'},'Data',[cellstr(char(setupA)) cellstr(char(setupB))]);
            set(t,'units','normalized','OuterPosition',[.05 .05 .9 .9],'FontSize',fontsz5)
        end
        if length(setupA)>length(setupB)  
            clear btmp
            btmp = strings(size(setupA)); 
            btmp(1:length(setupB),:)=setupB;
            t = uitable('ColumnName',{filenameA; filenameB},'ColumnWidth',{columnWidth columnWidth},'ColumnFormat',{'char' 'char'},'Data',[cellstr(char(setupA)) cellstr(char(btmp))]);
            set(t,'units','normalized','OuterPosition',[.05 .05 .9 .9],'FontSize',fontsz5)
        end
        if length(setupB)>length(setupA)  
            clear btmp
            btmp = strings(size(setupB)); 
            btmp(1:length(setupA),:)=setupA;
            t = uitable('ColumnName',{filenameA; filenameB},'ColumnWidth',{columnWidth columnWidth},'ColumnFormat',{'char' 'char'},'Data',[cellstr(char(btmp)) cellstr(string(setupB))]);
            set(t,'units','normalized','OuterPosition',[.05 .05 .9 .9],'FontSize',fontsz5)
        end
    end
    if ~isempty(filenameA) & isempty(filenameB)
          t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupA))]);
          set(t,'units','normalized','OuterPosition',[.05 .05 .9 .9],'FontSize',fontsz5)
    end
    if isempty(filenameA) & ~isempty(filenameB)
          t = uitable('ColumnWidth',{columnWidth},'ColumnFormat',{'char'},'Data',[cellstr(char(setupB))]);
          set(t,'units','normalized','OuterPosition',[.05 .05 .9 .9],'FontSize',fontsz5)
    end

else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end
    