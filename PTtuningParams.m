%% PTtuningParams - scripts for plotting tune-related parameters

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
PTtunefig=figure(4);

prop_max_screen=(max([PTtunefig.Position(3) PTtunefig.Position(4)]));
fontsz=(screensz_multiplier*prop_max_screen);

tuneCrtlpanel.FontSize=fontsz;  
guiHandlesTune.saveFig4.FontSize=fontsz;
guiHandlesTune.run4.FontSize=fontsz;
guiHandlesTune.fileListWindowStep.FontSize=fontsz;
guiHandlesTune.clearPlots.FontSize=fontsz;
guiHandles.maxYStepTxt.FontSize=fontsz;
guiHandles.maxYStepInput.FontSize=fontsz;


%% step resp computed directly from set point and gyro
ylab={'R';'P';'Y'};
ylab2={'roll';'pitch';'yaw'};

%%%%%%%%%%%%% step resp %%%%%%%%%%%%%
figure(PTtunefig)

ymax = str2num(guiHandles.maxYStepInput.String);
hwarn=[];
if ~guiHandlesTune.clearPlots.Value
    cnt = 0;
    
    set(PTtunefig, 'pointer', 'watch')
    pause(.05);
    
    for f = guiHandlesTune.fileListWindowStep.Value     
        fcnt = fcnt + 1;   
        if fcnt <= 10
            for p=1:3   
                cnt = cnt + 1;
                try 
                    if ~updateStep   
                        clear H G
                        eval(['H = T{f}.setpoint_' int2str(p-1) '_(tIND{f});'])
                        eval(['G = T{f}.gyroADC_' int2str(p-1) '_(tIND{f});'])
                        [stepresp_A{p} tA] = PTstepcalc(H, G, A_lograte(f));
                    end
                catch
                    stepresp_A{p}=[];
                end

                h1=subplot('position',posInfo.TparamsPos(p,:)); 
                hold on

                 if size(stepresp_A{p},1)>1
                    m=nanmean(stepresp_A{p});

                    hold on
                    h1=plot(tA,m);         
                    set(h1, 'color',[multiLineCols(fcnt,:)],'linewidth', 3);
                    latencyHalfHeight=(find(m>.5,1) / A_lograte(f)) - 1;
                    peakresp=max(m);
                    peaktime=find(m == max(m));

                    eval(['PID=' ylab2{p} 'PIDF{f};'])  
                    if cnt <= 3, h=text(505, ymax, ['    P, I, D, Dm, F']);set(h,'fontsize',fontsz,'fontweight','bold'); end
                    h=text(505, ymax-(fcnt*(ymax*.09)), [int2str(fcnt) ') ' PID '  (n=' int2str(size(stepresp_A{p},1)) ')  |  Peak = ' num2str(peakresp) ', Peak Time = ' num2str(peaktime) 'ms, Latency = ' num2str(latencyHalfHeight) 'ms']);set(h,'fontsize',fontsz);  
                    set(h, 'Color',[multiLineCols(fcnt,:)],'fontweight','bold')
                 else
                    if cnt <= 3, h=text(505, ymax, ['    P, I, D, Dm, F']);set(h,'fontsize',fontsz,'fontweight','bold'); end
                    h=text(505, ymax-(fcnt*(ymax*.09)), [int2str(fcnt) ') insufficient data']); 
                    set(h,'Color',[multiLineCols(fcnt,:)],'fontsize',fontsz, 'fontweight','bold')
                end

                if cnt <= 3, set(gca,'fontsize',fontsz,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400 500],'xticklabel',{'0' '100' '200' '300' '400' '500'},'ytick',[0 .25 .5 .75 1 1.25 1.5 1.75 2],'tickdir','out'); end

                box off
                if cnt <= 3, h=ylabel(['Step Response '], 'fontweight','bold'); end
                set(h,'fontsize',fontsz)
                if p==3, xlabel('time (ms)', 'fontweight','bold');end
                if p==1, title('Step Response Functions');end
                if cnt <= 3,
                    h=text(5,ymax-0.1,ylab2{p}); 
                    set(h,'fontsize',fontsz,'fontweight','bold')
                end
                 h=plot([0 500],[1 1],'k--');
                set(h,'linewidth',.5)
                axis([0 500 0 ymax])
                grid on
            end    
        elseif fcnt == 11
            warndlg('10 files maximum. Click reset.');
        end 
    end
   set(PTtunefig, 'pointer', 'arrow')

    updateStep=0;
else
    for p = 1 : 3
        h1=subplot('position',posInfo.TparamsPos(p,:)); cla
    end
end
    




