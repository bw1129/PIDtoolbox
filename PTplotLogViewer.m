%% PTplotLogViewer - script to plot main line graphs

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

% tic
if ~isempty(filenameA) || ~isempty(filenameB) 

    set(PTfig, 'pointer', 'watch')
    
    figure(1);

    maxY=1200;

    alpha_red=.8;
    alpha_blue=.8;

    prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));
    fontsz=(screensz_multiplier*prop_max_screen);

    % scale fonts according to size of window and/or screen
    guiHandles.fileA.FontSize=fontsz;
    guiHandles.fileB.FontSize=fontsz;
    guiHandles.runAll.FontSize=fontsz;
    guiHandles.Epoch1_A_text.FontSize=fontsz;
    guiHandles.Epoch1_A_Input.FontSize=fontsz;
    guiHandles.Epoch2_A_text.FontSize=fontsz;
    guiHandles.Epoch2_A_Input.FontSize=fontsz;
    guiHandles.Epoch1_B_text.FontSize=fontsz;
    guiHandles.Epoch1_B_Input.FontSize=fontsz;
    guiHandles.Epoch2_B_text.FontSize=fontsz;
    guiHandles.Epoch2_B_Input.FontSize=fontsz;
    guiHandles.spectrogramButton.FontSize=fontsz;
    guiHandles.PIDerrButton.FontSize=fontsz;
    guiHandles.TuningButton.FontSize=fontsz;
    guiHandles.DispInfoButton.FontSize=fontsz;
    guiHandles.saveFig.FontSize=fontsz;
    guiHandles.wiki.FontSize=fontsz;
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
    guiHandles.checkbox10.FontSize=fontsz;
    guiHandles.checkbox11.FontSize=fontsz;
    guiHandles.checkbox12.FontSize=fontsz;
    guiHandles.checkbox13.FontSize=fontsz;
    guiHandles.checkbox14.FontSize=fontsz;
    guiHandles.checkbox15.FontSize=fontsz;
    guiHandles.linewidth.FontSize=fontsz;
    controlpanel.FontSize=fontsz;
    
    if plotall_flag>=0 
        guiHandles.checkbox0.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox1.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox2.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox3.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox4.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox5.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox6.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox7.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox8.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox9.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox10.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox11.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox12.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox13.Value=guiHandles.checkbox15.Value;
        guiHandles.checkbox14.Value=guiHandles.checkbox15.Value;
    end
    plotall_flag=-1;

    %%%%%%%% ui filenames %%%%%%%
    if ~isempty(filenameA)
    guiHandles.fileA.FontWeight='bold';
    guiHandles.fnameAText = uicontrol(PTfig,'style','text','string',['A:' filenameA],'fontsize',fontsz*.8,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.fnameAText]);
    end
    if ~isempty(filenameB)
    guiHandles.fileB.FontWeight='bold';
    guiHandles.fnameBText = uicontrol(PTfig,'style','text','string',['B:' filenameB],'fontsize',fontsz*.8,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.fnameBText]);
    end


    %% posinfo
    posInfo.linepos1=[0.095 0.805 0.77 0.125];
    posInfo.linepos2=[0.095 0.675 0.77 0.125];
    posInfo.linepos3=[0.095 0.545 0.77 0.125];

    posInfo.linepos4=[0.095 0.39 0.77 0.125];
    posInfo.linepos5=[0.095 0.26 0.77 0.125];
    posInfo.linepos6=[0.095 0.13 0.77 0.125];

    expand_sz=[0.05 0.07 0.82 0.86];


    %% where you want full range of data
    if ~isempty(filenameA),
        y=[epoch1_A*us2sec epoch2_A*us2sec];%%% used for fill in unused data range
        t1=(tta(find(tta>y(1),1))) / us2sec;
        t2=(tta(find(tta>y(2),1))) / us2sec;  
    end

    if ~isempty(filenameB),
        y=[epoch1_B*us2sec epoch2_B*us2sec];
        t3=(ttb(find(ttb>y(1),1))) / us2sec;
        t4=(ttb(find(ttb>y(2),1))) / us2sec;  
    end

    %% log viewer line plots
    %%%%%%%% PLOT %%%%%%%
    axLabel={'roll';'pitch';'yaw'};

    PTfig;
    dcm_obj = datacursormode(PTfig);
    set(dcm_obj,'UpdateFcn',@PTdatatip);

     %%%% [A] LINE PLOTS
    if ~isempty(filenameA)
        for ii=1:3  
            if ~expandON,
                eval(['hlinepos' int2str(ii) '=subplot(' '''position''' ',posInfo.linepos' int2str(ii) ');cla;'])
            else
                eval(['if ~isempty(hexpand' int2str(ii) '),' 'subplot(hexpand' int2str(ii) ',' '''position''' ',expand_sz);cla; end'])
                warning off
            end

            if  ~expandON || (expandON && eval(['~isempty(hexpand' int2str(ii) ')']))
                xmax=max(tta/us2sec); 

                h=plot([0 xmax],[-maxY -maxY],'k');
                set(h,'linewidth',.2)
                hold on
                
                set(gca,'ytick',[2*-maxY -maxY -maxY+1 -600 0 600 maxY],'yticklabel',{'0%' '100%' '' '-600' '0' '600' ''},'YColor',[.2 .2 .2],'fontweight','bold') 
                set(gca,'xtick',[10:10:round(xmax-5)],'XColor',[.2 .2 .2])                 

                if expandON
                    if guiHandles.checkbox0.Value, h=plot(tta/us2sec, DATmainA.debug(ii,:));hold on;set(h,'color', [linec.col0],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox1.Value, h=plot(tta/us2sec, DATmainA.GyroFilt(ii,:));hold on;set(h,'color', [linec.col1],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox2.Value, h=plot(tta/us2sec, DATmainA.Pterm(ii,:));hold on;set(h,'color', [linec.col2],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox3.Value, h=plot(tta/us2sec, DATmainA.Iterm(ii,:));hold on;set(h,'color', [linec.col3],'LineWidth',guiHandles.linewidth.Value), end     
                    if guiHandles.checkbox4.Value && ii<3, h=plot(tta/us2sec, DATmainA.DtermRaw(ii,:));hold on;set(h,'color', [linec.col4],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox5.Value && ii<3, h=plot(tta/us2sec, DATmainA.DtermFilt(ii,:));hold on;set(h,'color', [linec.col5],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox6.Value, h=plot(tta/us2sec, DATmainA.Fterm(ii,:));hold on;set(h,'color', [linec.col6],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox7.Value, h=plot(tta/us2sec, DATmainA.RCRate(ii,:));hold on;set(h,'color', [linec.col7],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox8.Value, h=plot(tta/us2sec, DATmainA.PIDsum(ii,:));hold on;set(h,'color', [linec.col8],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox9.Value, h=plot(tta/us2sec, DATmainA.PIDerr(ii,:));hold on;set(h,'color', [linec.col9],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox10.Value, h=plot(tta/us2sec, (DATmainA.Motor(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox11.Value, h=plot(tta/us2sec, (DATmainA.Motor(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox12.Value, h=plot(tta/us2sec, (DATmainA.Motor(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox13.Value, h=plot(tta/us2sec, (DATmainA.Motor(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox10.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(tta/us2sec, (DATmainA.debug(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox11.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(tta/us2sec, (DATmainA.debug(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox12.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(tta/us2sec, (DATmainA.debug(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox13.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(tta/us2sec, (DATmainA.debug(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox14.Value, h=plot(tta/us2sec, (DATmainA.RCRate(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col14],'LineWidth',guiHandles.linewidth.Value); end
                else % downsampled for faster plotting performance
                    if guiHandles.checkbox0.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.debug(ii,:));hold on;set(h,'color', [linec.col0],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox1.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.GyroFilt(ii,:));hold on;set(h,'color', [linec.col1],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox2.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.Pterm(ii,:));hold on;set(h,'color', [linec.col2],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox3.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.Iterm(ii,:));hold on;set(h,'color', [linec.col3],'LineWidth',guiHandles.linewidth.Value), end     
                    if guiHandles.checkbox4.Value && ii<3, h=plot(DATdnsmplA.tta, DATdnsmplA.DtermRaw(ii,:));hold on;set(h,'color', [linec.col4],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox5.Value && ii<3, h=plot(DATdnsmplA.tta, DATdnsmplA.DtermFilt(ii,:));hold on;set(h,'color', [linec.col5],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox6.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.Fterm(ii,:));hold on;set(h,'color', [linec.col6],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox7.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.RCRate(ii,:));hold on;set(h,'color', [linec.col7],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox8.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.PIDsum(ii,:));hold on;set(h,'color', [linec.col8],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox9.Value, h=plot(DATdnsmplA.tta, DATdnsmplA.PIDerr(ii,:));hold on;set(h,'color', [linec.col9],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox10.Value, h=plot(DATdnsmplA.tta, (DATdnsmplA.Motor(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox11.Value, h=plot(DATdnsmplA.tta, (DATdnsmplA.Motor(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox12.Value, h=plot(DATdnsmplA.tta, (DATdnsmplA.Motor(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox13.Value, h=plot(DATdnsmplA.tta, (DATdnsmplA.Motor(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox10.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplA.tta, (DATdnsmplA.debug(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox11.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplA.tta, (DATdnsmplA.debug(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox12.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplA.tta, (DATdnsmplA.debug(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox13.Value && A_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplA.tta, (DATdnsmplA.debug(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox14.Value, h=plot(DATdnsmplA.tta, (DATdnsmplA.RCRate(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col14],'LineWidth',guiHandles.linewidth.Value); end
                end
                
                h=fill([0,t1,t1,0],[-maxY*2,-maxY*2,maxY,maxY],[.8 .8 .8]);
                set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);
                h=fill([t2,xmax,xmax,t2],[-maxY*2,-maxY*2,maxY,maxY],[.8 .8 .8]);
                set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);

                a = zoom(PTfig);
                if strcmp(a.Enable,'on'), 
                    v = axis;
                    axis(v)
                else  
                    a.Enable='off'; 
                    axis([0 xmax -maxY*2 maxY])
                end

                box off            
                y=ylabel(['[A] ' axLabel{ii} '^o/s'],'fontweight','bold','rot', 90);               
                set(y,'Units','normalized', 'position', [-.035 .67 1],'color',[.2 .2 .2]); 
                y=xlabel('time (s)','fontweight','bold');
                set(y,'color',[.2 .2 .2]); 
                set(gca,'fontsize',fontsz)
            end

            if ii==1 && ~expandON,
                set(hlinepos1,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos1]), 
                set(hlinepos1,'buttondownfcn', ['expandON=1;hexpand1 = copyobj(hlinepos1, gcf); set(hexpand1, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                ' ''Position'', [expand_sz],' ...
                ' ''buttondownfcn'', ''delete(gca);expandON=0;hexpand1=[]; '');']);      
            end
            if ii==2 && ~expandON,
                set(hlinepos2,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos2]), 
                set(hlinepos2,'buttondownfcn', ['expandON=1;hexpand2 = copyobj(hlinepos2, gcf); set(hexpand2, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                ' ''Position'', [expand_sz],' ...
                ' ''buttondownfcn'', ''delete(gca);expandON=0;hexpand2=[]; '');']);
            end
            if ii==3 && ~expandON,
                set(hlinepos3,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos3]), 
                set(hlinepos3,'buttondownfcn', ['expandON=1;hexpand3 = copyobj(hlinepos3, gcf); set(hexpand3, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                ' ''Position'', [expand_sz],' ...
                ' ''buttondownfcn'', ''delete(gca);expandON=0;hexpand3=[]; '');']) 
            end           
        end
    end

    %%%% [B] LINE PLOTS
    if ~isempty(filenameB)
        for ii=1:3
            if ~expandON,
                eval(['hlinepos' int2str(ii+3) '=subplot(' '''position''' ',posInfo.linepos' int2str(ii+3) ');cla;'])
            else
                eval(['if ~isempty(hexpand' int2str(ii+3) '),' 'subplot(hexpand' int2str(ii+3) ',' '''position''' ',expand_sz);cla; end'])
                warning off
            end

            if ~expandON || (expandON && eval(['~isempty(hexpand' int2str(ii+3) ')']))
                xmax=max(ttb/us2sec);
 
                h=plot([0 xmax],[-maxY -maxY],'k');
                set(h,'linewidth',.2)
                hold on
                set(gca,'ytick',[2*-maxY -maxY -maxY+1 -600 0 600 maxY],'yticklabel',{'0%' '100%' '' '-600' '0' '600' ''},'YColor',[.2 .2 .2],'fontweight','bold')    
                set(gca,'xtick',[10:10:round(xmax-5)],'XColor',[.2 .2 .2])  

                if expandON
                    if guiHandles.checkbox0.Value, h=plot(ttb/us2sec, DATmainB.debug(ii,:));hold on;set(h,'color', [linec.col0],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox1.Value, h=plot(ttb/us2sec, DATmainB.GyroFilt(ii,:));hold on;set(h,'color', [linec.col1],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox2.Value, h=plot(ttb/us2sec, DATmainB.Pterm(ii,:));hold on;set(h,'color', [linec.col2],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox3.Value, h=plot(ttb/us2sec, DATmainB.Iterm(ii,:));hold on;set(h,'color', [linec.col3],'LineWidth',guiHandles.linewidth.Value), end     
                    if guiHandles.checkbox4.Value && ii<3, h=plot(ttb/us2sec, DATmainB.DtermRaw(ii,:));hold on;set(h,'color', [linec.col4],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox5.Value && ii<3, h=plot(ttb/us2sec, DATmainB.DtermFilt(ii,:));hold on;set(h,'color', [linec.col5],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox6.Value, h=plot(ttb/us2sec, DATmainB.Fterm(ii,:));hold on;set(h,'color', [linec.col6],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox7.Value, h=plot(ttb/us2sec, DATmainB.RCRate(ii,:));hold on;set(h,'color', [linec.col7],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox8.Value, h=plot(ttb/us2sec, DATmainB.PIDsum(ii,:));hold on;set(h,'color', [linec.col8],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox9.Value, h=plot(ttb/us2sec, DATmainB.PIDerr(ii,:));hold on;set(h,'color', [linec.col9],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox10.Value, h=plot(ttb/us2sec, (DATmainB.Motor(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox11.Value, h=plot(ttb/us2sec, (DATmainB.Motor(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox12.Value, h=plot(ttb/us2sec, (DATmainB.Motor(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox13.Value, h=plot(ttb/us2sec, (DATmainB.Motor(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox10.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(ttb/us2sec, (DATmainB.debug(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox11.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(ttb/us2sec, (DATmainB.debug(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox12.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(ttb/us2sec, (DATmainB.debug(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox13.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(ttb/us2sec, (DATmainB.debug(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox14.Value, h=plot(ttb/us2sec, (DATmainB.RCRate(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col14],'LineWidth',guiHandles.linewidth.Value), end
                else % downsampled for faster plotting performance
                    if guiHandles.checkbox0.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.debug(ii,:));hold on;set(h,'color', [linec.col0],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox1.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.GyroFilt(ii,:));hold on;set(h,'color', [linec.col1],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox2.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.Pterm(ii,:));hold on;set(h,'color', [linec.col2],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox3.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.Iterm(ii,:));hold on;set(h,'color', [linec.col3],'LineWidth',guiHandles.linewidth.Value), end     
                    if guiHandles.checkbox4.Value && ii<3, h=plot(DATdnsmplB.ttb, DATdnsmplB.DtermRaw(ii,:));hold on;set(h,'color', [linec.col4],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox5.Value && ii<3, h=plot(DATdnsmplB.ttb, DATdnsmplB.DtermFilt(ii,:));hold on;set(h,'color', [linec.col5],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox6.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.Fterm(ii,:));hold on;set(h,'color', [linec.col6],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox7.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.RCRate(ii,:));hold on;set(h,'color', [linec.col7],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox8.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.PIDsum(ii,:));hold on;set(h,'color', [linec.col8],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox9.Value, h=plot(DATdnsmplB.ttb, DATdnsmplB.PIDerr(ii,:));hold on;set(h,'color', [linec.col9],'LineWidth',guiHandles.linewidth.Value), end
                    if guiHandles.checkbox10.Value, h=plot(DATdnsmplB.ttb, (DATdnsmplB.Motor(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox11.Value, h=plot(DATdnsmplB.ttb, (DATdnsmplB.Motor(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox12.Value, h=plot(DATdnsmplB.ttb, (DATdnsmplB.Motor(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox13.Value, h=plot(DATdnsmplB.ttb, (DATdnsmplB.Motor(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox10.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplB.ttb, (DATdnsmplB.debug(1,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox11.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplB.ttb, (DATdnsmplB.debug(2,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox12.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplB.ttb, (DATdnsmplB.debug(3,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox13.Value && B_debugmode==DSHOT_RPM_TELEMETRY, h=plot(DATdnsmplB.ttb, (DATdnsmplB.debug(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', 'k','LineWidth',guiHandles.linewidth.Value); end
                    if guiHandles.checkbox14.Value, h=plot(DATdnsmplB.ttb, (DATdnsmplB.RCRate(4,:)*(maxY/100))-(maxY*2));hold on;set(h,'color', [linec.col14],'LineWidth',guiHandles.linewidth.Value); end
                end
                
                h=fill([0,t3,t3,0],[-maxY*2,-maxY*2,maxY,maxY],[.8 .8 .8]);
                set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);
                h=fill([t4,xmax,xmax,t4],[-maxY*2,-maxY*2,maxY,maxY],[.8 .8 .8]);
                set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);

                a = zoom(PTfig);
                if strcmp(a.Enable,'on'), 
                    v = axis;
                    axis(v)
                else  
                    a.Enable='off'; 
                    axis([0 xmax -maxY*2 maxY])
                end
               
                box off   
                y=ylabel(['[B] ' axLabel{ii} '^o/s'],'fontweight','bold','rot', 90);                 
                set(y,'Units','normalized', 'position', [-.035 .67 1],'color',[.2 .2 .2]);  
                y=xlabel('time (s)','fontweight','bold');
                set(y,'color',[.2 .2 .2]); 
                set(gca,'fontsize',fontsz)
            end

            if ii==1 && ~expandON,
                set(hlinepos4,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos4]), 
                set(hlinepos4,'buttondownfcn', ['expandON=1;hexpand4 = copyobj(hlinepos4, gcf); set(hexpand4, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                ' ''Position'', [expand_sz],' ...
                ' ''buttondownfcn'', ''delete(gca);expandON=0;hexpand4=[]; '');']);            
            end
            if ii==2 && ~expandON, 
                set(hlinepos5,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos5]), 
                set(hlinepos5,'buttondownfcn', ['expandON=1;hexpand5 = copyobj(hlinepos5, gcf); set(hexpand5, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                ' ''Position'', [expand_sz],' ...
                ' ''buttondownfcn'', ''delete(gca);expandON=0;hexpand5=[]; '');']);            
            end
            if ii==3 && ~expandON,
                set(hlinepos6,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos6]), 
                set(hlinepos6,'buttondownfcn', ['expandON=1;hexpand6 = copyobj(hlinepos6, gcf); set(hexpand6, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                ' ''Position'', [expand_sz],' ...
                ' ''buttondownfcn'', ''delete(gca);expandON=0;hexpand6=[]; '');']);            
            end  
        end
    end

    %% Histogram % throttle 

    pos1=[0.905 0.25 0.08 0.1];
    pos2=[0.905 0.135 0.08 0.1];
    PTfig(1);
    if ~isempty(filenameA)
        hhist=subplot('position',pos1);
        cla
        h=histogram(DATtmpA.RCRate(4,:),'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)
        grid on

        if isempty(filenameB)
             set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'xticklabels',{0 20 40 60 80 100},'ylim',[0 .1],'ytick',[0 .05 .1],'yticklabels',{0 5 10},'fontsize',fontsz, 'Position',[pos1]);
            xlabel('% throttle')
            ylabel('% of flight')
        else
            set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{},'yticklabels',{0 5 10},'fontsize',fontsz, 'Position',[pos1]);
            xlabel('');
        end
        axis([1 99 0 .1])
    end


    if ~isempty(filenameB)
        hhist=subplot('position',pos2);
        cla
        h=histogram(DATtmpB.RCRate(4,:),'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorB],'FaceAlpha',.9,'edgecolor',[colorB],'EdgeAlpha',.7)
        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'xticklabels',{0 20 40 60 80 100},'ylim',[0 .1],'ytick',[0 .05 .1],'yticklabels',{0 5 10},'fontsize',fontsz,'position',[pos2]);
        axis([1 99 0 .1])
        grid on
        xlabel('% throttle')
        ylabel('                    % of flight')
    end

    set(PTfig, 'pointer', 'arrow')
else 
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end

%toc

