%% PTplotStats - script to plot flight statistics

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
    
if ~isempty(filenameA) || ~isempty(filenameB)
    %% update fonts

prop_max_screen=(max([PTstatsfig.Position(3) PTstatsfig.Position(4)]));
fontsz5=round(screensz_multiplier*prop_max_screen);

guiHandlesStats.saveFig5.FontSize=fontsz5; 
guiHandlesStats.refresh.FontSize=fontsz5; 
guiHandlesStats.degsecStick.FontSize=fontsz5; 

%% Histograms   

if ~isempty(filenameA)
    rcRates=str2num(rc_rates_A{2});
    rcExpo=str2num(rc_expo_A{2});
    Srates=str2num(Super_rates_A{2});
    
    RateCurveRoll_A=PTrc2deg([1:5:500],dataA.rates(1,1), dataA.rates(2,1), dataA.rates(3,1));
    RateCurvePitch_A=PTrc2deg([1:5:500],dataA.rates(1,2), dataA.rates(2,2), dataA.rates(3,2));
    RateCurveYaw_A=PTrc2deg([1:5:500],dataA.rates(1,3), dataA.rates(2,3), dataA.rates(3,3));
    
    Yscale=round((max([max(RateCurveRoll_A) max(RateCurvePitch_A) max(RateCurveYaw_A)])) / 100) * 100;
    
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

    hhist=subplot('position',posInfo.statsPos(1,:));
    cla   
    h=histogram(Rpercent_A,'Normalization','probability','BinWidth',1);      
    y=xlabel('% roll','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);                 
    ylabel('% of flight','fontweight','bold')    
    set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)  
    
    hold on
    
    [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveRoll_A)],RateCurveRoll_A);
    set(ax(1),'Ycolor',[colorA])
    set(ax(2),'Xlim',[1 99],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
    ax(2).YLabel.String='deg/s';
    if guiHandlesStats.degsecStick.Value==1, 
        ax(2).YLabel.String='deg/s/stick travel units';
    end
    set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
    hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveRoll_A(20) RateCurveRoll_A(40) RateCurveRoll_A(60) RateCurveRoll_A(80)],'ko','Parent', ax(2)); 
    set(h,'markerfacecolor','k') 
    
    set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(1,:)]);
    axis([1 99 0 .1])
    
    text(21, RateCurveRoll_A(20),[int2str(RateCurveRoll_A(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);  
    text(41, RateCurveRoll_A(40),[int2str(RateCurveRoll_A(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(61, RateCurveRoll_A(60),[int2str(RateCurveRoll_A(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(81, RateCurveRoll_A(80),[int2str(RateCurveRoll_A(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(2, .095,['rates: ' num2str(rcRates(1))],'Parent', ax(1),'fontsize',fontsz5); 
    text(2, .085,['super: ' num2str(Srates(1))],'Parent', ax(1),'fontsize',fontsz5);
    text(2, .075,['expo: ' num2str(rcExpo(1))],'Parent', ax(1),'fontsize',fontsz5);
    axis([1 99 0 .1])
    grid on

    hhist=subplot('position',posInfo.statsPos(2,:));
    cla
    h=histogram(Ppercent_A,'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)    
    y=xlabel('% pitch','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
    ylabel('% of flight','fontweight','bold')  
     hold on    
    [ax,h1,h2]=plotyy(0,0,[1:length(RateCurvePitch_A)],RateCurvePitch_A);
    set(ax(1),'Ycolor',[colorA])
    set(ax(2),'Xlim',[1 99],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
    ax(2).YLabel.String='deg/s';
    if guiHandlesStats.degsecStick.Value==1, 
        ax(2).YLabel.String='deg/s/stick travel units';
    end
    set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
    hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurvePitch_A(20) RateCurvePitch_A(40) RateCurvePitch_A(60) RateCurvePitch_A(80)],'ko','Parent', ax(2));     
    set(h,'markerfacecolor','k')  
    
    set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(2,:)]);
    axis([1 99 0 .1])
    
    text(21, RateCurvePitch_A(20),[int2str(RateCurvePitch_A(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(41, RateCurvePitch_A(40),[int2str(RateCurvePitch_A(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(61, RateCurvePitch_A(60),[int2str(RateCurvePitch_A(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(81, RateCurvePitch_A(80),[int2str(RateCurvePitch_A(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);  
    text(2, .095,['rates: ' num2str(rcRates(2))],'Parent', ax(1),'fontsize',fontsz5); 
    text(2, .085,['super: ' num2str(Srates(2))],'Parent', ax(1),'fontsize',fontsz5);
    text(2, .075,['expo: ' num2str(rcExpo(2))],'Parent', ax(1),'fontsize',fontsz5);
    axis([1 99 0 .1])
    grid on
    
    hhist=subplot('position',posInfo.statsPos(3,:));
    cla
    h=histogram(Ypercent_A,'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7)    
    y=xlabel('% yaw','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
    ylabel('% of flight','fontweight','bold')
    
     hold on
    [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveYaw_A)],RateCurveYaw_A);
    set(ax(1),'Ycolor',[colorA])
    set(ax(2),'Xlim',[1 99],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
    ax(2).YLabel.String='deg/s';
    if guiHandlesStats.degsecStick.Value==1, 
        ax(2).YLabel.String='deg/s/stick travel units';
    end
    set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
    hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveYaw_A(20) RateCurveYaw_A(40) RateCurveYaw_A(60) RateCurveYaw_A(80)],'ko','Parent', ax(2)); 
    set(h,'markerfacecolor','k')  
    
    set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(3,:)]);  
    axis([1 99 0 .1])
    
    text(21, RateCurveYaw_A(20),[int2str(RateCurveYaw_A(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(41, RateCurveYaw_A(40),[int2str(RateCurveYaw_A(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(61, RateCurveYaw_A(60),[int2str(RateCurveYaw_A(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(81, RateCurveYaw_A(80),[int2str(RateCurveYaw_A(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);  
    text(2, .095,['rates: ' num2str(rcRates(3))],'Parent', ax(1),'fontsize',fontsz5); 
    text(2, .085,['super: ' num2str(Srates(3))],'Parent', ax(1),'fontsize',fontsz5);
    text(2, .075,['expo: ' num2str(rcExpo(3))],'Parent', ax(1),'fontsize',fontsz5);
    axis([1 99 0 .1])
    grid on
    
     hhist=subplot('position',posInfo.statsPos(4,:));
    cla
    h=histogram(Tpercent_A,'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorA],'FaceAlpha',.9, 'edgecolor',[colorA],'EdgeAlpha',.7);
    grid on
    y=xlabel('% throttle','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
    ylabel('% of flight', 'color',[colorA],'fontweight','bold')
    set(hhist,'ycolor',[colorA],'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(4,:)]);  
    axis([1 99 0 .1])
end



if ~isempty(filenameB)
    rcRates=str2num(rc_rates_B{2});
    rcExpo=str2num(rc_expo_B{2});
    Srates=str2num(Super_rates_B{2});
    
    RateCurveRoll_B=PTrc2deg([1:5:500],dataB.rates(1,1), dataB.rates(2,1), dataB.rates(3,1));
    RateCurvePitch_B=PTrc2deg([1:5:500],dataB.rates(1,2), dataB.rates(2,2), dataB.rates(3,2));
    RateCurveYaw_B=PTrc2deg([1:5:500],dataB.rates(1,3), dataB.rates(2,3), dataB.rates(3,3));
    
    Yscale=round((max([max(RateCurveRoll_B) max(RateCurvePitch_B) max(RateCurveYaw_B)])) / 100) * 100;
    
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

    hhist=subplot('position',posInfo.statsPos(5,:));
    cla   
    h=histogram(Rpercent_B,'Normalization','probability','BinWidth',1);      
    y=xlabel('% roll','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);                 
    ylabel('% of flight','fontweight','bold')    
    set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)  
    
    hold on
    
    [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveRoll_B)],RateCurveRoll_B);
    set(ax(1),'Ycolor',[colorB])
    set(ax(2),'Xlim',[1 99],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
    ax(2).YLabel.String='deg/s';
    if guiHandlesStats.degsecStick.Value==1, 
        ax(2).YLabel.String='deg/s/stick travel units';
    end
    set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
    hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveRoll_B(20) RateCurveRoll_B(40) RateCurveRoll_B(60) RateCurveRoll_B(80)],'ko','Parent', ax(2)); 
    set(h,'markerfacecolor','k')  
    
    set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(5,:)]);
    axis([1 99 0 .1])
    
    text(21, RateCurveRoll_B(20),[int2str(RateCurveRoll_B(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(41, RateCurveRoll_B(40),[int2str(RateCurveRoll_B(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(61, RateCurveRoll_B(60),[int2str(RateCurveRoll_B(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(81, RateCurveRoll_B(80),[int2str(RateCurveRoll_B(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);   
    text(2, .095,['rates: ' num2str(rcRates(1))],'Parent', ax(1),'fontsize',fontsz5); 
    text(2, .085,['super: ' num2str(Srates(1))],'Parent', ax(1),'fontsize',fontsz5);
    text(2, .075,['expo: ' num2str(rcExpo(1))],'Parent', ax(1),'fontsize',fontsz5);
    axis([1 99 0 .1])
    grid on

    hhist=subplot('position',posInfo.statsPos(6,:));
    cla
    h=histogram(Ppercent_B,'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)    
    y=xlabel('% pitch','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
    ylabel('% of flight','fontweight','bold');
    
     hold on    
    [ax,h1,h2]=plotyy(0,0,[1:length(RateCurvePitch_B)],RateCurvePitch_B);
    set(ax(1),'Ycolor',[colorB])
    set(ax(2),'Xlim',[1 99],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
    ax(2).YLabel.String='deg/s';
    if guiHandlesStats.degsecStick.Value==1, 
        ax(2).YLabel.String='deg/s/stick travel units';
    end
    set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
    hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurvePitch_B(20) RateCurvePitch_B(40) RateCurvePitch_B(60) RateCurvePitch_B(80)],'ko','Parent', ax(2)); 
    set(h,'markerfacecolor','k')  
    
    set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(6,:)]);
    axis([1 99 0 .1])
    
    text(21, RateCurvePitch_B(20),[int2str(RateCurvePitch_B(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(41, RateCurvePitch_B(40),[int2str(RateCurvePitch_B(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(61, RateCurvePitch_B(60),[int2str(RateCurvePitch_B(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(81, RateCurvePitch_B(80),[int2str(RateCurvePitch_B(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);   
    
    text(2, .095,['rates: ' num2str(rcRates(2))],'Parent', ax(1),'fontsize',fontsz5); 
    text(2, .085,['super: ' num2str(Srates(2))],'Parent', ax(1),'fontsize',fontsz5);
    text(2, .075,['expo: ' num2str(rcExpo(2))],'Parent', ax(1),'fontsize',fontsz5);
    axis([1 99 0 .1])
    grid on
    
    hhist=subplot('position',posInfo.statsPos(7,:));
    cla
    h=histogram(Ypercent_B,'Normalization','probability','BinWidth',1);
    set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)    
    y=xlabel('% yaw','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
    ylabel('% of flight','fontweight','bold')    
    
     hold on
    [ax,h1,h2]=plotyy(0,0,[1:length(RateCurveYaw_B)],RateCurveYaw_B);
    set(ax(1),'Ycolor',[colorB])
    set(ax(2),'Xlim',[1 99],'YLim',[0 Yscale] ,'ytick',[0 round(Yscale/2) Yscale], 'Ycolor','k','fontsize',fontsz5)
    ax(2).YLabel.String='deg/s';
    if guiHandlesStats.degsecStick.Value==1, 
        ax(2).YLabel.String='deg/s/stick travel units';
    end
    set(h2,'color',[.5 .5 .5],'LineWidth',1.5)
    hold(ax(2),'on'); h=plot([20 40 60 80],[RateCurveYaw_B(20) RateCurveYaw_B(40) RateCurveYaw_B(60) RateCurveYaw_B(80)],'ko','Parent', ax(2)); 
    set(h,'markerfacecolor','k')  
    
    set(hhist,'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(7,:)]);  
    axis([1 99 0 .1])
    
    text(21, RateCurveYaw_B(20),[int2str(RateCurveYaw_B(20)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(41, RateCurveYaw_B(40),[int2str(RateCurveYaw_B(40)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(61, RateCurveYaw_B(60),[int2str(RateCurveYaw_B(60)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);    
    text(81, RateCurveYaw_B(80),[int2str(RateCurveYaw_B(80)) 'deg/s'],'Parent', ax(2),'fontsize',fontsz5);     
    text(2, .095,['rates: ' num2str(rcRates(3))],'Parent', ax(1),'fontsize',fontsz5); 
    text(2, .085,['super: ' num2str(Srates(3))],'Parent', ax(1),'fontsize',fontsz5);
    text(2, .075,['expo: ' num2str(rcExpo(3))],'Parent', ax(1),'fontsize',fontsz5);
    axis([1 99 0 .1])
    grid on
    
    hhist=subplot('position',posInfo.statsPos(8,:));
    cla
    h=histogram(Tpercent_B,'Normalization','probability','BinWidth',1);    
    set(h,'FaceColor',[colorB],'FaceAlpha',.9, 'edgecolor',[colorB],'EdgeAlpha',.7)
    grid on
    y=xlabel('% throttle','fontweight','bold');
    set(y,'Units','normalized', 'position', [.5 -.1 1],'color',[.2 .2 .2]);
    ylabel('% of flight', 'color',[colorB],'fontweight','bold')
    set(hhist,'ycolor',[colorB],'tickdir','in','xlim',[1 100],'xtick',[1 20 40 60 80 99],'ylim',[0 .1],'ytick',[0 .05 .1],'xticklabels',{0 20 40 60 80 100},'yticklabels',{0 5 10},'fontsize',fontsz5, 'Position',[posInfo.statsPos(8,:)]);  
    axis([1 99 0 .1])
end

end


