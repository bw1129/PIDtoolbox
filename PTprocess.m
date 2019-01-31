%% PTprocess - script that extracts subset of total data based on highlighted epoch in main fig 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) | ~isempty(filenameB)

    
set(PTfig, 'pointer', 'watch')
pause(.2)
if ~isempty(filenameA), 
    Time_A=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'time'))); 
    Time_A=Time_A-Time_A(1);
    if isempty(epoch1_A) | isempty(epoch2_A)
        epoch1_A=round(tta(1)/us2sec)+5;
        epoch2_A=round(tta(end)/us2sec)-5;
        guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
         'callback','@textinput_call; epoch1_A=str2num(guiHandles.Epoch1_A_Input.String); PTprocess;PTplotRaw;');
        guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
         'callback','@textinput_call;epoch2_A=str2num(guiHandles.Epoch2_A_Input.String); PTprocess;PTplotRaw;');
    end
    if (epoch2_A>round(tta(end)/us2sec))
        epoch2_A=round(tta(end)/us2sec);
        guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
         'callback','@textinput_call;epoch2_A=str2num(guiHandles.Epoch2_A_Input.String); PTprocess;PTplotRaw;');
    end

    y=[epoch1_A*us2sec epoch2_A*us2sec];
    dat_A=dataA.DataMain(Time_A>tta(find(tta>y(1),1)) & Time_A<tta(find(tta>y(2),1)),:);

    clear DATtmpA

    DATtmpA.GyroFilt(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'gyroADC[0]')));
    DATtmpA.GyroFilt(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'gyroADC[1]')));
    DATtmpA.GyroFilt(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'gyroADC[2]')));
    
    try
    DATtmpA.GyroRaw(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'debug[0]'))); 
    DATtmpA.GyroRaw(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'debug[1]')));
    DATtmpA.GyroRaw(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'debug[2]')));
    catch
    DATtmpA.GyroRaw(1,:)=zeros(1,length(DATtmpA.GyroFilt(1,:))); 
    DATtmpA.GyroRaw(2,:)=zeros(1,length(DATtmpA.GyroFilt(2,:)));
    DATtmpA.GyroRaw(3,:)=zeros(1,length(DATtmpA.GyroFilt(3,:)));
    end
    DATtmpA.RCcommand(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommand[0]')));
    DATtmpA.RCcommand(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommand[1]')));
    DATtmpA.RCcommand(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommand[2]')));
    DATtmpA.RCcommand(4,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommand[3]')));
    
    DATtmpA.Pterm(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisP[0]')));
    DATtmpA.Pterm(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisP[1]')));
    DATtmpA.Pterm(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisP[2]')));
    
    DATtmpA.Iterm(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisI[0]')));
    DATtmpA.Iterm(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisI[1]')));
    DATtmpA.Iterm(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisI[2]')));
    
    DATtmpA.DtermRaw(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisDuf[0]')));
    DATtmpA.DtermRaw(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisDuf[1]'))); 
    
    DATtmpA.DtermFilt(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisD[0]')));
    DATtmpA.DtermFilt(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisD[1]'))); 
    
    try
    DATtmpA.Fterm(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisF[0]')));
    DATtmpA.Fterm(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisF[1]')));
    DATtmpA.Fterm(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisF[2]')));
    catch
    DATtmpA.Fterm(1,:)=zeros(1,length(DATtmpA.Pterm(1,:)));
    DATtmpA.Fterm(2,:)=zeros(1,length(DATtmpA.Pterm(1,:)));
    DATtmpA.Fterm(3,:)=zeros(1,length(DATtmpA.Pterm(1,:)));
    end
    
    try
    DATtmpA.PIDerr(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisError[0]')));
    DATtmpA.PIDerr(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisError[1]')));
    DATtmpA.PIDerr(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'axisError[2]')));
    DATtmpA.PIDerrALL=DATtmpA.PIDerr(1,:)+DATtmpA.PIDerr(2,:)+DATtmpA.PIDerr(3,:);
    
    DATtmpA.RCRate(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommands[0]')));
    DATtmpA.RCRate(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommands[1]')));
    DATtmpA.RCRate(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommands[2]')));
    DATtmpA.RCRate(4,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'rcCommands[3]')));
    catch
    end
    
    DATtmpA.Motor(1,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'motor[0]')));
    DATtmpA.Motor(2,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'motor[1]')));
    DATtmpA.Motor(3,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'motor[2]')));
    DATtmpA.Motor(4,:)=dat_A(:,find(strcmp(dataA.VarLabels, 'motor[3]')));

    clear dat_A
end

%%%% file 2
if ~isempty(filenameB),   
    Time_B=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'time'))); 
    Time_B=Time_B-Time_B(1);
    if isempty(epoch1_B) | isempty(epoch2_B)
        epoch1_B=round(ttb(1)/us2sec)+5;
        epoch2_B=round(ttb(end)/us2sec)-5;
        guiHandles.Epoch1_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_B_Input],...
         'callback','@textinput_call; epoch1_B=str2num(guiHandles.Epoch1_B_Input.String);PTprocess;PTplotRaw; ');
        guiHandles.Epoch2_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_Input],...
         'callback','@textinput_call; epoch2_B=str2num(guiHandles.Epoch2_B_Input.String);PTprocess;PTplotRaw; ');
    end
    if (epoch2_B>round(ttb(end)/us2sec))
        epoch2_B=round(ttb(end)/us2sec);
        guiHandles.Epoch2_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_Input],...
         'callback','@textinput_call; epoch2_B=str2num(guiHandles.Epoch2_B_Input.String); PTprocess;PTplotRaw;');
    end
    y=[epoch1_B*us2sec epoch2_B*us2sec];
    dat_B=dataB.DataMain(Time_B>ttb(find(ttb>y(1),1)) & Time_B<ttb(find(ttb>y(2),1)),:);
   
    clear DATtmpB 
        
    DATtmpB.GyroFilt(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'gyroADC[0]')));
    DATtmpB.GyroFilt(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'gyroADC[1]')));
    DATtmpB.GyroFilt(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'gyroADC[2]')));
 
    try
    DATtmpB.GyroRaw(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'debug[0]'))); 
    DATtmpB.GyroRaw(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'debug[1]')));
    DATtmpB.GyroRaw(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'debug[2]')));
    catch
    DATtmpB.GyroRaw(1,:)=zeros(1,length(DATtmpB.GyroFilt_B(1,:)));
    DATtmpB.GyroRaw(2,:)=zeros(1,length(DATtmpB.GyroFilt_B(1,:)));
    DATtmpB.GyroRaw(3,:)=zeros(1,length(DATtmpB.GyroFilt_B(1,:)));
    end
    
    DATtmpB.RCcommand(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommand[0]')));
    DATtmpB.RCcommand(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommand[1]')));
    DATtmpB.RCcommand(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommand[2]')));
    DATtmpB.RCcommand(4,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommand[3]')));
    
    DATtmpB.Pterm(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisP[0]')));
    DATtmpB.Pterm(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisP[1]')));
    DATtmpB.Pterm(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisP[2]')));
    
    DATtmpB.Iterm(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisI[0]')));
    DATtmpB.Iterm(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisI[1]')));
    DATtmpB.Iterm(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisI[2]')));
    
    DATtmpB.DtermRaw(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisDuf[0]')));
    DATtmpB.DtermRaw(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisDuf[1]'))); 
    
    DATtmpB.DtermFilt(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisD[0]')));
    DATtmpB.DtermFilt(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisD[1]'))); 
    try
    DATtmpB.Fterm(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisF[0]')));
    DATtmpB.Fterm(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisF[1]')));
    DATtmpB.Fterm(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisF[2]')));
    catch
    DATtmpB.Fterm(1,:)=zeros(1,length(DATtmpB.Pterm(1,:)));
    DATtmpB.Fterm(2,:)=zeros(1,length(DATtmpB.Pterm(1,:)));
    DATtmpB.Fterm(3,:)=zeros(1,length(DATtmpB.Pterm(1,:))); 
    end
    
    try
    DATtmpB.RCRate(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommands[0]')));
    DATtmpB.RCRate(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommands[1]')));
    DATtmpB.RCRate(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommands[2]')));
    DATtmpB.RCRate(4,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'rcCommands[3]')));
    
    DATtmpB.PIDerr(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisError[0]')));
    DATtmpB.PIDerr(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisError[1]')));
    DATtmpB.PIDerr(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'axisError[2]')));
    DATtmpB.PIDerrALL=DATtmpB.PIDerr(1,:)+DATtmpB.PIDerr(2,:)+DATtmpB.PIDerr(3,:);
    catch
    end
    
    DATtmpB.Motor(1,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'motor[0]')));
    DATtmpB.Motor(2,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'motor[1]')));
    DATtmpB.Motor(3,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'motor[2]')));
    DATtmpB.Motor(4,:)=dat_B(:,find(strcmp(dataB.VarLabels, 'motor[3]')));

    clear dat_B
end

if ~isempty(filenameA) & dataA.BBfileFlag
      % compute RCrate
    clear DATtmpB.RCRate DATtmpB.PIDerr 
    DATtmpA.RCRate(1,:)=PTrc2deg(DATtmpA.RCcommand(1,:),RCratesA(1),RCexpoA(1),RCsuperA(1));
    DATtmpA.RCRate(2,:)=PTrc2deg(DATtmpA.RCcommand(2,:),RCratesA(2),RCexpoA(2),RCsuperA(2));
    DATtmpA.RCRate(3,:)=PTrc2deg(DATtmpA.RCcommand(3,:),RCratesA(3),RCexpoA(3),RCsuperA(3));
    DATtmpA.RCRate(4,:)=((DATtmpA.RCcommand(4,:)-1000)/1000)*100;
    
    DATtmpA.PIDerr(1,:)=DATtmpA.GyroFilt(1,:)-DATtmpA.RCRate(1,:);
    DATtmpA.PIDerr(2,:)=DATtmpA.GyroFilt(2,:)-DATtmpA.RCRate(2,:);
    DATtmpA.PIDerr(3,:)=DATtmpA.GyroFilt(3,:)-DATtmpA.RCRate(3,:);
end

if ~isempty(filenameB) & dataB.BBfileFlag
    clear DATtmpB.RCRate DATtmpB.PIDerr

    DATtmpB.RCRate(1,:)=PTrc2deg(DATtmpB.RCcommand(1,:),RCratesB(1),RCexpoB(1),RCsuperB(1));
    DATtmpB.RCRate(2,:)=PTrc2deg(DATtmpB.RCcommand(2,:),RCratesB(2),RCexpoB(2),RCsuperB(2));
    DATtmpB.RCRate(3,:)=PTrc2deg(DATtmpB.RCcommand(3,:),RCratesB(3),RCexpoB(3),RCsuperB(3));
    DATtmpB.RCRate(4,:)=((DATtmpB.RCcommand(4,:)-1000)/1000)*100;
    
    DATtmpB.PIDerr(1,:)=DATtmpB.GyroFilt(1,:)-DATtmpB.RCRate(1,:);
    DATtmpB.PIDerr(2,:)=DATtmpB.GyroFilt(2,:)-DATtmpB.RCRate(2,:);
    DATtmpB.PIDerr(3,:)=DATtmpB.GyroFilt(3,:)-DATtmpB.RCRate(3,:);
end



set(PTfig, 'pointer', 'arrow')


else
end
