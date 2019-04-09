%% PTplotPIDerror 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

set(PTerrfig, 'pointer', 'watch')

if ~isempty(filenameA) || ~isempty(filenameB)
    %% update fonts

    prop_max_screen=(max([PTerrfig.Position(3) PTerrfig.Position(4)]));
    fontsz3=round(screensz_multiplier*prop_max_screen);

    guiHandlesPIDerr.refresh.FontSize=fontsz3; 
    guiHandlesPIDerr.maxSticktext.FontSize=fontsz3;
    guiHandlesPIDerr.maxStick.FontSize=fontsz3;
    guiHandlesPIDerr.saveFig3.FontSize=fontsz3;
 
    
      %% PID error distributions 
    ylab2={'roll';'pitch';'yaw'};
    figure(PTerrfig);  
    for p=1:3        
        delete(subplot('position',posInfo.PIDerrAnalysis(p,:)))
        h1=subplot('position',posInfo.PIDerrAnalysis(p,:)); cla
        hold on    

         if ~isempty(filenameA)            
            RCRateALL_Thresh_A=abs(DATtmpA.RCRate(1,:)) < maxDegsec & abs(DATtmpA.RCRate(2,:)) < maxDegsec & abs(DATtmpA.RCRate(3,:)) < maxDegsec;
            [yA xA]=hist(DATtmpA.PIDerr(p,RCRateALL_Thresh_A),-1000:1:1000); %<maxDegsec),-maxDegsec:1:maxDegsec);
            yA=yA/max(yA);
            h=plot(xA, yA);
            set(h, 'color',[colorA], 'Linewidth',2);
            if p==3
                set(h1,'xtick',[-40:10:40],'ytick',[0:.25:1],'tickdir','out','xminortick','on','yminortick','on','fontsize',fontsz3);
                xlabel('PID error (deg/s)' ,'fontweight','bold');
            else
                set(h1,'xtick',[-40:10:40],'xticklabel',{},'ytick',[0:.25:1],'tickdir','out','xminortick','on','yminortick','on','fontsize',fontsz3);
            end
            
            ylabel(['normalized freq '] ,'fontweight','bold')
            h=text(-37,.9, ylab2{p});
            set(h,'fontsize',fontsz3,'fontweight','bold')
            grid on
            axis([-40 40 0 1])
            h=text(10,.9,['[A]s.d.=' num2str(std(yA))]);
            set(h,'fontsize',fontsz3,'color',colorA,'fontweight','bold')
         end
 
        if ~isempty(filenameB)            
             RCRateALL_Thresh_B=abs(DATtmpB.RCRate(1,:)) < maxDegsec & abs(DATtmpB.RCRate(2,:)) < maxDegsec & abs(DATtmpB.RCRate(3,:)) < maxDegsec;
            [yB xB]=hist(DATtmpB.PIDerr(p,RCRateALL_Thresh_B),-1000:1:1000);
            yB=yB/max(yB);
            h=plot(xB, yB);
            set(h, 'color',[colorB], 'Linewidth',2);
            if p==3
                set(h1,'xtick',[-40:10:40],'ytick',[0:.25:1],'tickdir','out','xminortick','on','yminortick','on','fontsize',fontsz3);
                xlabel('PID error (deg/s)' ,'fontweight','bold');
            else
                set(h1,'xtick',[-40:10:40],'xticklabel',{},'ytick',[0:.25:1],'tickdir','out','xminortick','on','yminortick','on','fontsize',fontsz3);
            end
            ylabel(['normalized freq '] ,'fontweight','bold')  
            h=text(-37,.9, ylab2{p});
            set(h,'fontsize',fontsz3,'fontweight','bold')
            grid on
            axis([-40 40 0 1])
            h=text(10,.8,['[B]s.d.=' num2str(std(yB))]);
            set(h,'fontsize',fontsz3,'color',colorB,'fontweight','bold') 
        end

        try
        [h pval stat] = kstest2(yA,yB);
        if pval<=.05, sigflag='*'; else, sigflag=''; end
        h=text(10,.7,['p=' num2str(pval) sigflag]);set(h,'fontsize',fontsz3,'fontweight','bold')
        catch
        end

        box off
        if p==1, 
            title('normalized PID error distributions'); 
        end
    end
     
        
     %% compute PID error and latency x % stick deflection
    if ~updateErr
          t=[.1 .2 .3 .4 .5 .6 .7 .8 .9 1];
         
          cutoff=40; % ignore less frequent error at the extremes, outliers
        if ~isempty(filenameA)
            for i=1:length(t)    
                clear RCRateALL_Thresh_A
                m=max(max(abs(DATtmpA.RCRate))) * (t(i));
                RCRateALL_Thresh_A=abs(DATtmpA.RCRate(1,:)) < m & abs(DATtmpA.RCRate(2,:)) < m & abs(DATtmpA.RCRate(3,:)) < m;
                for j=1:3 
                     perr_a=[]; 
                    perr_a=DATtmpA.PIDerr(j,abs(DATtmpA.PIDerr(j,:)) < cutoff & RCRateALL_Thresh_A); 
                    Perr_a_m(j,i)=nanmean(abs(perr_a));
                    Perr_a_se(j,i)=nanstd(abs(perr_a)) / sqrt(length(perr_a));
                end
            end
        end

        t=[.1 .2 .3 .4 .5 .6 .7 .8 .9 1];
        if ~isempty(filenameB)
            for i=1:length(t)  
                clear RCRateALL_Thresh_B 
               m=max(max(abs(DATtmpB.RCRate))) * (t(i));
                 RCRateALL_Thresh_B=abs(DATtmpB.RCRate(1,:)) < m & abs(DATtmpB.RCRate(2,:)) < m & abs(DATtmpB.RCRate(3,:)) < m;      
                for j=1:3 
                    perr_b=[];
                    perr_b=DATtmpB.PIDerr(j,abs(DATtmpB.PIDerr(j,:)) < cutoff & RCRateALL_Thresh_B); 
                    Perr_b_m(j,i)=nanmean(abs(perr_b));
                    Perr_b_se(j,i)=nanstd(abs(perr_b)) / sqrt(length(perr_b));
                end
            end
        end
        updateErr=0;
    end

    %% PID error x stick
    ylab=['R';'P';'Y'];
    for p=1:3
        delete(subplot('position',posInfo.PIDerrAnalysis(p+3,:)))
        h1=subplot('position',posInfo.PIDerrAnalysis(p+3,:)); cla
        posA=.8:1:9.8;
        posB=1.2:1:10.2;
        if ~isempty(filenameA)
            minyA=min(Perr_a_m(p,:))-.5;if minyA<0, minyA=0;end
            maxyA=max(Perr_a_m(p,:))+.5;
            h=errorbar([posA],[Perr_a_m(p,:) ], [Perr_a_se(p,:) ] );hold on
            set(h, 'color','k', 'LineStyle','none');
            h=bar([posA], (Perr_a_m(p,:) ));
            set(h, 'facecolor',[colorA],'facealpha',.8,'BarWidth',.4)
            set(h1,'tickdir','out','xminortick','off','yminortick','on');
            set(h1,'fontsize',fontsz3);
            ylabel(['mean |' ylab(p) ' error| ^o/s'], 'fontweight','bold')
            set(h1,'xtick',[0:2:10], 'xticklabel',{''},'ygrid','on');
             axis([0 11 minyA maxyA])
            box off
        if p==3
            set(h1,'xtick',[0:1:10], 'xticklabel',{'0', '', '20','','40','', '60','', '80','', '100'});
            xlabel('max stick deflection (%)', 'fontweight','bold')
         else
                set(h1,'xtick',[0:1:10], 'xticklabel',{'', '', '','','','', '','', '','', ''});
        end

        end
        if ~isempty(filenameB)
            minyB=min(Perr_b_m(p,:))-.5;if minyB<0, minyB=0;end
            maxyB=max(Perr_b_m(p,:))+.5;
            h=errorbar([posB],[ Perr_b_m(p,:)], [ Perr_b_se(p,:)] );
            set(h, 'color','k', 'LineStyle','none');
            h=bar([posB], (Perr_b_m(p,:)));
            set(h, 'facecolor',[colorB],'facealpha',.8,'BarWidth',.4)
            set(h1,'tickdir','out','xminortick','off','yminortick','on');
            set(h1,'fontsize',fontsz3);
            ylabel(['mean |' ylab(p) ' error| ^o/s'], 'fontweight','bold')
            set(h1,'xtick',[0:2:10], 'xticklabel',{''},'ygrid','on'); 
             axis([0 11 min([minyA minyB]) max([maxyA maxyB])])
            box off
            if p==3
            set(h1,'xtick',[0:1:10], 'xticklabel',{'0', '', '20','','40','', '60','', '80','', '100'});
                xlabel('max stick deflection (%)', 'fontweight','bold')
            else
                set(h1,'xtick',[0:1:10], 'xticklabel',{'', '', '','','','', '','', '','', ''});
            end
        end

        if p==1, 
            title('mean abs PID error X stick deflection');
        end
    end


%     
   
  
   
end

set(PTerrfig, 'pointer', 'arrow')

    