%% PTplotLogViewer - script to plot main line graphs

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(fnameMaster)

    set(PTfig, 'pointer', 'watch')

    global logviewerYscale 
    logviewerYscale = str2num(guiHandles.maxY_input.String);

    figure(PTfig);

    maxY=str2num(guiHandles.maxY_input.String);

    alpha_red=.8;
    alpha_blue=.8;

    % scale fonts according to size of window and/or screen
    prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));
    fontsz=(screensz_multiplier*prop_max_screen);

    f = fields(guiHandles);
    for i = 1 : size(f,1)
        eval(['guiHandles.' f{i} '.FontSize=fontsz;']);
    end
    controlpanel.FontSize=fontsz;

    lineSmoothFactors = [1 10 20 40 80];

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

    expand_sz=[0.05 0.06 0.815 0.835];


    %% where you want full range of data

    % if start or end > length of file, or start > end  
    if (epoch1_A(guiHandles.FileNum.Value) > (tta{(guiHandles.FileNum.Value)}(end) / us2sec))  ||  (epoch2_A(guiHandles.FileNum.Value) > (tta{(guiHandles.FileNum.Value)}(end) / us2sec)) || (epoch1_A(guiHandles.FileNum.Value) > epoch2_A(guiHandles.FileNum.Value))
        epoch1_A(guiHandles.FileNum.Value) = 2;
        epoch2_A(guiHandles.FileNum.Value) = floor(tta{(guiHandles.FileNum.Value)}(end) / us2sec) - 1;
    end

     y=[epoch1_A(guiHandles.FileNum.Value)*us2sec epoch2_A(guiHandles.FileNum.Value)*us2sec];%%% used for fill in unused data range
     t1=(tta{(guiHandles.FileNum.Value)}(find(tta{(guiHandles.FileNum.Value)}>y(1),1))) / us2sec;
     t2=(tta{(guiHandles.FileNum.Value)}(find(tta{(guiHandles.FileNum.Value)}>y(2),1))) / us2sec;  

    tIND{guiHandles.FileNum.Value} = (tta{guiHandles.FileNum.Value} > (t1*us2sec)) & (tta{guiHandles.FileNum.Value} < (t2*us2sec));

%     jRangeSlider = com.jidesoft.swing.RangeSlider(0,200,10,190);  % min,max,low,high
%     jRangeSlider = javacomponent(jRangeSlider,[50, 80, 500, 80], gcf);
%     set(jRangeSlider, 'MajorTickSpacing',50, 'PaintTicks',true, 'PaintLabels',true, 'Background',java.awt.Color.white)
%     jRangeSlider.LowValue = 20;, jRangeSlider.HighValue = 180;

    guiHandles.slider = uicontrol(PTfig, 'style','slider','SliderStep',[0.001 0.01],'Visible', 'on', 'units','normalized','position',[0.0826 0.905 0.795 0.02],...
        'min',0,'max',1, 'callback','PTslider1Actions;')  

        
        
    %% log viewer line plots
    %%%%%%%% PLOT %%%%%%%
    axLabel={'Roll';'Pitch';'Yaw'};
    lineStyleLV = {'-'; '-'; '-'};
    lineStyle2LV = {'-'; '--'; ':'};
    lineStyle2LVnames = {'solid' ; 'dashed' ; 'dotted'};
    axesOptionsLV = find([guiHandles.plotR.Value guiHandles.plotP.Value guiHandles.plotY.Value]);
    
    delete(hexpand1)
    delete(hexpand2)
    delete(hexpand3)
    expandON = 0;

    ylabelname=[];
    for i = 1 : size(axesOptionsLV,2)
        if i == size(axesOptionsLV,2)
            ylabelname = [ylabelname axLabel{axesOptionsLV(i)} '-' lineStyle2LVnames{i} '   (deg/s) '];
        else
            ylabelname = [ylabelname axLabel{axesOptionsLV(i)} '-' lineStyle2LVnames{i} '   |   '];
        end
    end
    
    PTfig;
    
    if strcmp(get(zoom, 'Enable'),'off') && ~expandON % 
         delete(subplot('position' ,fullszPlot));
         delete(subplot('position',posInfo.linepos1));
         delete(subplot('position',posInfo.linepos2));
         delete(subplot('position',posInfo.linepos3));
         delete(subplot('position',posInfo.linepos4));
    end
    
    for i = 1 : 19
        try
            eval(['delete([hch' int2str(i) '])'])
        catch
        end
    end

            
    dcm_obj = datacursormode(PTfig);
    set(dcm_obj,'UpdateFcn',@PTdatatip);

    cntLV = 0;
    lnstyle = lineStyleLV;
    
    if ~isempty(fnameMaster)
        for ii = axesOptionsLV  
            if guiHandles.RPYcomboLV.Value, expandON = 0; end
            %%%%%%%
            if ~guiHandles.RPYcomboLV.Value && ~expandON
                eval(['LVpanel' int2str(ii) '=subplot(' '''position''' ',posInfo.linepos' int2str(ii) ');'])
                LVpanel5 = subplot('position',posInfo.linepos4);
            end
            if ~guiHandles.RPYcomboLV.Value && expandON
                try
                 eval(['subplot(hexpand' int2str(ii) ',' '''position''' ',expand_sz);'])
                 warning off
                catch
                end
            end

            if eval(['~isempty(hexpand' int2str(ii) ') && ishandle(hexpand' int2str(ii) ') || ~expandON'])
                
                cntLV = cntLV + 1;
                if guiHandles.RPYcomboLV.Value 
                    LVpanel4 = subplot('position' ,fullszPlot)
                    lnstyle = lineStyle2LV;
                end
                if ~guiHandles.RPYcomboLV.Value && expandON == 0
                    eval(['LVpanel' int2str(ii) '= subplot(' '''position''' ',posInfo.linepos' int2str(ii) ');'])
                    lnstyle = lineStyleLV;
                end

                xmax=max(tta{guiHandles.FileNum.Value}/us2sec); 


                h=plot([0 xmax],[-maxY -maxY],'k');
                set(h,'linewidth',.2)
                hold on

                set(gca,'ytick',[  -(maxY/2) 0 maxY/2 ],'yticklabel',{num2str(-(maxY/2)) '0' num2str((maxY/2)) ''},'YColor',[.2 .2 .2],'fontweight','bold') 
                set(gca,'xtick',[round(xmax/10):round(xmax/10):round(xmax)],'XColor',[.2 .2 .2])  

                sFactor = lineSmoothFactors(guiHandles.lineSmooth.Value);

                if guiHandles.checkbox0.Value, hch1=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.debug_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch1,'color', [linec.col0],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox1.Value, hch2=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.gyroADC_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch2,'color', [linec.col1],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox2.Value, hch3=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.axisP_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch3,'color', [linec.col2],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox3.Value, hch4=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.axisI_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch4,'color', [linec.col3],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox4.Value && ii<3, hch5=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.axisDpf_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch5,'color', [linec.col4],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox5.Value && ii<3, hch6=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.axisD_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch6,'color', [linec.col5],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox6.Value, hch7=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.axisF_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch7,'color', [linec.col6],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox7.Value, hch8=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.setpoint_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch8,'color', [linec.col7],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox8.Value, hch9=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.pidsum_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch9,'color', [linec.col8],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end
                if guiHandles.checkbox9.Value, hch10=plot(tta{guiHandles.FileNum.Value}/us2sec, eval([ 'smooth(T{guiHandles.FileNum.Value}.piderr_' int2str(ii-1) '_, sFactor, ''loess'')' ]));hold on;set(hch10,'color', [linec.col9],'LineWidth',guiHandles.linewidth.Value/2,'linestyle',[lnstyle{cntLV}]), end

    
                 h=fill([0,t1,t1,0],[-maxY,-maxY,maxY,maxY],[.8 .8 .8]);
                 set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);
                 h=fill([t2,xmax,xmax,t2],[-maxY,-maxY,maxY,maxY],[.8 .8 .8]);
                 set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);

                 if strcmp(get(zoom, 'Enable'),'on')
                    v = axis;
                    axis(v)
                else  
                    axis([0 xmax -maxY maxY])
                 end

                box off  
                if guiHandles.RPYcomboLV.Value 
                    y=ylabel([ylabelname],'fontweight','bold','rot', 90);  
                else
                    y=ylabel([axLabel{ii} ' (deg/s)'],'fontweight','bold','rot', 90);  
                end


                set(y,'Units','normalized', 'position', [-.035 .5 1],'color',[.2 .2 .2]); 
                y=xlabel('Time (s)','fontweight','bold');
                set(y,'color',[.2 .2 .2]); 
                set(gca,'fontsize',fontsz,'XMinorGrid','on')
                grid on
                
                            %  Percent variables
                LVpanel5 = subplot('position',posInfo.linepos4);
                if guiHandles.checkbox10.Value, hch11=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_0_, sFactor, 'loess')) );hold on;set(hch11,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value/2), end
                if guiHandles.checkbox11.Value, hch12=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_1_, sFactor, 'loess')) );hold on;set(hch12,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value/2), end
                if guiHandles.checkbox12.Value, hch13=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_2_, sFactor, 'loess')) );hold on;set(hch13,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value/2), end
                if guiHandles.checkbox13.Value, hch14=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_3_, sFactor, 'loess')) );hold on;set(hch14,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value/2), end
                % motor sigs 4-7 for x8 configuration
                if guiHandles.checkbox10.Value, try hch15=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_4_, sFactor, 'loess')) );hold on;set(hch15,'color', [linec.col10],'LineWidth',guiHandles.linewidth.Value/2, 'LineStyle', '--'), catch, end, end
                if guiHandles.checkbox11.Value, try hch16=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_5_, sFactor, 'loess')) );hold on;set(hch16,'color', [linec.col11],'LineWidth',guiHandles.linewidth.Value/2, 'LineStyle', '--'), catch, end, end
                if guiHandles.checkbox12.Value, try hch17=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_6_, sFactor, 'loess')) );hold on;set(hch17,'color', [linec.col12],'LineWidth',guiHandles.linewidth.Value/2, 'LineStyle', '--'), catch, end, end
                if guiHandles.checkbox13.Value, try hch18=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.motor_7_, sFactor, 'loess')) );hold on;set(hch18,'color', [linec.col13],'LineWidth',guiHandles.linewidth.Value/2, 'LineStyle', '--'), catch, end, end

                if guiHandles.checkbox14.Value, hch19=plot(tta{guiHandles.FileNum.Value}/us2sec, (smooth(T{guiHandles.FileNum.Value}.setpoint_3_/10, sFactor, 'loess')) );hold on;set(hch19,'color', [linec.col14],'LineWidth',guiHandles.linewidth.Value/2), end

                axis([0 xmax 0 100])
                
                 h=fill([0,t1,t1,0],[0, 0, 100, 100],[.8 .8 .8]);
                 set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]); 
                 h=fill([t2,xmax,xmax,t2],[0, 0, 100, 100],[.8 .8 .8]);
                 set(h,'FaceAlpha',0.8,'EdgeColor',[.8 .8 .8]);
 
                y=xlabel('Time (s)','fontweight','bold');
                set(y,'color',[.2 .2 .2]); 
                y=ylabel({'Throttle | Motor (%)'},'fontweight','bold');
                set(gca,'fontsize',fontsz,'XMinorGrid','on','ylim',[0 100],'ytick',[0 20 40 60 80 100],'fontweight','bold')
                set(gca,'xtick',[round(xmax/10):round(xmax/10):round(xmax)],'XColor',[.2 .2 .2])  
                grid on
                
                
    
                
            end

            try
                if ii==1 && ~expandON
                    set(LVpanel1,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos1]), 
                    set(LVpanel1,'buttondownfcn', ['expandON=1;hexpand1 = copyobj(LVpanel1, gcf); set(hexpand1, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                    ' ''Position'', [expand_sz],' ...
                    ' ''buttondownfcn'', ''delete(hexpand1);expandON=0; '');']);      
                end
                if ii==2 && ~expandON
                    set(LVpanel2,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos2]), 
                    set(LVpanel2,'buttondownfcn', ['expandON=1;hexpand2 = copyobj(LVpanel2, gcf); set(hexpand2, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                    ' ''Position'', [expand_sz],' ...
                    ' ''buttondownfcn'', ''delete(hexpand2);expandON=0; '');']);
                end
                if ii==3 && ~expandON
                    set(LVpanel3,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos3]), 
                    set(LVpanel3,'buttondownfcn', ['expandON=1;hexpand3 = copyobj(LVpanel3, gcf); set(hexpand3, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                    ' ''Position'', [expand_sz],' ...
                    ' ''buttondownfcn'', ''delete(hexpand3);expandON=0; '');']) 
                end    
                
                if  ~expandON
                    set(LVpanel5,'color',[1 1 1],'fontsize',fontsz,'tickdir','in','xminortick','on','yminortick','on','position',[posInfo.linepos4]), 
                    set(LVpanel5,'buttondownfcn', ['expandON=1;hexpand5 = copyobj(LVpanel5, gcf); set(hexpand5, ''Units'', ''normal'',''fontweight'', ''bold'',' ...
                    ' ''Position'', [expand_sz],' ...
                    ' ''buttondownfcn'', ''delete(hexpand5);expandON=0; '');']) 
                end
                    
            catch     
            end
        end
    end

    set(PTfig, 'pointer', 'arrow')
else 
     warndlg('Please select file(s)');
end


