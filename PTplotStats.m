%% PTplotStats - script to plot flight statistics

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(filenameA) || ~isempty(filenameB)
    set(PTstatsfig, 'pointer', 'watch')
    pause(.05)
    %% update fonts

prop_max_screen=(max([PTstatsfig.Position(3) PTstatsfig.Position(4)]));
fontsz5=round(screensz_multiplier*prop_max_screen);

guiHandlesStats.saveFig5.FontSize=fontsz5; 
guiHandlesStats.refresh.FontSize=fontsz5; 
guiHandlesStats.degsecStick.FontSize=fontsz5; 
guiHandlesStats.crossAxesStats.FontSize=fontsz5; 

guiHandlesStats.crossAxesStats_text.FontSize=fontsz5;
guiHandlesStats.crossAxesStats_input.FontSize=fontsz5;
guiHandlesStats.crossAxesStats_text2.FontSize=fontsz5;
guiHandlesStats.crossAxesStats_input2.FontSize=fontsz5;

%% Histograms   

if guiHandlesStats.crossAxesStats.Value==1    
    if ~isempty(filenameA)
        if ~updateStats
        
        rcRates=dataA.rates(1,:);
        rcExpo=dataA.rates(2,:);
        Srates=dataA.rates(3,:);
        const=200;
        if FirmwareCode_A==INAV, const=1000; end

        RateCurveRoll_A=PTrc2deg([0:5:500],dataA.rates(1,1), dataA.rates(2,1), dataA.rates(3,1), const);
        RateCurvePitch_A=PTrc2deg([0:5:500],dataA.rates(1,2), dataA.rates(2,2), dataA.rates(3,2), const);
        RateCurveYaw_A=PTrc2deg([0:5:500],dataA.rates(1,3), dataA.rates(2,3), dataA.rates(3,3), const);

        Yscale=round((max([max(RateCurveRoll_A) max(RateCurvePitch_A) max(RateCurveYaw_A)])) / 50) * 50;

        if guiHandlesStats.degsecStick.Value==1, 
            RateCurveRoll_A=(diff(RateCurveRoll_A));
            RateCurvePitch_A=(diff(RateCurvePitch_A));
            RateCurveYaw_A=(diff(RateCurveYaw_A));

            Yscale=round(max([max(RateCurveRoll_A) max(RateCurvePitch_A) max(RateCurveYaw_A)]));
        end

        Rpercent_A=PTPercent(DATtmpA.RCcommand(1,:));
        Ppercent_A=PTPercent(DATtmpA.RCcommand(2,:));
        Ypercent_A=PTPercent(DATtmpA.RCcommand(3,:));
        Tpercent_A=DATtmpA.RCRate(4,:); % already computed for throttle
        end

        hhist=subplot('position',posInfo.statsPos(1,:));
        cla   
        h=histogram(Rpercent_A,'Normalization','probability','BinWidth',1);      
        y=xlabel('% roll','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);                 
        ylabel('% of flight','fontweight','bold')    
        set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)  

        hold on

        [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveRoll_A)-1],RateCurveRoll_A(1,2:end));
        set(ax(1),'Ycolor',[colorA])
        set(ax(2),'Xlim',[1 100],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
        ax(2).YLabel.String='deg/s';
        if guiHandlesStats.degsecStick.Value==1, 
            ax(2).YLabel.String='deg/s/stick travel units';
        end
        set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
        hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveRoll_A(20) RateCurveRoll_A(40) RateCurveRoll_A(60) RateCurveRoll_A(80)],'ko','Parent', ax(2)); 
        set(h,'markerfacecolor','k') 

        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(1,:)]);
        axis([1 100 0 .1])

        text(21, RateCurveRoll_A(20),[int2str(RateCurveRoll_A(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);  
        text(41, RateCurveRoll_A(40),[int2str(RateCurveRoll_A(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(61, RateCurveRoll_A(60),[int2str(RateCurveRoll_A(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(81, RateCurveRoll_A(80),[int2str(RateCurveRoll_A(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(2, .095,['rates: ' num2str(rcRates(1))],'Parent', ax(1),'fontsize',fontsz5); 
        text(2, .085,['expo: ' num2str(rcExpo(1))],'Parent', ax(1),'fontsize',fontsz5);
        text(2, .075,['super: ' num2str(Srates(1))],'Parent', ax(1),'fontsize',fontsz5);
        axis([1 100 0 .1])
        grid on

        hhist=subplot('position',posInfo.statsPos(2,:));
        cla
        h=histogram(Ppercent_A,'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)    
        y=xlabel('% pitch','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
        ylabel('% of flight','fontweight','bold')  
         hold on    
        [ax,h1,h2]=plotyy(0,0,[1:length(RateCurvePitch_A)-1],RateCurvePitch_A(1,2:end));
        set(ax(1),'Ycolor',[colorA])
        set(ax(2),'Xlim',[1 100],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
        ax(2).YLabel.String='deg/s';
        if guiHandlesStats.degsecStick.Value==1, 
            ax(2).YLabel.String='deg/s/stick travel units';
        end
        set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
        hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurvePitch_A(20) RateCurvePitch_A(40) RateCurvePitch_A(60) RateCurvePitch_A(80)],'ko','Parent', ax(2));     
        set(h,'markerfacecolor','k')  

        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(2,:)]);
        axis([1 100 0 .1])

        text(21, RateCurvePitch_A(20),[int2str(RateCurvePitch_A(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(41, RateCurvePitch_A(40),[int2str(RateCurvePitch_A(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(61, RateCurvePitch_A(60),[int2str(RateCurvePitch_A(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(81, RateCurvePitch_A(80),[int2str(RateCurvePitch_A(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);  
        text(2, .095,['rates: ' num2str(rcRates(2))],'Parent', ax(1),'fontsize',fontsz5); 
        text(2, .085,['expo: ' num2str(rcExpo(2))],'Parent', ax(1),'fontsize',fontsz5);
        text(2, .075,['super: ' num2str(Srates(2))],'Parent', ax(1),'fontsize',fontsz5);
        axis([1 100 0 .1])
        grid on

        hhist=subplot('position',posInfo.statsPos(3,:));
        cla
        h=histogram(Ypercent_A,'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)    
        y=xlabel('% yaw','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
        ylabel('% of flight','fontweight','bold')

         hold on
        [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveYaw_A)-1],RateCurveYaw_A(1,2:end));
        set(ax(1),'Ycolor',[colorA])
        set(ax(2),'Xlim',[1 100],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
        ax(2).YLabel.String='deg/s';
        if guiHandlesStats.degsecStick.Value==1, 
            ax(2).YLabel.String='deg/s/stick travel units';
        end
        set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
        hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveYaw_A(20) RateCurveYaw_A(40) RateCurveYaw_A(60) RateCurveYaw_A(80)],'ko','Parent', ax(2)); 
        set(h,'markerfacecolor','k')  

        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(3,:)]);  
        axis([1 100 0 .1])

        text(21, RateCurveYaw_A(20),[int2str(RateCurveYaw_A(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(41, RateCurveYaw_A(40),[int2str(RateCurveYaw_A(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(61, RateCurveYaw_A(60),[int2str(RateCurveYaw_A(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(81, RateCurveYaw_A(80),[int2str(RateCurveYaw_A(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);  
        text(2, .095,['rates: ' num2str(rcRates(3))],'Parent', ax(1),'fontsize',fontsz5);    
        text(2, .085,['expo: ' num2str(rcExpo(3))],'Parent', ax(1),'fontsize',fontsz5);
        text(2, .075,['super: ' num2str(Srates(3))],'Parent', ax(1),'fontsize',fontsz5);
        axis([1 100 0 .1])
        grid on

         hhist=subplot('position',posInfo.statsPos(4,:));
        cla
        h=histogram(Tpercent_A,'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7);
        grid on
        y=xlabel('% throttle','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
        ylabel('% of flight', 'color',[colorA],'fontweight','bold')
        set(hhist,'ycolor',[colorA],'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(4,:)]);  
        axis([1 100 0 .1])
    end

    if ~isempty(filenameB)
        if ~updateStats
        rcRates=dataB.rates(1,:);
        rcExpo=dataB.rates(2,:);
        Srates=dataB.rates(3,:);
        const=200;
        if FirmwareCode_B==INAV, const=1000; end

        RateCurveRoll_B=PTrc2deg([0:5:500],dataB.rates(1,1), dataB.rates(2,1), dataB.rates(3,1), const);
        RateCurvePitch_B=PTrc2deg([0:5:500],dataB.rates(1,2), dataB.rates(2,2), dataB.rates(3,2), const);
        RateCurveYaw_B=PTrc2deg([0:5:500],dataB.rates(1,3), dataB.rates(2,3), dataB.rates(3,3), const);

        Yscale=round((max([max(RateCurveRoll_B) max(RateCurvePitch_B) max(RateCurveYaw_B)])) / 50) * 50;

        if guiHandlesStats.degsecStick.Value==1, 
            RateCurveRoll_B=(diff(RateCurveRoll_B));
            RateCurvePitch_B=(diff(RateCurvePitch_B));
            RateCurveYaw_B=(diff(RateCurveYaw_B));

            Yscale=round(max([max(RateCurveRoll_B) max(RateCurvePitch_B) max(RateCurveYaw_B)]));
        end

        Rpercent_B=PTPercent(DATtmpB.RCcommand(1,:));
        Ppercent_B=PTPercent(DATtmpB.RCcommand(2,:));
        Ypercent_B=PTPercent(DATtmpB.RCcommand(3,:));
        Tpercent_B=DATtmpB.RCRate(4,:); % already computed for throttle
        end

        hhist=subplot('position',posInfo.statsPos(5,:));
        cla   
        h=histogram(Rpercent_B,'Normalization','probability','BinWidth',1);      
        y=xlabel('% roll','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);                 
        ylabel('% of flight','fontweight','bold')    
        set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)  

        hold on

        [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveRoll_B)-1],RateCurveRoll_B(1,2:end));
        set(ax(1),'Ycolor',[colorB])
        set(ax(2),'Xlim',[1 100],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
        ax(2).YLabel.String='deg/s';
        if guiHandlesStats.degsecStick.Value==1, 
            ax(2).YLabel.String='deg/s/stick travel units';
        end
        set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
        hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveRoll_B(20) RateCurveRoll_B(40) RateCurveRoll_B(60) RateCurveRoll_B(80)],'ko','Parent', ax(2)); 
        set(h,'markerfacecolor','k')  

        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(5,:)]);
        axis([1 100 0 .1])

        text(21, RateCurveRoll_B(20),[int2str(RateCurveRoll_B(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(41, RateCurveRoll_B(40),[int2str(RateCurveRoll_B(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(61, RateCurveRoll_B(60),[int2str(RateCurveRoll_B(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(81, RateCurveRoll_B(80),[int2str(RateCurveRoll_B(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);   
        text(2, .095,['rates: ' num2str(rcRates(1))],'Parent', ax(1),'fontsize',fontsz5); 
        text(2, .085,['expo: ' num2str(rcExpo(1))],'Parent', ax(1),'fontsize',fontsz5);
        text(2, .075,['super: ' num2str(Srates(1))],'Parent', ax(1),'fontsize',fontsz5);

        axis([1 100 0 .1])
        grid on

        hhist=subplot('position',posInfo.statsPos(6,:));
        cla
        h=histogram(Ppercent_B,'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)    
        y=xlabel('% pitch','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
        ylabel('% of flight','fontweight','bold');

         hold on    
        [ax,h1,h2]=plotyy(0,0,[1:length(RateCurvePitch_B)-1],RateCurvePitch_B(1,2:end));
        set(ax(1),'Ycolor',[colorB])
        set(ax(2),'Xlim',[1 100],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
        ax(2).YLabel.String='deg/s';
        if guiHandlesStats.degsecStick.Value==1, 
            ax(2).YLabel.String='deg/s/stick travel units';
        end
        set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
        hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurvePitch_B(20) RateCurvePitch_B(40) RateCurvePitch_B(60) RateCurvePitch_B(80)],'ko','Parent', ax(2)); 
        set(h,'markerfacecolor','k')  

        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(6,:)]);
        axis([1 100 0 .1])

        text(21, RateCurvePitch_B(20),[int2str(RateCurvePitch_B(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(41, RateCurvePitch_B(40),[int2str(RateCurvePitch_B(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(61, RateCurvePitch_B(60),[int2str(RateCurvePitch_B(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(81, RateCurvePitch_B(80),[int2str(RateCurvePitch_B(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);   

        text(2, .095,['rates: ' num2str(rcRates(2))],'Parent', ax(1),'fontsize',fontsz5); 
        text(2, .085,['expo: ' num2str(rcExpo(2))],'Parent', ax(1),'fontsize',fontsz5);
        text(2, .075,['super: ' num2str(Srates(2))],'Parent', ax(1),'fontsize',fontsz5);
        axis([1 100 0 .1])
        grid on

        hhist=subplot('position',posInfo.statsPos(7,:));
        cla
        h=histogram(Ypercent_B,'Normalization','probability','BinWidth',1);
        set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)    
        y=xlabel('% yaw','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
        ylabel('% of flight','fontweight','bold')    

         hold on
        [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveYaw_B)-1],RateCurveYaw_B(1,2:end));
        set(ax(1),'Ycolor',[colorB])
        set(ax(2),'Xlim',[1 100],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
        ax(2).YLabel.String='deg/s';
        if guiHandlesStats.degsecStick.Value==1, 
            ax(2).YLabel.String='deg/s/stick travel units';
        end
        set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
        hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveYaw_B(20) RateCurveYaw_B(40) RateCurveYaw_B(60) RateCurveYaw_B(80)],'ko','Parent', ax(2)); 
        set(h,'markerfacecolor','k')  

        set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(7,:)]);  
        axis([1 100 0 .1])

        text(21, RateCurveYaw_B(20),[int2str(RateCurveYaw_B(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(41, RateCurveYaw_B(40),[int2str(RateCurveYaw_B(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(61, RateCurveYaw_B(60),[int2str(RateCurveYaw_B(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
        text(81, RateCurveYaw_B(80),[int2str(RateCurveYaw_B(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);     
        text(2, .095,['rates: ' num2str(rcRates(3))],'Parent', ax(1),'fontsize',fontsz5); 
        text(2, .085,['expo: ' num2str(rcExpo(3))],'Parent', ax(1),'fontsize',fontsz5);
        text(2, .075,['super: ' num2str(Srates(3))],'Parent', ax(1),'fontsize',fontsz5);
        axis([1 100 0 .1])
        grid on

        hhist=subplot('position',posInfo.statsPos(8,:));
        cla
        h=histogram(Tpercent_B,'Normalization','probability','BinWidth',1);    
        set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)
        grid on
        y=xlabel('% throttle','fontweight','bold');
        set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
        ylabel('% of flight', 'color',[colorB],'fontweight','bold')
        set(hhist,'ycolor',[colorB],'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 100],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(8,:)]);  
        axis([1 100 0 .1])
    end   
end

%% means/standard deviations
 
if guiHandlesStats.crossAxesStats.Value==2
       
    cols=[0.06 0.3 0.54 0.78];
    rows=[0.76 0.53 0.3 0.08];
    k=0;
    for c=1:length(cols)
        for r=1:length(rows)
            k=k+1;
            posInfo.statsPos2(k,:)=[cols(c) rows(r) 0.18 0.16];
        end
    end
    lineThickness=2;
 
    if ~isempty(filenameA)
        
        Rpercent_A=DATtmpA.RCcommand(1,:)/5;
        Ppercent_A=DATtmpA.RCcommand(2,:)/5;
        Ypercent_A=DATtmpA.RCcommand(3,:)/5;
        Tpercent_A=DATtmpA.RCRate(4,:);   
        
        N=length(DATtmpA.GyroFilt(1,:));
 
          % gyro
        h1=subplot('position',posInfo.statsPos2(1,:)); cla
        s1=errorbar([1],mean(abs(DATtmpA.GyroFilt(1,:))), std(abs(DATtmpA.GyroFilt(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpA.GyroFilt(1,:))));hold on
        set(s1,'FaceColor',[colorA]);%[ColorSet(11,:)])        
        s1=errorbar([2],mean(abs(DATtmpA.GyroFilt(2,:))), std(abs(DATtmpA.GyroFilt(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpA.GyroFilt(2,:))));
        set(s2,'FaceColor',[colorA]);%,[ColorSet(12,:)])        
        s1=errorbar([3],mean(abs(DATtmpA.GyroFilt(1,:))), std(abs(DATtmpA.GyroFilt(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)   
        s3=bar([3],mean(abs(DATtmpA.GyroFilt(1,:))));
        set(s3,'FaceColor',[colorA]);%,[ColorSet(13,:)])
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Gyro| [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ymax=ceil(max(mean(abs(DATtmpA.GyroFilt),2))+max((std(abs(DATtmpA.GyroFilt)')')));
        axis([.5 3.5 0 ymax])
        box off
        
        % RCRate
        h1=subplot('position',posInfo.statsPos2(5,:)); cla        
        s1=errorbar([1],mean(abs(Rpercent_A)), std(abs(Rpercent_A)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(Rpercent_A)));hold on
        set(s1,'FaceColor',[colorA]);%        
        s1=errorbar([2],mean(abs(Ppercent_A)), std(abs(Ppercent_A)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(Ppercent_A)));
        set(s2,'FaceColor',[colorA]);%
        s1=errorbar([3],mean(abs(Ypercent_A)), std(abs(Ypercent_A)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s3=bar([3],mean(abs(Ypercent_A)));
        set(s3,'FaceColor',[colorA]);%        
        s1=errorbar([4],mean(abs(Tpercent_A)), std(abs(Tpercent_A)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s4=bar([4],mean(Tpercent_A));
        set(s4,'FaceColor',[colorA]);%
        set(gca,'Xtick',[1 2 3 4],'xticklabel',{'R';'P';'Y';'T'},'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('% RPYT [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean % +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        axis([0.5 4.5 0 100])    
        box off
        
        % pterm
        h1=subplot('position',posInfo.statsPos2(2,:)); cla        
        s1=errorbar([1],mean(abs(DATtmpA.Pterm(1,:))), std(abs(DATtmpA.Pterm(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpA.Pterm(1,:))));hold on
        set(s1,'FaceColor',[colorA]);%        
        s1=errorbar([2],mean(abs(DATtmpA.Pterm(2,:))), std(abs(DATtmpA.Pterm(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpA.Pterm(2,:))));
        set(s2,'FaceColor',[colorA]);%        
        s1=errorbar([3],mean(abs(DATtmpA.Pterm(3,:))), std(abs(DATtmpA.Pterm(3,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)    
        s3=bar([3],mean(abs(DATtmpA.Pterm(3,:))));
        set(s3,'FaceColor',[colorA]);%
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Pterm| [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ymax=ceil(max(mean(abs(DATtmpA.Pterm),2))+max((std(abs(DATtmpA.Pterm)')')));
        axis([.5 3.5 0 ymax]) 
        box off
        
        % fterm
        h1=subplot('position',posInfo.statsPos2(6,:)); cla        
        s1=errorbar([1],mean(abs(DATtmpA.Fterm(1,:))), std(abs(DATtmpA.Fterm(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)   
        s1=bar([1],mean(abs(DATtmpA.Fterm(1,:))));hold on
        set(s1,'FaceColor',[colorA]);%
        s1=errorbar([2],mean(abs(DATtmpA.Fterm(2,:))), std(abs(DATtmpA.Fterm(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpA.Fterm(2,:))));
        set(s2,'FaceColor',[colorA]);%        %
        s1=errorbar([3],mean(abs(DATtmpA.Fterm(3,:))), std(abs(DATtmpA.Fterm(3,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)  
        s3=bar([3],mean(abs(DATtmpA.Fterm(3,:))));
        set(s3,'FaceColor',[colorA]);
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Fterm| [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ymax=ceil(max(mean(abs(DATtmpA.Fterm),2))+max((std(abs(DATtmpA.Fterm)')')));
        if ymax<1, ymax=10, end
        axis([.5 3.5 0 ymax])  
        box off
        
        % Iterm
        h1=subplot('position',posInfo.statsPos2(3,:)); cla        
        s1=errorbar([1],mean(abs(DATtmpA.Iterm(1,:))), std(abs(DATtmpA.Iterm(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpA.Iterm(1,:))));hold on
        set(s1,'FaceColor',[colorA]);%        
        s1=errorbar([2],mean(abs(DATtmpA.Iterm(2,:))), std(abs(DATtmpA.Iterm(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpA.Iterm(2,:))));
        set(s2,'FaceColor',[colorA]);%        
        s1=errorbar([3],mean(abs(DATtmpA.Iterm(3,:))), std(abs(DATtmpA.Iterm(3,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)  
        s3=bar([3],mean(abs(DATtmpA.Iterm(3,:))));
        set(s3,'FaceColor',[colorA]);%
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Iterm| [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ymax=ceil(max(mean(abs(DATtmpA.Iterm),2))+max((std(abs(DATtmpA.Iterm)')')));
        axis([.5 3.5 0 ymax])   
        box off
        
        % dterm
        h1=subplot('position',posInfo.statsPos2(7,:)); cla
        s1=errorbar([1],mean(abs(DATtmpA.DtermFilt(1,:))), std(abs(DATtmpA.DtermFilt(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpA.DtermFilt(1,:))));hold on
        set(s1,'FaceColor',[colorA]);% 
        s1=errorbar([2],mean(abs(DATtmpA.DtermFilt(2,:))), std(abs(DATtmpA.DtermFilt(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness) 
        s2=bar([2],mean(abs(DATtmpA.DtermFilt(2,:))));
        set(s2,'FaceColor',[colorA]);%
        set(gca,'Xtick',[1 2],'xticklabel',{'R';'P'},'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Dterm| [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ymax=ceil(max(mean(abs(DATtmpA.DtermFilt),2))+max((std(abs(DATtmpA.DtermFilt)')')));
        axis([.5 2.5 0 ymax])   
        box off
        
        h1=subplot('position',posInfo.statsPos2(4,:)); cla 
        s1=errorbar([1],mean(DATtmpA.Motor12(1,:)), std(DATtmpA.Motor12(1,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(DATtmpA.Motor12(1,:)));hold on
        set(s1,'FaceColor',[colorA]);
        s1=errorbar([2],mean(DATtmpA.Motor12(2,:)), std(DATtmpA.Motor12(2,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(DATtmpA.Motor12(2,:)));
        set(s2,'FaceColor',[colorA]);%  
        s1=errorbar([3],mean(DATtmpA.Motor34(1,:)), std(DATtmpA.Motor34(1,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s3=bar([3],mean(DATtmpA.Motor34(1,:)));
        set(s3,'FaceColor',[colorA]);%
        s1=errorbar([4],mean(DATtmpA.Motor34(2,:)), std(DATtmpA.Motor34(2,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s4=bar([4],mean(DATtmpA.Motor34(2,:)));
        set(s4,'FaceColor',[colorA]);%
        set(gca,'Xtick',[1 2 3 4],'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('Motors [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        axis([0.5 4.5 0 100]) 
        box off
        
        
         h1=subplot('position',posInfo.statsPos2(8,:)); cla  
        s1=errorbar([1],mean(abs(DATtmpA.debug12(1,:))), std(abs(DATtmpA.debug12(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpA.debug12(1,:))));hold on
        set(s1,'FaceColor',[colorA]);%
        s1=errorbar([2],mean(abs(DATtmpA.debug12(2,:))), std(abs(DATtmpA.debug12(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpA.debug12(2,:))));
        set(s2,'FaceColor',[colorA]);% 
        s1=errorbar([3],mean(abs(DATtmpA.debug34(1,:))), std(abs(DATtmpA.debug34(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s3=bar([3],mean(abs(DATtmpA.debug34(1,:))));
        set(s3,'FaceColor',[colorA]);%
        s1=errorbar([4],mean(abs(DATtmpA.debug34(2,:))), std(abs(DATtmpA.debug34(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)  
        s4=bar([4],mean(abs(DATtmpA.debug34(2,:))));
        set(s4,'FaceColor',[colorA]);%
        set(gca,'Xtick',[1 2 3 4],'xcolor',[colorA],'ycolor',[colorA],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Debug| [A]','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorA]);
        ymax=ceil(max([max(mean(abs(DATtmpA.debug12),2)) max(mean(abs(DATtmpA.debug34),2))]) + max([max((std(abs(DATtmpA.debug12)')')) max((std(abs(DATtmpA.debug34)')'))]));
        axis([.5 4.5 0 ymax])   
       box off
    end
 
 
    if ~isempty(filenameB)
 
        Rpercent_B=DATtmpB.RCcommand(1,:)/5;
        Ppercent_B=DATtmpB.RCcommand(2,:)/5;
        Ypercent_B=DATtmpB.RCcommand(3,:)/5;
        Tpercent_B=DATtmpB.RCRate(4,:);
        
        N=length(DATtmpB.GyroFilt(1,:));
        
        % gyro
        h1=subplot('position',posInfo.statsPos2(9,:)); cla
        s1=errorbar([1],mean(abs(DATtmpB.GyroFilt(1,:))), std(abs(DATtmpB.GyroFilt(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpB.GyroFilt(1,:))));hold on
        set(s1,'FaceColor',[colorB]);%[ColorSet(11,:)])        
        s1=errorbar([2],mean(abs(DATtmpB.GyroFilt(2,:))), std(abs(DATtmpB.GyroFilt(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpB.GyroFilt(2,:))));
        set(s2,'FaceColor',[colorB]);%,[ColorSet(12,:)])        
        s1=errorbar([3],mean(abs(DATtmpB.GyroFilt(1,:))), std(abs(DATtmpB.GyroFilt(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)   
        s3=bar([3],mean(abs(DATtmpB.GyroFilt(1,:))));
        set(s3,'FaceColor',[colorB]);%,[ColorSet(13,:)])
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Gyro| [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ymax=ceil(max(mean(abs(DATtmpB.GyroFilt),2))+max((std(abs(DATtmpB.GyroFilt)')')));
        axis([.5 3.5 0 ymax])
        box off
        
        % RCRate
        h1=subplot('position',posInfo.statsPos2(13,:)); cla        
        s1=errorbar([1],mean(abs(Rpercent_B)), std(abs(Rpercent_B)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(Rpercent_B)));hold on
        set(s1,'FaceColor',[colorB]);%        
        s1=errorbar([2],mean(abs(Ppercent_B)), std(abs(Ppercent_B)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(Ppercent_B)));
        set(s2,'FaceColor',[colorB]);%
        s1=errorbar([3],mean(abs(Ypercent_B)), std(abs(Ypercent_B)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s3=bar([3],mean(abs(Ypercent_B)));
        set(s3,'FaceColor',[colorB]);%        
        s1=errorbar([4],mean(abs(Tpercent_B)), std(abs(Tpercent_B)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s4=bar([4],mean(Tpercent_B));
        set(s4,'FaceColor',[colorB]);%
        set(gca,'Xtick',[1 2 3 4],'xticklabel',{'R';'P';'Y';'T'},'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('% RPYT [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean % +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        axis([0.5 4.5 0 100])    
        box off
        
        % pterm
        h1=subplot('position',posInfo.statsPos2(10,:)); cla        
        s1=errorbar([1],mean(abs(DATtmpB.Pterm(1,:))), std(abs(DATtmpB.Pterm(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpB.Pterm(1,:))));hold on
        set(s1,'FaceColor',[colorB]);%        
        s1=errorbar([2],mean(abs(DATtmpB.Pterm(2,:))), std(abs(DATtmpB.Pterm(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpB.Pterm(2,:))));
        set(s2,'FaceColor',[colorB]);%        
        s1=errorbar([3],mean(abs(DATtmpB.Pterm(3,:))), std(abs(DATtmpB.Pterm(3,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)    
        s3=bar([3],mean(abs(DATtmpB.Pterm(3,:))));
        set(s3,'FaceColor',[colorB]);%
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Pterm| [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ymax=ceil(max(mean(abs(DATtmpB.Pterm),2))+max((std(abs(DATtmpB.Pterm)')')));
        axis([.5 3.5 0 ymax]) 
        box off
        
        % fterm
        h1=subplot('position',posInfo.statsPos2(14,:)); cla        
        s1=errorbar([1],mean(abs(DATtmpB.Fterm(1,:))), std(abs(DATtmpB.Fterm(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)      
        s1=bar([1],mean(abs(DATtmpB.Fterm(1,:))));hold on
        set(s1,'FaceColor',[colorB]);%
        s1=errorbar([2],mean(abs(DATtmpB.Fterm(2,:))), std(abs(DATtmpB.Fterm(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpB.Fterm(2,:))));
        set(s2,'FaceColor',[colorB]);%        %
        s1=errorbar([3],mean(abs(DATtmpB.Fterm(3,:))), std(abs(DATtmpB.Fterm(3,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)  
        s3=bar([3],mean(abs(DATtmpB.Fterm(3,:))));
        set(s3,'FaceColor',[colorB]);
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Fterm| [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ymax=ceil(max(mean(abs(DATtmpB.Fterm),2))+max((std(abs(DATtmpB.Fterm)')')));
         if ymax<1, ymax=10, end
        axis([.5 3.5 0 ymax])  
        box off
        
        % Iterm
        h1=subplot('position',posInfo.statsPos2(11,:)); cla        
        s1=errorbar([1],mean(abs(DATtmpB.Iterm(1,:))), std(abs(DATtmpB.Iterm(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpB.Iterm(1,:))));hold on
        set(s1,'FaceColor',[colorB]);%        
        s1=errorbar([2],mean(abs(DATtmpB.Iterm(2,:))), std(abs(DATtmpB.Iterm(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpB.Iterm(2,:))));
        set(s2,'FaceColor',[colorB]);%        
        s1=errorbar([3],mean(abs(DATtmpB.Iterm(3,:))), std(abs(DATtmpB.Iterm(3,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)  
        s3=bar([3],mean(abs(DATtmpB.Iterm(3,:))));
        set(s3,'FaceColor',[colorB]);%
        set(gca,'Xtick',[1 2 3],'xticklabel',{'R';'P';'Y'},'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Iterm| [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ymax=ceil(max(mean(abs(DATtmpB.Iterm),2))+max((std(abs(DATtmpB.Iterm)')')));
        axis([.5 3.5 0 ymax])   
        box off
        
        % dterm
        h1=subplot('position',posInfo.statsPos2(15,:)); cla
        s1=errorbar([1],mean(abs(DATtmpB.DtermFilt(1,:))), std(abs(DATtmpB.DtermFilt(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpB.DtermFilt(1,:))));hold on
        set(s1,'FaceColor',[colorB]);% 
        s1=errorbar([2],mean(abs(DATtmpB.DtermFilt(2,:))), std(abs(DATtmpB.DtermFilt(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness) 
        s2=bar([2],mean(abs(DATtmpB.DtermFilt(2,:))));
        set(s2,'FaceColor',[colorB]);%
        set(gca,'Xtick',[1 2],'xticklabel',{'R';'P'},'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Dterm| [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ymax=ceil(max(mean(abs(DATtmpB.DtermFilt),2))+max((std(abs(DATtmpB.DtermFilt)')')));
        axis([.5 2.5 0 ymax])   
        box off
        
        h1=subplot('position',posInfo.statsPos2(12,:)); cla 
        s1=errorbar([1],mean(DATtmpB.Motor12(1,:)), std(DATtmpB.Motor12(1,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(DATtmpB.Motor12(1,:)));hold on
        set(s1,'FaceColor',[colorB]);
        s1=errorbar([2],mean(DATtmpB.Motor12(2,:)), std(DATtmpB.Motor12(2,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(DATtmpB.Motor12(2,:)));
        set(s2,'FaceColor',[colorB]);%  
        s1=errorbar([3],mean(DATtmpB.Motor34(1,:)), std(DATtmpB.Motor34(1,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s3=bar([3],mean(DATtmpB.Motor34(1,:)));
        set(s3,'FaceColor',[colorB]);%
        s1=errorbar([4],mean(DATtmpB.Motor34(2,:)), std(DATtmpB.Motor34(2,:)));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s4=bar([4],mean(DATtmpB.Motor34(2,:)));
        set(s4,'FaceColor',[colorB]);%
        set(gca,'Xtick',[1 2 3 4],'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('Motors [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        axis([0.5 4.5 0 100]) 
        box off
        
        
         h1=subplot('position',posInfo.statsPos2(16,:)); cla  
        s1=errorbar([1],mean(abs(DATtmpB.debug12(1,:))), std(abs(DATtmpB.debug12(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s1=bar([1],mean(abs(DATtmpB.debug12(1,:))));hold on
        set(s1,'FaceColor',[colorB]);%
        s1=errorbar([2],mean(abs(DATtmpB.debug12(2,:))), std(abs(DATtmpB.debug12(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s2=bar([2],mean(abs(DATtmpB.debug12(2,:))));
        set(s2,'FaceColor',[colorB]);% 
        s1=errorbar([3],mean(abs(DATtmpB.debug34(1,:))), std(abs(DATtmpB.debug34(1,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)
        s3=bar([3],mean(abs(DATtmpB.debug34(1,:))));
        set(s3,'FaceColor',[colorB]);%
        s1=errorbar([4],mean(abs(DATtmpB.debug34(2,:))), std(abs(DATtmpB.debug34(2,:))));hold on
        set(s1,'color','k','linewidth',lineThickness)  
        s4=bar([4],mean(abs(DATtmpB.debug34(2,:))));
        set(s4,'FaceColor',[colorB]);%
        set(gca,'Xtick',[1 2 3 4],'xcolor',[colorB],'ycolor',[colorB],'YMinorGrid','on')
        set(h1,'fontsize',fontsz5);
        xlabel('|Debug| [B]','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ylabel('Mean +SD ','fontsize',fontsz5,'fontweight','bold','color',[colorB]);
        ymax=ceil(max([max(mean(abs(DATtmpB.debug12),2)) max(mean(abs(DATtmpB.debug34),2))]) + max([max((std(abs(DATtmpB.debug12)')')) max((std(abs(DATtmpB.debug34)')'))]));
        axis([.5 4.5 0 ymax])   
       box off
    end
end


%% Mode 1 topography
if guiHandlesStats.crossAxesStats.Value==3
       
    cols=[0.06 0.52];
    rows=[0.55 0.08];
    k=0;
    for c=1:2
        for r=1:2
            k=k+1;
            posInfo.statsPos2(k,:)=[cols(c) rows(r) 0.38 0.4];
        end
    end


    lineThickness=2;

    if ~isempty(filenameA)
        
        Rpercent_A=DATtmpA.RCcommand(1,:)/5;
        Ppercent_A=DATtmpA.RCcommand(2,:)/5;
        Ypercent_A=DATtmpA.RCcommand(3,:)/5;
        Tpercent_A=DATtmpA.RCRate(4,:);
        Tacceleration_A=[0 (smooth( diff((Tpercent_A)*10)*A_lograte, 50))'];   
        col=Tacceleration_A;        
       
        cmap_crossaxisStat=b2r(-1, 1);

        h1=subplot('position',posInfo.statsPos2(1,:)); cla
        s1=surface([Ypercent_A;Ypercent_A],[Ppercent_A;Ppercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[-100:20:100])
        set(h1,'fontsize',fontsz5);
        xlabel('% Yaw [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Pitch [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 -100 100])
        set(s1, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[-100 100],':k');
        plot([-100 100],[0 0],':k');

        h2=subplot('position',posInfo.statsPos2(2,:)); cla
        s2=surface([Rpercent_A;Rpercent_A],[Tpercent_A;Tpercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h2,'fontsize',fontsz5);
        xlabel('% Roll [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s2, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k');
    end


    if ~isempty(filenameB)

        Rpercent_B=DATtmpB.RCcommand(1,:)/5;
        Ppercent_B=DATtmpB.RCcommand(2,:)/5;
        Ypercent_B=DATtmpB.RCcommand(3,:)/5;
        Tpercent_B=DATtmpB.RCRate(4,:);
        Tacceleration_B=[0 (smooth( diff((Tpercent_B)*10)*B_lograte, 50))'];
        col=Tacceleration_B; 

        h3=subplot('position',posInfo.statsPos2(3,:)); cla
        s3=surface([Ypercent_B;Ypercent_B],[Ppercent_B;Ppercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[-100:20:100])
        set(h3,'fontsize',fontsz5);
        xlabel('% Yaw [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Pitch [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 -100 100])
        set(s3, 'EdgeAlpha',zTransparency);   
        hold on; plot([0 0],[-100 100],':k');
        plot([-100 100],[0 0],':k');

        h4=subplot('position',posInfo.statsPos2(4,:)); cla
        s4=surface([Rpercent_B;Rpercent_B],[Tpercent_B;Tpercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h4,'fontsize',fontsz5);
        xlabel('% Roll [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s4, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k');
    end

end

%% Mode 2 topography
if guiHandlesStats.crossAxesStats.Value==4
       
    cols=[0.06 0.52];
    rows=[0.55 0.08];
    k=0;
    for c=1:2
        for r=1:2
            k=k+1;
            posInfo.statsPos2(k,:)=[cols(c) rows(r) 0.38 0.4];
        end
    end


    lineThickness=2;

    if ~isempty(filenameA)
        
        Rpercent_A=DATtmpA.RCcommand(1,:)/5;
        Ppercent_A=DATtmpA.RCcommand(2,:)/5;
        Ypercent_A=DATtmpA.RCcommand(3,:)/5;
        Tpercent_A=DATtmpA.RCRate(4,:);
        Tacceleration_A=[0 (smooth( diff((Tpercent_A)*10)*A_lograte, 50))'];   
        col=Tacceleration_A;        
       
        cmap_crossaxisStat=b2r(-1, 1);

        h1=subplot('position',posInfo.statsPos2(1,:)); cla
        s1=surface([Ypercent_A;Ypercent_A],[Tpercent_A;Tpercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h1,'fontsize',fontsz5);
        xlabel('% Yaw [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s1, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k');

        h2=subplot('position',posInfo.statsPos2(2,:)); cla
        s2=surface([Rpercent_A;Rpercent_A],[Ppercent_A;Ppercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[-100:20:100])
        set(h2,'fontsize',fontsz5);
        xlabel('% Roll [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Pitch [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 -100 100])
        set(s2, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[-100 100],':k');
        plot([-100 100],[0 0],':k');
    end


    if ~isempty(filenameB)

        Rpercent_B=DATtmpB.RCcommand(1,:)/5;
        Ppercent_B=DATtmpB.RCcommand(2,:)/5;
        Ypercent_B=DATtmpB.RCcommand(3,:)/5;
        Tpercent_B=DATtmpB.RCRate(4,:);
        Tacceleration_B=[0 (smooth( diff((Tpercent_B)*10)*B_lograte, 50))'];
        col=Tacceleration_B; 

        h3=subplot('position',posInfo.statsPos2(3,:)); cla
        s3=surface([Ypercent_B;Ypercent_B],[Tpercent_B;Tpercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h3,'fontsize',fontsz5);
        xlabel('% Yaw [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s3, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k');       

        h4=subplot('position',posInfo.statsPos2(4,:)); cla
        s4=surface([Rpercent_B;Rpercent_B],[Ppercent_B;Ppercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[-100:20:100])
        set(h4,'fontsize',fontsz5);
        xlabel('% Roll [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Pitch [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 -100 100])
        set(s4, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[-100 100],':k');
        plot([-100 100],[0 0],':k');
    end

end
%% each against throttle

if guiHandlesStats.crossAxesStats.Value==5
       
    cols=[0.06 0.54];
    rows=[0.69 0.385 0.08];
    k=0;
    for c=1:2
        for r=1:3
            k=k+1;
            posInfo.statsPos2(k,:)=[cols(c) rows(r) 0.39 0.24];
        end
    end


    lineThickness=2;

    if ~isempty(filenameA)
        
        Rpercent_A=DATtmpA.RCcommand(1,:)/5;
        Ppercent_A=DATtmpA.RCcommand(2,:)/5;
        Ypercent_A=DATtmpA.RCcommand(3,:)/5;
        Tpercent_A=DATtmpA.RCRate(4,:);
        Tacceleration_A=[0 (smooth( diff((Tpercent_A)*10)*A_lograte, 50))'];   
        col=Tacceleration_A;        
       
        cmap_crossaxisStat=b2r(-1, 1);

        h1=subplot('position',posInfo.statsPos2(1,:)); cla
        s1=surface([Rpercent_A;Rpercent_A],[Tpercent_A;Tpercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h1,'fontsize',fontsz5);
        xlabel('% Roll [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s1, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k');        

        h2=subplot('position',posInfo.statsPos2(2,:)); cla
        s2=surface([Ppercent_A;Ppercent_A],[Tpercent_A;Tpercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h2,'fontsize',fontsz5);
        xlabel('% Pitch [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s2, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k'); 

        h3=subplot('position',posInfo.statsPos2(3,:)); cla
        s3=surface([Ypercent_A;Ypercent_A],[Tpercent_A;Tpercent_A],[Tacceleration_A;Tacceleration_A],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h3,'fontsize',fontsz5);
        xlabel('% Yaw [A]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [A]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s3, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k'); 
    end


    if ~isempty(filenameB)

        Rpercent_B=DATtmpB.RCcommand(1,:)/5;
        Ppercent_B=DATtmpB.RCcommand(2,:)/5;
        Ypercent_B=DATtmpB.RCcommand(3,:)/5;
        Tpercent_B=DATtmpB.RCRate(4,:);
        Tacceleration_B=[0 (smooth( diff((Tpercent_B)*10)*B_lograte, 50))'];
        col=Tacceleration_B; 

        h4=subplot('position',posInfo.statsPos2(4,:)); cla
        s4=surface([Rpercent_B;Rpercent_B],[Tpercent_B;Tpercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h4,'fontsize',fontsz5);
        xlabel('% Roll [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s4, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k'); 

        h5=subplot('position',posInfo.statsPos2(5,:)); cla
        s5=surface([Ppercent_B;Ppercent_B],[Tpercent_B;Tpercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h5,'fontsize',fontsz5);
        xlabel('% Pitch [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])
        set(s5, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k'); 

        h6=subplot('position',posInfo.statsPos2(6,:)); cla
        s6=surface([Ypercent_B;Ypercent_B],[Tpercent_B;Tpercent_B],[Tacceleration_B;Tacceleration_B],[col;col],'facecol','no','edgecol','interp','linew',lineThickness);
        colormap(cmap_crossaxisStat);
        set(gca,'CLim',[-zScale zScale],'xtick',[-100:20:100],'ytick',[0:20:100])
        set(h6,'fontsize',fontsz5);
        xlabel('% Yaw [B]','fontsize',fontsz5,'fontweight','bold');
        ylabel('% Throttle [B]','fontsize',fontsz5,'fontweight','bold');
        axis([-100 100 0 100])  
        set(s6, 'EdgeAlpha',zTransparency);
        hold on; plot([0 0],[0 100],':k');
        plot([-100 100],[50 50],':k'); 
    end
end




updateStats=0;
set(PTstatsfig, 'pointer', 'arrow')
end


function newmap = b2r(cmin_input,cmax_input)
%BLUEWHITERED   Blue, white, and red color map.
%   this matlab file is designed to draw anomaly figures. the color of
%   the colorbar is from blue to white and then to red, corresponding to 
%   the anomaly values from negative to zero to positive, respectively. 
%   The color white always correspondes to value zero. 
%   
%   You should input two values like caxis in matlab, that is the min and
%   the max value of color values designed.  e.g. colormap(b2r(-3,5))
%   
%   the brightness of blue and red will change according to your setting,
%   so that the brightness of the color corresponded to the color of his
%   opposite number
%   e.g. colormap(b2r(-3,6))   is from light blue to deep red
%   e.g. colormap(b2r(-3,3))   is from deep blue to deep red
%
%   I'd advise you to use colorbar first to make sure the caxis' cmax and cmin.
%   Besides, there is also another similar colorbar named 'darkb2r', in which the 
%   color is darker.
%
%   by Cunjie Zhang, 2011-3-14
%   find bugs ====> email : daisy19880411@126.com
%   updated:  Robert Beckman help to fix the bug when start point is zero, 2015-04-08
%   
%   Examples:
%   ------------------------------
%   figure
%   peaks;
%   colormap(b2r(-6,8)), colorbar, title('b2r')
%   


%% check the input
if nargin ~= 2 ;
   disp('input error');
   disp('input two variables, the range of caxis , for example : colormap(b2r(-3,3))');
end

if cmin_input >= cmax_input
    disp('input error');
    disp('the color range must be from a smaller one to a larger one');
end

%% control the figure caxis 
lims = get(gca, 'CLim');   % get figure caxis formation
caxis([cmin_input cmax_input]);

%% color configuration : from blue to to white then to red

red_top     = [1 0 0];
white_middle= [1 1 1];
blue_bottom = [0 0 1];

%% color interpolation 

color_num = 251;   
color_input = [blue_bottom;  white_middle;  red_top];
oldsteps = linspace(-1, 1, size(color_input,1));
newsteps = linspace(-1, 1, color_num);  

%% Category Discussion according to the cmin and cmax input

%  the color data will be remaped to color range from -max(abs(cmin_input),cmax_input)
%  to max(abs(cmin_input),cmax_input) , and then squeeze the color data
%  in order to make sure the blue and red color selected corresponded
%  to their math values

%  for example :
%  if b2r(-3,6) ,the color range is from light blue to deep red , so that
%  the light blue valued at -3 correspondes to light red valued at 3


%% Category Discussion according to the cmin and cmax input
% first : from negative to positive
% then  : from positive to positive
% last  : from negative to negative

for j=1:3
   newmap_all(:,j) = min(max(transpose(interp1(oldsteps, color_input(:,j), newsteps)), 0), 1);
end

if (cmin_input < 0)  &&  (cmax_input > 0) ;  
    
    
    if abs(cmin_input) < cmax_input 
         
        % |--------|---------|--------------------|    
      % -cmax      cmin       0                  cmax         [cmin,cmax]
 
       start_point = max(round((cmin_input+cmax_input)/2/cmax_input*color_num),1);
       newmap = squeeze(newmap_all(start_point:color_num,:));
       
    elseif abs(cmin_input) >= cmax_input
        
         % |------------------|------|--------------|    
       %  cmin                0     cmax          -cmin         [cmin,cmax]   
       
       end_point = max(round((cmax_input-cmin_input)/2/abs(cmin_input)*color_num),1);
       newmap = squeeze(newmap_all(1:end_point,:));
    end
    
       
elseif cmin_input >= 0

       if lims(1) < 0 
           disp('caution:')
           disp('there are still values smaller than 0, but cmin is larger than 0.')
           disp('some area will be in red color while it should be in blue color')
       end
       
        % |-----------------|-------|-------------|    
      % -cmax               0      cmin          cmax         [cmin,cmax]
 
       start_point = max(round((cmin_input+cmax_input)/2/cmax_input*color_num),1);
       newmap = squeeze(newmap_all(start_point:color_num,:));

elseif cmax_input <= 0

       if lims(2) > 0 
           disp('caution:')
           disp('there are still values larger than 0, but cmax is smaller than 0.')
           disp('some area will be in blue color while it should be in red color')
       end
       
         % |------------|------|--------------------|    
       %  cmin         cmax    0                  -cmin         [cmin,cmax]      

       end_point = max(round((cmax_input-cmin_input)/2/abs(cmin_input)*color_num),1);
       newmap = squeeze(newmap_all(1:end_point,:));
end
    


end


