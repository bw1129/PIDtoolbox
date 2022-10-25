%% PTsliderActions - script called when slider1 called

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

 
try 
     a1 = axis(LVpanel4); a = [a1(1) a1(2)]; 
 catch 
     a = [0 tta{guiHandles.FileNum.Value}(end) / us2sec]; 
 end 
 adiff = a(2)-a(1); 
        
 x1 = a(1) + (guiHandles.slider.Value*adiff) ; 
 try 
     delete(hslider1); 
     delete(hslider2); 
     delete(hslider3); 
     delete(hslider5);
 catch 
 end 
 try 
     delete(hslider4);,
 catch 
 end
 
if ~guiHandles.RPYcomboLV.Value
        if guiHandles.plotR.Value, 
            LVpanel1=subplot('position',posInfo.linepos1); 
            hslider1=plot([x1 x1],[-(maxY) maxY],'-k','linewidth',guiHandles.linewidth.Value/2);  
        end
        if guiHandles.plotP.Value, LVpanel2=subplot('position',posInfo.linepos2); 
            hslider2=plot([x1 x1],[-(maxY) maxY],'-k','linewidth',guiHandles.linewidth.Value/2);
        end
        if guiHandles.plotY.Value
            LVpanel3=subplot('position',posInfo.linepos3);
            hslider3=plot([x1 x1],[-(maxY) maxY],'-k','linewidth',guiHandles.linewidth.Value/2);
        end
        if guiHandles.plotR.Value || guiHandles.plotP.Value || guiHandles.plotY.Value 
            LVpanel5=subplot('position',posInfo.linepos4);
            hslider5=plot([x1 x1],[0 100],'-k','linewidth',guiHandles.linewidth.Value/2); 
            axis([0 xmax 0 100]), 
            grid on
        end     
else
    LVpanel4=subplot('position' ,[fullszPlot]); 
    hslider4=plot([x1 x1],[-(maxY) maxY],'-k','linewidth',guiHandles.linewidth.Value/2); 
    LVpanel5=subplot('position',posInfo.linepos4); 
    hslider5=plot([x1 x1],[0 100],'-k','linewidth',guiHandles.linewidth.Value/2); 
    axis([0 xmax 0 100])
    grid on 
end

h=subplot('position',[posInfo.YTstick]); 
x2=find(tta{guiHandles.FileNum.Value}/us2sec>=x1,1);
plot(-T{guiHandles.FileNum.Value}.rcCommand_2_(x2) , (T{guiHandles.FileNum.Value}.rcCommand_3_(x2) - 1000)/10,'ko');
set(h, 'xlim', [-500 500], 'ylim', [0 100], 'xticklabel',['Y'], 'yticklabel',['T'],'xtick',[0], 'ytick',[50], 'xgrid', 'on', 'ygrid', 'on', 'fontweight','bold','FontSize', fontsz);
h=subplot('position',[posInfo.RPstick]); 
plot(T{guiHandles.FileNum.Value}.rcCommand_0_(x2) , T{guiHandles.FileNum.Value}.rcCommand_1_(x2),'ko');
set(h, 'xlim', [-500 500], 'ylim', [-500 500], 'xticklabel',['R'], 'yticklabel',['P'],'xtick',[0], 'ytick',[0], 'xgrid', 'on', 'ygrid', 'on', 'fontweight','bold','FontSize', fontsz);
subplot('position',[posInfo.YTstick]); h=text(0,110, ['time: ' num2str(tta{(guiHandles.FileNum.Value)}(x2) / us2sec) ' sec']); set(h,'FontSize', fontsz);
h=text(-450,-60, ['M3:   ' int2str(T{guiHandles.FileNum.Value}.motor_2_(x2)) '%']); set(h,'FontSize', fontsz, 'color', [ColorSet(13,:)]);
h=text(-450,-40, ['M4:   ' int2str(T{guiHandles.FileNum.Value}.motor_3_(x2))  '%']); set(h,'FontSize', fontsz, 'color', [ColorSet(14,:)]);
subplot('position',[posInfo.RPstick]);
h=text(-450,-1100, ['M1:   ' int2str(T{guiHandles.FileNum.Value}.motor_0_(x2)) '%']); set(h,'FontSize', fontsz, 'color', [ColorSet(11,:)]);
h=text(-450,-900, ['M2:   ' int2str(T{guiHandles.FileNum.Value}.motor_1_(x2)) '%']); set(h,'FontSize', fontsz, 'color', [ColorSet(12,:)]);
subplot('position',[posInfo.YTstick]);
h=text(-450,-80, ['gyro R:   ' int2str(T{guiHandles.FileNum.Value}.gyroADC_0_(x2)) ' deg/s']); set(h,'FontSize', fontsz, 'color', [ColorSet(2,:)]);
h=text(-450,-100, ['gyro P:   ' int2str(T{guiHandles.FileNum.Value}.gyroADC_1_(x2)) ' deg/s']); set(h,'FontSize', fontsz, 'color', [ColorSet(2,:)]);
h=text(-450,-120, ['gyro Y:   ' int2str(T{guiHandles.FileNum.Value}.gyroADC_2_(x2)) ' deg/s']); set(h,'FontSize', fontsz, 'color', [ColorSet(2,:)]);

