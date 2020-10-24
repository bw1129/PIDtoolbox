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
    PTdisp.Name= ['PIDtoolbox (' PtbVersion ') -  Setup Info'];
    set(PTdisp,'color',bgcolor)
    prop_max_screen=(max([PTdisp.Position(3) PTdisp.Position(4)]));
    fontsz5=round(screensz_multiplier*prop_max_screen);

    setupMap = containers.Map;
    if ~isempty(filenameA)
        if size(dataA.SetupInfo,2)>1
            for i = 1:size(dataA.SetupInfo,1)
                vals = strings(1,2);
                vals(1,1) = dataA.SetupInfo(i,2);
                setupMap(dataA.SetupInfo(i,1))=vals;
            end
        else
            vals = strings(1,2);
            vals(1,1) = dataA.SetupInfo;
            setupMap("setup")=vals;
        end
    end
    if ~isempty(filenameB)
        if size(dataB.SetupInfo,2)>1
            for i = 1:size(dataB.SetupInfo,1)
                if isKey(setupMap, dataB.SetupInfo(i,1))
                    vals = setupMap(dataB.SetupInfo(i,1));
                else
                    vals = strings(1,2);
                end
                vals(1,2) = dataB.SetupInfo(i,2);
                setupMap(dataB.SetupInfo(i,1))=vals;
            end
        else
            if isKey(setupMap, "setup")
                vals = setupMap("setup");
            else
                vals = strings(1,2);
            end
            vals(1,2) = dataB.SetupInfo;
            setupMap("setup")=vals;
        end
    end

    setupKeys = keys(setupMap);
    setupMapSize = size(setupKeys,2);
    tabledata = strings(setupMapSize, 3);
    for k = 1:setupMapSize
        setupKey = char(setupKeys(k));
        setupVals = setupMap(setupKey);
        val1 = setupVals(1,1);
        val2 = setupVals(1,2);
        if ((~isempty(filenameA)) && (~isempty(filenameB)) && (val1 ~= val2))
            tabledata(k,1) = "<html><b>" + setupKey + "</b></html>";
            tabledata(k,2) = "<html><b>" + val1 + "</b></html>";
            tabledata(k,3) = "<html><b>" + val2 + "</b></html>";
        else
            tabledata(k,1) = setupKey;
            tabledata(k,2) = val1 + " ";
            tabledata(k,3) = val2 + " ";
        end
    end
    t = uitable('ColumnName',{"Parameter"; filenameA; filenameB},'ColumnWidth',{'auto' 'auto' 'auto'},'ColumnFormat',{'char' 'char' 'char'},'Data',[cellstr(char(tabledata(:,1))) cellstr(char(tabledata(:,2))) cellstr(char(tabledata(:,3)))] );
    set(t,'units','normalized','OuterPosition',[.05 .05 .9 .9],'FontSize',fontsz5)
    

else
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end
