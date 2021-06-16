%% PTplotLogViewer - script to plot main line graphs

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

% tic

%try
    
%if ~isempty(fnameMaster)
prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);

    set(PTfig, 'pointer', 'watch')
    
    global logviewerYscale 
    logviewerYscale = str2num(guiHandles.maxY_input.String);
    
    figure(1);

    maxY=str2num(guiHandles.maxY_input.String);

    alpha_red=.8;
    alpha_blue=.8;

    % scale fonts according to size of window and/or screen
    guiHandles.fileA.FontSize=fontsz;
    guiHandles.FileNum.FontSize=fontsz;
    guiHandles.Epoch1_A_text.FontSize=fontsz;
    guiHandles.Epoch1_A_Input.FontSize=fontsz;
    guiHandles.Epoch2_A_text.FontSize=fontsz;
    guiHandles.Epoch2_A_Input.FontSize=fontsz;
    guiHandles.spectrogramButton.FontSize=fontsz;
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
    guiHandles.maxY_input.FontSize=fontsz;
    guiHandles.maxY_text.FontSize=fontsz;
    guiHandles.clr.FontSize=fontsz;
    guiHandles.donate.FontSize=fontsz;
    
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
%     if ~isempty(fnameMaster)
%     guiHandles.fileA.FontWeight='bold';
%     guiHandles.fnameAText = uicontrol(PTfig,'style','text','string',['A:' fnameMaster],'fontsize',fontsz*.8,'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.fnameAText]);
%     end
    

    %% posinfo
    posInfo.linepos1=[0.095 0.665 0.77 0.261];
    posInfo.linepos2=[0.095 0.395 0.77 0.261];
    posInfo.linepos3=[0.095 0.125 0.77 0.261];

    expand_sz=[0.05 0.07 0.82 0.86];


    %% where you want full range of data
    
     y=[epoch1_A(guiHandles.FileNum.Value)*us2sec epoch2_A(guiHandles.FileNum.Value)*us2sec];%%% used for fill in unused data range
     t1=(tta{(guiHandles.FileNum.Value)}(find(tta{(guiHandles.FileNum.Value)}>y(1),1))) / us2sec;
     t2=(tta{(guiHandles.FileNum.Value)}(find(tta{(guiHandles.FileNum.Value)}>y(2),1))) / us2sec;  

    tIND{guiHandles.FileNum.Value} = (tta{guiHandles.FileNum.Value} > (t1*us2sec)) & (tta{guiHandles.FileNum.Value} < (t2*us2sec));
        

    %% log viewer line plots
    %%%%%%%% PLOT %%%%%%%
    axLabel={'roll';'pitch';'yaw'};

    PTfig;
    
    dcm_obj = datacursormode(PTfig);
    set(dcm_obj,'UpdateFcn',@PTdatatip);

     %%%% [A] LINE PLOTS
    if ~isempty(fnameMaster)
        for ii=1:3  
            if ~expandON,
                eval(['hlinepos' int2str(ii) '=subplot(' '''position''' ',posInfo.linepos' int2str(ii) ');cla;'])
            else
                eval(['if ~isempty(hexpand' int2str(ii) '),' 'subplot(hexpand' int2str(ii) ',' '''position''' ',expand_sz);cla; end'])
                warning off
            end

            if  ~expandON || (expandON && eval(['~isempty(hexpand' int2str(ii) ')']))
                xmax=max(tta{guiHandles.FileNum.Value}/us2sec); 

                h=plot([0 xmax],[-maxY -maxY],'k');
                set(h,'linewidth',.2)
                hold on
                
                set(gca,'ytick',[2*-maxY -maxY -maxY+1 -(maxY/2) 0 maxY/2 maxY],'yticklabel',{'0%' '100%' '' num2str(-(maxY/2)) '0' num2str((maxY/2)) ''},'YColor',[.2 .2 .2],'fontweight','bold') 
                set(gca,'xtick',[round(xmax/10):round(xmax/10):round(xmax)],'XColor',[.2 .2 .2])                 


                if guiHandles.checkbox0.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.debug_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col0],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox1.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.gyroADC_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col1],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox2.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.axisP_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col2],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox3.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.axisI_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col3],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox4.Value && ii<3, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.axisDpf_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col4],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox5.Value && ii<3, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.axisD_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col5],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox6.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.axisF_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col6],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox7.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.setpoint_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col7],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox8.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.pidsum_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col8],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox9.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'T{guiHandles.FileNum.Value}.piderr_' int2str(ii-1) '_' ]));hold on;set(h,'color', [linec.col9],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox10.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, (T{guiHandles.FileNum.Value}.motor_0_)*(maxY/100) -(maxY*2));hold on;set(h,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox11.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, (T{guiHandles.FileNum.Value}.motor_1_)*(maxY/100) -(maxY*2));hold on;set(h,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox12.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, (T{guiHandles.FileNum.Value}.motor_2_)*(maxY/100) -(maxY*2));hold on;set(h,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox13.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, (T{guiHandles.FileNum.Value}.motor_3_)*(maxY/100) -(maxY*2));hold on;set(h,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value), end
                if guiHandles.checkbox14.Value, h=plot(tta{guiHandles.FileNum.Value}/us2sec, (T{guiHandles.FileNum.Value}.setpoint_3_/10)*(maxY/100) -(maxY*2));hold on;set(h,'color', [linec.col14],'LineWidth',guiHandles.linewidth.Value), end
                
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
                y=ylabel(['' axLabel{ii} '^o/s'],'fontweight','bold','rot', 90);               
                set(y,'Units','normalized', 'position', [-.035 .67 1],'color',[.2 .2 .2]); 
                y=xlabel('time (s)','fontweight','bold');
                set(y,'color',[.2 .2 .2]); 
                set(gca,'fontsize',fontsz,'XMinorGrid','on')
                grid on
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
    
    guiHandles.Epoch1_A_text = uicontrol(PTfig,'style','text','string','start (s)','fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch1_A_text]);
    guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',num2str(epoch1_A(guiHandles.FileNum.Value)),'fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
     'callback','@textinput_call; epoch1_A(guiHandles.FileNum.Value)=str2num(guiHandles.Epoch1_A_Input.String); PTplotLogViewer;');
    guiHandles.Epoch2_A_text = uicontrol(PTfig,'style','text','string','end (s)','fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','BackgroundColor',bgcolor,'outerposition',[posInfo.Epoch2_A_text]);
    guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',num2str(epoch2_A(guiHandles.FileNum.Value)),'fontsize',fontsz,'TooltipString', [TooltipString_Epochs],'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
     'callback','@textinput_call;epoch2_A(guiHandles.FileNum.Value)=str2num(guiHandles.Epoch2_A_Input.String); PTplotLogViewer');

    set(PTfig, 'pointer', 'arrow')
% else 
%     errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
%     pause(2);
% end
% 
% catch
%     %close
% end

%toc

