%% PTplotRaw - script to plot main figs (everything except spectrograms)

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) | ~isempty(filenameB)

figure(1);
set(PTfig, 'pointer', 'watch')
pause(.2)


alpha_red=.8;
alpha_blue=.8;

prop_max_screen=(max([PTfig.Position(3) PTfig.Position(4)]));

fontsz=(screensz_multiplier*prop_max_screen);

clear Tst_a_R Tst_a_P Tst_a_Y Tst_b_R Tst_b_P Tst_b_Y 
%%%%%%% extract data with little stick input
if ~isempty(filenameA),
    %%%% for test A
    RCRateR_Thresh_A=abs(DATtmpA.RCRate(1,:)) < maxDegsec;
    RCRateP_Thresh_A=abs(DATtmpA.RCRate(2,:)) < maxDegsec;
    RCRateY_Thresh_A=abs(DATtmpA.RCRate(3,:)) < maxDegsec;
    
    PIDerrR_Thresh_A=abs(DATtmpA.PIDerr(1,:)) < maxDegsec;
    PIDerrP_Thresh_A=abs(DATtmpA.PIDerr(2,:)) < maxDegsec;
    PIDerrY_Thresh_A=abs(DATtmpA.PIDerr(3,:)) < maxDegsec;
    PIDerrALL_Thresh_A=PIDerrR_Thresh_A & PIDerrP_Thresh_A & PIDerrY_Thresh_A;
    RCRateALL_Thresh_A=RCRateR_Thresh_A & RCRateP_Thresh_A & RCRateY_Thresh_A;
    RC_PID_Thresh_A=PIDerrALL_Thresh_A & RCRateALL_Thresh_A;
end

if ~isempty(filenameB),
    %%%% for test B
    RCRateR_Thresh_B=abs(DATtmpB.RCRate(1,:)) < maxDegsec;
    RCRateP_Thresh_B=abs(DATtmpB.RCRate(2,:)) < maxDegsec;
    RCRateY_Thresh_B=abs(DATtmpB.RCRate(3,:)) < maxDegsec;
    PIDerrR_Thresh_B=abs(DATtmpB.PIDerr(1,:)) < maxDegsec;
    PIDerrP_Thresh_B=abs(DATtmpB.PIDerr(2,:)) < maxDegsec;
    PIDerrY_Thresh_B=abs(DATtmpB.PIDerr(3,:)) < maxDegsec;
    PIDerrALL_Thresh_B=PIDerrR_Thresh_B & PIDerrP_Thresh_B & PIDerrY_Thresh_B;
    RCRateALL_Thresh_B=RCRateR_Thresh_B & RCRateP_Thresh_B & RCRateY_Thresh_B;
    RC_PID_Thresh_B=PIDerrALL_Thresh_B & RCRateALL_Thresh_B;
end

guiHandles.fileA.FontSize=fontsz;
guiHandles.fileB.FontSize=fontsz;
guiHandles.runAll.FontSize=fontsz;
guiHandles.refreshcall.FontSize=fontsz;
guiHandles.maxSticktext.FontSize=fontsz;
guiHandles.maxStick.FontSize=fontsz;
guiHandles.Epoch1_A_text.FontSize=fontsz;
guiHandles.Epoch1_A_Input.FontSize=fontsz;
guiHandles.Epoch2_A_text.FontSize=fontsz;
guiHandles.Epoch2_A_Input.FontSize=fontsz;
guiHandles.Epoch1_B_text.FontSize=fontsz;
guiHandles.Epoch1_B_Input.FontSize=fontsz;
guiHandles.Epoch2_B_text.FontSize=fontsz;
guiHandles.Epoch2_B_Input.FontSize=fontsz;
guiHandles.climMax_text.FontSize=fontsz;
guiHandles.climMax_input.FontSize=fontsz;
guiHandles.climMax_text2.FontSize=fontsz;
guiHandles.climMax_input2.FontSize=fontsz;
guiHandles.BreakoutPlotButton.FontSize=fontsz;
guiHandles.Spec1Select.FontSize=fontsz;
guiHandles.Spec2Select.FontSize=fontsz;
guiHandles.Sub100HzCheck1.FontSize=fontsz;
guiHandles.Sub100HzCheck2.FontSize=fontsz;
guiHandles.ColormapSelect.FontSize=fontsz;
guiHandles.DispInfoButton.FontSize=fontsz;
guiHandles.PlotSelect.FontSize=fontsz;
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
if ~isempty(filenameA), guiHandles.fileA.FontWeight='Bold'; else, guiHandles.fileA.FontWeight='Normal'; end
if ~isempty(filenameB), guiHandles.fileB.FontWeight='Bold'; else, guiHandles.fileB.FontWeight='Normal'; end

%% where you want full range of data

if ~isempty(filenameA),
    y=[epoch1_A*us2sec epoch2_A*us2sec];%%% used to place demarking lines on full data figs
    t1=(tta(find(tta>y(1),1))) / us2sec;
    t2=(tta(find(tta>y(2),1))) / us2sec;
    
end

if ~isempty(filenameB),
    y=[epoch1_B*us2sec epoch2_B*us2sec];
    t3=(ttb(find(ttb>y(1),1))) / us2sec;
    t4=(ttb(find(ttb>y(2),1))) / us2sec;
    
end

%%%%%%%% UPDATE GUI %%%%%%%

if ~isempty(filenameA)
guiHandles.fnameAText = uicontrol(PTfig,'style','text','string',['A:' filenameA],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.fnameAText]);
%AlooptimeText = uicontrol(PTfig,'style','text','string',['A:gyro ' int2str(A_looptime/1000) 'kHz / log ' int2str(A_lograte) 'kHz'],'fontsize',fontsz,'units','normalized','outerposition',[posAlooptimeText]);
end
if ~isempty(filenameB)
guiHandles.fnameBText = uicontrol(PTfig,'style','text','string',['B:' filenameB],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.fnameBText]);
%BlooptimeText = uicontrol(PTfig,'style','text','string',['B:gyro ' int2str(B_looptime/1000) 'kHz / log ' int2str(B_lograte) 'kHz'],'fontsize',fontsz,'units','normalized','outerposition',[posBlooptimeText]);
end

if exist('PhaseDelay_A','var')
guiHandles.AphasedelayText = uicontrol(PTfig,'style','text','string',['PsD-A(gyro/dterm/total):' num2str(round(PhaseDelay_A*100)/100) '/' num2str(round(PhaseDelay2_A*100)/100) '/' num2str(round((PhaseDelay_A+PhaseDelay2_A)*100)/100) 'ms'],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.AphasedelayText]);
end
if exist('PhaseDelay_B','var')
guiHandles.BphasedelayText = uicontrol(PTfig,'style','text','string',['PsD-B(gyro/dterm/total):' num2str(round(PhaseDelay_B*100)/100) '/' num2str(round(PhaseDelay2_B*100)/100) '/' num2str(round((PhaseDelay_B+PhaseDelay2_B)*100)/100) 'ms'],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.BphasedelayText]);
end

%% main + spec 1

%%%%%%%% PLOT %%%%%%%
hc1=[];hc2=[];hc3=[];hc4=[];hc5=[];hc6=[];
expand_sz=[0.01 0.027 0.41 0.98];

PTfig(1);
dcm_obj = datacursormode(PTfig);
set(dcm_obj,'UpdateFcn',@PTdatatip);

if guiHandles.PlotSelect.Value==1
% delete other panels  
if isempty(filenameA)
delete(subplot(2,2,1));
end
if isempty(filenameB)
delete(subplot(2,2,3));
end

set(guiHandles.checkbox0,'visible','on')
set(guiHandles.checkbox1,'visible','on')
set(guiHandles.checkbox2,'visible','on')
set(guiHandles.checkbox3,'visible','on')
set(guiHandles.checkbox4,'visible','on')
set(guiHandles.checkbox5,'visible','on')
set(guiHandles.checkbox6,'visible','on')
set(guiHandles.checkbox7,'visible','on')
set(guiHandles.checkbox8,'visible','on')
set(guiHandles.checkbox9,'visible','on')
 
    if ~isempty(filenameA)
        pos1=[0.075 0.8243 0.33 0.11];
        pos2=[0.075 0.6875 0.33 0.11];
        pos3=[0.075 0.5450 0.33 0.11];

        h2=subplot('position',pos1);
        cla
        
        xmax=max(((tta/1000)/1000)); 
        ymax= maxDegsec*2;
        
        h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA]);
        set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
        hold on
        if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(1,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
        if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(1,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
        if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(1,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
        if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(1,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
        if guiHandles.checkbox4.Value, h=plot((tta/1000)/1000, DATmainA.DtermRaw(1,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
        if guiHandles.checkbox5.Value, h=plot((tta/1000)/1000, DATmainA.DtermFilt(1,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
        if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(1,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
        if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(1,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
        if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(1,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
        if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(1,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
        
        % throttle
        h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
        h.BaseLine.BaseValue=-(maxDegsec*2);
        set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)

        h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
        set(h,'linewidth',.1)
        h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
        set(h,'linewidth',.1)
        
        a = zoom(PTfig);
        if strcmp(a.Enable,'on'), 
            v = axis;
            axis(v)
        else  
            a.Enable='off'; 
            axis([0 xmax -ymax ymax])
        end
        
        box on
        T=text(5, -maxDegsec*1.5, ['% throttle']);
        set(T, 'FontSize',fontsz-1,'Color',[.2 .2 .2])          
        ylabel('Roll ^o/s');

        set(h2,'color',[1 1 1],'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[pos1]);

        h2=subplot('position',pos1);
        set(h2,'buttondownfcn', ['h=gca; hc1 = copyobj(h, gcf); set(hc1, ''Units'', ''normal'',' ...
        ' ''Position'', [expand_sz],' ...
        ' ''buttondownfcn'', ''delete(gca)'');']);
    
    h2=subplot('position',pos2);
        cla
        xmax=max(((tta/1000)/1000)); 

         h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA]);
        set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
        hold on
        if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(2,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
        if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(2,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
        if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(2,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
        if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(2,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
        if guiHandles.checkbox4.Value, h=plot((tta/1000)/1000, DATmainA.DtermRaw(2,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
        if guiHandles.checkbox5.Value, h=plot((tta/1000)/1000, DATmainA.DtermFilt(2,:));hold on;set(h,'color', [line.col5],'linewidth',1), end        
        if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(2,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
        if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(2,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
        if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(2,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
        if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(2,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
       
         % throttle
        h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
        h.BaseLine.BaseValue=-(maxDegsec*2);
        set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)

    
        h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
        set(h,'linewidth',.1)
        h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
        set(h,'linewidth',.1)
        a = zoom(PTfig);
        if strcmp(a.Enable,'on'), 
            v = axis;
            axis(v)
        else  
            a.Enable='off'; 
            axis([0 xmax -ymax ymax])
        end
        box on
        T=text(5, -maxDegsec*1.5, ['% throttle']);
        set(T, 'FontSize',fontsz-1,'Color',[.2 .2 .2])   
        ylabel('Pitch ^o/s');
        set(h2,'color',[1 1 1],'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[pos2]);

         h2=subplot('position',pos2);
         set(h2, 'buttondownfcn', ['h=gca; hc2 = copyobj(h, gcf);set(hc2, ''Units'', ''normal'',' ...
        ' ''Position'', [expand_sz],' ...
        ' ''buttondownfcn'', ''delete(gca)'');']);

        h2=subplot('position',pos3);
        cla
        xmax=max(((tta/1000)/1000)); 
        
         h=fill([t1,t2,t2,t1],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorA]);
        set(h,'FaceAlpha',0.35,'EdgeColor',[colorA]);
        hold on
        if guiHandles.checkbox0.Value, h=plot((tta/1000)/1000, DATmainA.GyroRaw(3,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
        if guiHandles.checkbox1.Value, h=plot((tta/1000)/1000, DATmainA.GyroFilt(3,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
        if guiHandles.checkbox2.Value, h=plot((tta/1000)/1000, DATmainA.Pterm(3,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
        if guiHandles.checkbox3.Value, h=plot((tta/1000)/1000, DATmainA.Iterm(3,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
        if guiHandles.checkbox6.Value, h=plot((tta/1000)/1000, DATmainA.Fterm(3,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
        if guiHandles.checkbox7.Value, h=plot((tta/1000)/1000, DATmainA.RCRate(3,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
        if guiHandles.checkbox8.Value, h=plot((tta/1000)/1000, DATmainA.PIDsum(3,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
        if guiHandles.checkbox9.Value, h=plot((tta/1000)/1000, DATmainA.PIDerr(3,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
        
         % throttle
        h=area(((tta/1000)/1000), ((DATmainA.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
        h.BaseLine.BaseValue=-(maxDegsec*2);
        set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)

  
        h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
        set(h,'linewidth',.1)
        h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
        set(h,'linewidth',.1)
       a = zoom(PTfig);
        if strcmp(a.Enable,'on'), 
            v = axis;
            axis(v)
        else  
            a.Enable='off'; 
            axis([0 xmax -ymax ymax])
        end
        T=text(5, -maxDegsec*1.5, ['% throttle']);
        set(T, 'FontSize',fontsz-1,'Color',[.2 .2 .2])   
        ylabel('Yaw ^o/s');
        if isempty(filenameB)
           xlabel('time (s)');         
        else
            xlabel('');
        end
        set(h2,'color',[1 1 1],'fontsize',fontsz,'tickdir','out','xminortick','on','yminortick','on','position',[pos3]);
        box on
        
         h2=subplot('position',pos3);
         set(h2, 'buttondownfcn', ['h=gca; hc3 = copyobj(h, gcf);set(hc3, ''Units'', ''normal'',' ...
        ' ''Position'', [expand_sz],' ...
        ' ''buttondownfcn'', ''delete(gca)'');']);

    end
    % T=text(5, maxDegsec*1.4, ['max yaw rate = ' int2str(maxDegsec) ' deg/s ' ]);
    % set(T, 'FontSize',fontsz-1)

    if ~isempty(filenameB)
        pos4=[0.075 0.3887 0.33 0.11];
        pos5=[0.075 0.2462 0.33 0.11];
        pos6=[0.075 0.1037 0.33 0.11];

        h2=subplot('position',pos4);
        cla
        xmax=max(((ttb/1000)/1000)); 
        ymax= maxDegsec*2;
        
        h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
        set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
        hold on
        if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(1,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
        if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(1,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
        if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(1,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
        if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(1,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
        if guiHandles.checkbox4.Value, h=plot((ttb/1000)/1000, DATmainB.DtermRaw(1,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
        if guiHandles.checkbox5.Value, h=plot((ttb/1000)/1000, DATmainB.DtermFilt(1,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
        if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(1,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
        if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(1,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
        if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(1,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
        if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(1,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
       
        h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
        h.BaseLine.BaseValue=-(maxDegsec*2);
        set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
        h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
        set(h,'linewidth',.1)
        h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
        set(h,'linewidth',.1)
        a = zoom(PTfig);
        if strcmp(a.Enable,'on'), 
            v = axis;
            axis(v)
        else  
            a.Enable='off'; 
            axis([0 xmax -ymax ymax])
        end
        T=text(5, -maxDegsec*1.5, ['% throttle']);
        set(T, 'FontSize',fontsz-1,'Color',[.2 .2 .2])   
        % T=text(5, maxDegsec*1.4, ['max roll rate = ' int2str(maxDegsec) ' deg/s ' ]);
        % set(T, 'FontSize',fontsz-1)
        ylabel('Roll ^o/s');
        set(h2,'color',[1 1 1],'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[pos4]);
        box on

         h2=subplot('position',pos4);
         set(h2, 'buttondownfcn', ['h=gca; hc4 = copyobj(h, gcf);set(hc4, ''Units'', ''normal'',' ...
        ' ''Position'', [expand_sz],' ...
        ' ''buttondownfcn'', ''delete(gca)'');']);
    
        h2=subplot('position',pos5);
        cla
        xmax=max(((ttb/1000)/1000)); 
        
        h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
        set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
        hold on
        if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(2,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
        if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(2,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
        if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(2,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
        if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(2,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
        if guiHandles.checkbox4.Value, h=plot((ttb/1000)/1000, DATmainB.DtermRaw(2,:));hold on;set(h,'color', [line.col4],'linewidth',1), end
        if guiHandles.checkbox5.Value, h=plot((ttb/1000)/1000, DATmainB.DtermFilt(2,:));hold on;set(h,'color', [line.col5],'linewidth',1), end
        if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(2,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
        if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(2,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
        if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(2,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
        if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(2,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
        
    
         h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
        h.BaseLine.BaseValue=-(maxDegsec*2);
        set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
        
        h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
        set(h,'linewidth',.1)
        h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
        set(h,'linewidth',.1)
       a = zoom(PTfig);
        if strcmp(a.Enable,'on'), 
            v = axis;
            axis(v)
        else  
            a.Enable='off'; 
            axis([0 xmax -ymax ymax])
        end
        box on
        T=text(5, -maxDegsec*1.5, ['% throttle']);
        set(T, 'FontSize',fontsz-1,'Color',[.2 .2 .2])   
        ylabel('Pitch ^o/s');
        set(h2,'color',[1 1 1],'fontsize',fontsz,'xticklabel',{},'tickdir','out','xminortick','on','yminortick','on','position',[pos5]);

         h2=subplot('position',pos5);
         set(h2, 'buttondownfcn', ['h=gca; hc5 = copyobj(h, gcf);set(hc5, ''Units'', ''normal'',' ...
        ' ''Position'', [expand_sz],' ...
        ' ''buttondownfcn'', ''delete(gca)'');']);
    
        h2=subplot('position',pos6);
        cla
        xmax=max(((ttb/1000)/1000)); 
        
        h=fill([t3,t4,t4,t3],[-maxDegsec,-maxDegsec,maxDegsec,maxDegsec],[colorB]);
        set(h,'FaceAlpha',0.3,'EdgeColor',[colorB]);
        hold on
        if guiHandles.checkbox0.Value, h=plot((ttb/1000)/1000, DATmainB.GyroRaw(3,:));hold on;set(h,'color', [line.col0],'linewidth',1), end
        if guiHandles.checkbox1.Value, h=plot((ttb/1000)/1000, DATmainB.GyroFilt(3,:));hold on;set(h,'color', [line.col1],'linewidth',1), end
        if guiHandles.checkbox2.Value, h=plot((ttb/1000)/1000, DATmainB.Pterm(3,:));hold on;set(h,'color', [line.col2],'linewidth',1), end
        if guiHandles.checkbox3.Value, h=plot((ttb/1000)/1000, DATmainB.Iterm(3,:));hold on;set(h,'color', [line.col3],'linewidth',1), end     
        if guiHandles.checkbox6.Value, h=plot((ttb/1000)/1000, DATmainB.Fterm(3,:));hold on;set(h,'color', [line.col6],'linewidth',1), end
        if guiHandles.checkbox7.Value, h=plot((ttb/1000)/1000, DATmainB.RCRate(3,:));hold on;set(h,'color', [line.col7],'linewidth',1), end
        if guiHandles.checkbox8.Value, h=plot((ttb/1000)/1000, DATmainB.PIDsum(3,:));hold on;set(h,'color', [line.col8],'linewidth',1), end
        if guiHandles.checkbox9.Value, h=plot((ttb/1000)/1000, DATmainB.PIDerr(3,:));hold on;set(h,'color', [line.col9],'linewidth',1), end
       

         h=area(((ttb/1000)/1000), ((DATmainB.RCRate(4,:)/100)*maxDegsec)-(maxDegsec*2));
        h.BaseLine.BaseValue=-(maxDegsec*2);
        set(h,'FaceColor',[.5 .5 .5],'FaceAlpha', .3,'EdgeColor',[.5 .5 .5],'Edgealpha',.3)
        
        h=plot([0  xmax], [maxDegsec maxDegsec],'k-');
        set(h,'linewidth',.1)
        h=plot([0  xmax], [-maxDegsec -maxDegsec],'k-');
        set(h,'linewidth',.1)
        a = zoom(PTfig);
        if strcmp(a.Enable,'on'), 
            v = axis;
            axis(v)
        else  
            a.Enable='off'; 
            axis([0 xmax -ymax ymax])
        end
        box on
        T=text(5, -maxDegsec*1.5, ['% throttle']);
        set(T, 'FontSize',fontsz-1,'Color',[.2 .2 .2])   
        ylabel('Yaw ^o/s');
        xlabel('time (s)');
        set(h2,'color',[1 1 1],'fontsize',fontsz,'tickdir','out','xminortick','on','yminortick','on','position',[pos6]);
       
        h2=subplot('position',pos6);
       set(h2, 'buttondownfcn', ['h=gca; hc6 = copyobj(h, gcf);set(hc6, ''Units'', ''normal'',' ...
        ' ''Position'', [expand_sz],' ...
        ' ''buttondownfcn'', ''delete(gca)'');']);
    end
end

%% spec plot only 2
if guiHandles.PlotSelect.Value==2 % clear all for spec plots
    set(guiHandles.checkbox0,'visible','off')
    set(guiHandles.checkbox1,'visible','off')
    set(guiHandles.checkbox2,'visible','off')
    set(guiHandles.checkbox3,'visible','off')
    set(guiHandles.checkbox4,'visible','off')
    set(guiHandles.checkbox5,'visible','off')
    set(guiHandles.checkbox6,'visible','off')
    set(guiHandles.checkbox7,'visible','off')
    set(guiHandles.checkbox8,'visible','off')
    set(guiHandles.checkbox9,'visible','off')

    pos1=[0.075 0.8243 0.33 0.11];
    pos2=[0.075 0.6875 0.33 0.11];
    pos3=[0.075 0.5450 0.33 0.11];
    delete(subplot('position',pos1))
    delete(subplot('position',pos2))
    delete(subplot('position',pos3))

    pos1=[0.075 0.3887 0.33 0.11];
    pos2=[0.075 0.2462 0.33 0.11];
    pos3=[0.075 0.1037 0.33 0.11];
    delete(subplot('position',pos1))
    delete(subplot('position',pos2))
    delete(subplot('position',pos3))
    delete(subplot(3,3,1))
    delete(subplot(3,3,4))
    delete(subplot(3,3,7))

    delete(subplot(3,6,1))
    delete(subplot(3,6,7))
    delete(subplot(3,6,13))

end

%% step resp + spec  3
if guiHandles.PlotSelect.Value==3
    %delete other panels
    delete(subplot(3,3,1));
    delete(subplot(3,3,4));
    delete(subplot(3,3,7));
    delete(subplot(3,6,1));
    delete(subplot(3,6,7));
    delete(subplot(3,6,13));
    set(guiHandles.checkbox0,'visible','off')
    set(guiHandles.checkbox1,'visible','off')
    set(guiHandles.checkbox2,'visible','off')
    set(guiHandles.checkbox3,'visible','off')
    set(guiHandles.checkbox4,'visible','off')
    set(guiHandles.checkbox5,'visible','off')
    set(guiHandles.checkbox6,'visible','off')
    set(guiHandles.checkbox7,'visible','off')
    set(guiHandles.checkbox8,'visible','off')
    set(guiHandles.checkbox9,'visible','off')

    posInfo.step1=[0.14 0.84 0.160 0.118];
    posInfo.step2=[0.14 0.71 0.160 0.118];
    posInfo.step3=[0.14 0.58 0.160 0.118];
    posInfo.step4=[0.14 0.38 0.160 0.118];
    posInfo.step5=[0.14 0.25 0.160 0.118];
    posInfo.step6=[0.14 0.12 0.160 0.108];

    lowerLim=.7;
    upperLim=1.4;
    rcDecelerationThresh=400;

    %%%%%%%%%%%%% step resp A %%%%%%%%%%%%%
    if ~isempty(filenameA)
        h2=subplot('position',posInfo.step1);cla

        samp_timeA=round(mean(diff(tta)));
        clear stepnfo resp_segments_norm 
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpA.RCRate(1,:), DATtmpA.PIDerr(1,:), rcDecelerationThresh, samp_timeA, lowerLim, upperLim); % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
        set(h, 'color',[colorA],'linewidth',2)
    
        h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
        h=text(420, 1.35, ['PIDF: ' char(string(rollPIDF_A(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.85,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .6,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .35,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)  
        h=text(420, .1,   ['ResponseDelay: ' num2str(ResponseDelayR_A)]);set(h,'fontsize',fontsz) 
        catch
            hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        h=text(5,1.25,['roll']);
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        axis([0 400 0 1.4])

        h2=subplot('position',posInfo.step2);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpA.RCRate(2,:), DATtmpA.PIDerr(2,:), rcDecelerationThresh, samp_timeA, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on
        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
        set(h, 'color',[colorA],'linewidth',2)
    
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
        h=text(420, 1.3, ['PIDF: ' char(string(pitchPIDF_A(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.05, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.8,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .55,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .3,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz) 
        h=text(420, .05,   ['ResponseDelay: ' num2str(ResponseDelayP_A)]);set(h,'fontsize',fontsz) 
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['pitch']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
   
        h2=subplot('position',posInfo.step3);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpA.RCRate(3,:), DATtmpA.PIDerr(3,:), rcDecelerationThresh, samp_timeA, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on
        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
    
        set(h, 'color',[colorA],'linewidth',2)
         h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
         h=text(420, 1.25, ['PIDF: ' char(string(yawPIDF_A(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.75,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .5,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .25,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)
        h=text(420, 0,   ['ResponseDelay: ' num2str(ResponseDelayY_A)]);set(h,'fontsize',fontsz) 
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        h=xlabel('time (ms)');
        set(h,'fontsize',fontsz)
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['yaw']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
       
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        ylabel({'Response'; 'Strength'})
        xlabel('time (ms)')
        axis([0 400 0 1.4])
    end

    %%%%%%%%%%%%% step resp B %%%%%%%%%%%%%
    if ~isempty(filenameB)
        samp_timeB=round(mean(diff(ttb)));

        h2=subplot('position',posInfo.step4);cla
        clear stepnfo resp_segments_norm
        try 
        [resp_segments_norm, t] = PTstepcalc(DATtmpB.RCRate(1,:), DATtmpB.PIDerr(1,:), rcDecelerationThresh, samp_timeB, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end
    
        set(h, 'color',[colorB],'linewidth',2)
         h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
         h=text(420, 1.35, ['PIDF: ' char(string(rollPIDF_B(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.85,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .6,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .35,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)
        h=text(420, .1,   ['ResponseDelay: ' num2str(ResponseDelayR_B)]);set(h,'fontsize',fontsz) 
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['roll ']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])

        h2=subplot('position',posInfo.step5);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpB.RCRate(2,:), DATtmpB.PIDerr(2,:), rcDecelerationThresh, samp_timeB, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t, resp_segments_norm');
            stepnfo=stepinfo(resp_segments_norm,t);
        end

    
        set(h, 'color',[colorB],'linewidth',2)
         h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
         h=text(420, 1.3, ['PIDF: ' char(string(pitchPIDF_B(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1.05, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.8,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .55,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .3,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz)
        h=text(420, .05,   ['ResponseDelay: ' num2str(ResponseDelayP_B)]);set(h,'fontsize',fontsz)
        catch
             hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['pitch']);
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
       
        h2=subplot('position',posInfo.step6);cla
        clear stepnfo resp_segments_norm
        try
        [resp_segments_norm, t] = PTstepcalc(DATtmpB.RCRate(3,:), DATtmpB.PIDerr(3,:), rcDecelerationThresh, samp_timeB, lowerLim, upperLim);  % PIDerr_A
        h=plot(t,resp_segments_norm');
        set(h,'color',[.9 .9 .9])
        hold on

        if size(resp_segments_norm,1)>1
            h=plot(t,nanmean(resp_segments_norm));
            stepnfo=stepinfo(nanmean(resp_segments_norm),t);
        else
            h=plot(t,(resp_segments_norm'));
            stepnfo=stepinfo(resp_segments_norm,t);
        end
    
        set(h, 'color',[colorB],'linewidth',2)
        h=text(340,1.25,['N=' int2str(size(resp_segments_norm,1)) ]);set(h,'fontsize',fontsz)
        h=text(420, 1.25, ['PIDF: ' char(string(yawPIDF_B(:,2)))]);set(h,'fontsize',fontsz)
        h=text(420, 1, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz)
        h=text(420, 0.75,['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz)
        h=text(420, .5,['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz)
        h=text(420, .25,   ['SettlingTime: ' num2str(stepnfo.SettlingTime)]);set(h,'fontsize',fontsz) 
        h=text(420, 0,   ['ResponseDelay: ' num2str(ResponseDelayY_B)]);set(h,'fontsize',fontsz)
        catch
            hold on;h=text(125, .75,'insufficient data');set(h,'fontsize',fontsz) 
        end
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        h=xlabel('time (ms)');
        set(h,'fontsize',fontsz)
        plot([0 400],[1 1],'k--')
        h=text(5,1.25,['yaw']);
        set(h,'fontsize',fontsz)
    
        set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400],'xticklabel',{0 100 200 300 400},'ytick',[0 1],'tickdir','out')
        box off
        h=ylabel({'Response'; 'Strength'});
        set(h,'fontsize',fontsz)
        h=xlabel('time (ms)');
        set(h,'fontsize',fontsz)
        axis([0 400 0 1.4])
    end
end

%% PIDerr 4
if guiHandles.PlotSelect.Value==4
set(guiHandles.checkbox0,'visible','off')
set(guiHandles.checkbox1,'visible','off')
set(guiHandles.checkbox2,'visible','off')
set(guiHandles.checkbox3,'visible','off')
set(guiHandles.checkbox4,'visible','off')
set(guiHandles.checkbox5,'visible','off')
set(guiHandles.checkbox6,'visible','off')
set(guiHandles.checkbox7,'visible','off')
set(guiHandles.checkbox8,'visible','off')
set(guiHandles.checkbox9,'visible','off')

    h2=subplot(3,3,1);
    cla

    for i=1:10
        try
        thr=(DATtmpA.RCRate(4,:)>((i-1)*10) & DATtmpA.RCRate(4,:)<=(i*10));
        Tst_a_R_m(i)=nanmean(abs(DATtmpA.PIDerr(1,RC_PID_Thresh_A & thr)));
        Tst_a_P_m(i)=nanmean(abs(DATtmpA.PIDerr(2,RC_PID_Thresh_A & thr)));
        Tst_a_Y_m(i)=nanmean(abs(DATtmpA.PIDerr(3,RC_PID_Thresh_A & thr)));
        Tst_a_R_sd(i)=nanstd(abs(DATtmpA.PIDerr(1,RC_PID_Thresh_A & thr))) / sqrt(length(find(thr==1)));
        Tst_a_P_sd(i)=nanstd(abs(DATtmpA.PIDerr(2,RC_PID_Thresh_A & thr))) / sqrt(length(find(thr==1)));
        Tst_a_Y_sd(i)=nanstd(abs(DATtmpA.PIDerr(3,RC_PID_Thresh_A & thr))) / sqrt(length(find(thr==1)));
        catch
        end
        try
        thrb=(DATtmpB.RCRate(4,:)>((i-1)*10) & DATtmpB.RCRate(4,:)<=(i*10));     
        Tst_b_R_m(i)=nanmean(abs(DATtmpB.PIDerr(1,RC_PID_Thresh_B & thrb)));
        Tst_b_P_m(i)=nanmean(abs(DATtmpB.PIDerr(2,RC_PID_Thresh_B & thrb)));
        Tst_b_Y_m(i)=nanmean(abs(DATtmpB.PIDerr(3,RC_PID_Thresh_B & thrb)));
        Tst_b_R_sd(i)=nanstd(abs(DATtmpB.PIDerr(1,RC_PID_Thresh_B & thrb))) / sqrt(length(find(thrb==1)));
        Tst_b_P_sd(i)=nanstd(abs(DATtmpB.PIDerr(2,RC_PID_Thresh_B & thrb))) / sqrt(length(find(thrb==1)));
        Tst_b_Y_sd(i)=nanstd(abs(DATtmpB.PIDerr(3,RC_PID_Thresh_B & thrb))) / sqrt(length(find(thrb==1)));
        catch
        end
    end


    posA=.8:1:9.8;
    posB=1.2:1:10.2;
    try
        h=errorbar([posA],[Tst_a_R_m ], [Tst_a_R_sd ] );hold on
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posA], (Tst_a_R_m));
        set(h, 'facecolor',[colorA],'facealpha',.8,'BarWidth',.4)
    catch
    end
    try
        h=errorbar([posB],[ Tst_b_R_m], [ Tst_b_R_sd] );
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posB], (Tst_b_R_m));
        set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
    catch
    end
    set(h2,'xtick',[0:2:10], 'xticklabel',{'0' '20','40', '60', '80', '100'});
    set(h2,'tickdir','out','xminortick','on','yminortick','on');
    set(h2,'fontsize',fontsz);
    box off
    ylabel(['mean |R error| ^o/s'])

    %xlabel('% throttle ')
    axis([0 11 0 30])
%     h=title('mean |PID error|');
%     set(h,'fontsize',fontsz)


    h2=subplot(3,3,4);
    cla
    try
        h=errorbar([posA],[Tst_a_P_m ], [Tst_a_P_sd ] );hold on
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posA], (Tst_a_P_m));
        set(h, 'facecolor',[colorA],'facealpha',.8,'BarWidth',.4)
    catch
    end
    try
        h=errorbar([posB],[ Tst_b_P_m], [ Tst_b_P_sd] );
        set(h, 'color','k', 'LineStyle','none');
        h=bar([posB], (Tst_b_P_m));
        set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
    catch
    end
    set(h2,'xtick',[0:2:10], 'xticklabel',{'0' '20','40', '60', '80', '100'});
    set(h2,'tickdir','out','xminortick','on','yminortick','on');
    set(h2,'fontsize',fontsz);
    box off
    ylabel(['mean |P error| ^o/s'])

    %xlabel('% throttle ')
    axis([0 11 0 30])

    h2=subplot(3,3,7);
    cla
    try
    h=errorbar([posA],[Tst_a_Y_m ], [Tst_a_Y_sd ] );hold on
    set(h, 'color','k', 'LineStyle','none');
    h=bar([posA], (Tst_a_Y_m));
    set(h, 'facecolor',[colorA ],'facealpha',.8,'BarWidth',.4)
    catch
    end
    try
    h=errorbar([posB],[ Tst_b_Y_m], [ Tst_b_Y_sd] );
    set(h, 'color','k', 'LineStyle','none');
    h=bar([posB], (Tst_b_Y_m));
    set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
    catch
    end

    set(h2,'xtick',[0:2:10], 'xticklabel',{'0' '20','40', '60', '80', '100'});
    set(h2,'tickdir','out','xminortick','on','yminortick','on');
    set(h2,'fontsize',fontsz);
    box off
    ylabel(['mean |Y error| ^o/s'])

    xlabel('% throttle ')
    axis([0 11 0 30]) 
      
end

    

%% Histogram

pos1=[0.85 0.23 0.1 0.1];
pos2=[0.85 0.11 0.1 0.1];
PTfig(1);
if ~isempty(filenameA)
    hhist=subplot('position',pos1);
    cla
    h=histogram(DATtmpA.RCRate(4,:),'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)
    grid on
    
    if isempty(filenameB)
         set(hhist,'tickdir','out','xlim',[1 100],'xtick',[1 20 40 60 80 99],'xticklabels',{0 20 40 60 80 100},'ylim',[0 .1],'ytick',[0 .05 .1],'yticklabels',{0 5 10},'fontsize',fontsz, 'Position',[pos1]);
        xlabel('% throttle')
        ylabel('% of flight')
    else
        set(hhist,'tickdir','out','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{},'yticklabels',{0 5 10},'fontsize',fontsz, 'Position',[pos1]);
        xlabel('');
    end
    axis([1 99 0 .1])
end

if ~isempty(filenameB)
    hhist=subplot('position',pos2);
    cla
    h=histogram(DATtmpB.RCRate(4,:),'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorB],'FaceAlpha',.9,'edgecolor',[colorB],'EdgeAlpha',.7)
    set(hhist,'tickdir','out','xlim',[1 100],'xtick',[1 20 40 60 80 99],'xticklabels',{0 20 40 60 80 100},'ylim',[0 .1],'ytick',[0 .05 .1],'yticklabels',{0 5 10},'fontsize',fontsz,'position',[pos2]);
    axis([1 99 0 .1])
    grid on
    xlabel('% throttle')
    ylabel('                    % of flight')
end


% end computation
set(PTfig, 'pointer', 'arrow')

else
    guiHandles.PlotSelect.Value=1;
    errordlg('Please select file(s) then click ''load+run''', 'Error, no data');
    pause(2);
end


