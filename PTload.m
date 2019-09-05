%% PTload - script to load and organize main data and create main directories 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


%% betaflight debug_modes
% https://github.com/betaflight/betaflight/wiki/Debug-Modes?fbclid=IwAR2bKepD_cNZNnRtlAxf7yf3CWjYm2-MbFuwoGn3tUm8wPefp9CCJQR7c9Y
GYRO_SCALED=6;
DSHOT_RPM_TELEMETRY=47;
    
try
    
if ~isempty(filenameA) || ~isempty(filenameB)


us2sec=1000000;
maxMotorOutput=2000; 

set(PTfig, 'pointer', 'watch')
guiHandles.runAll.FontWeight='Bold';

pause(.2)

% this is the catch error when user clicks 'select file' but does not
% actually make a selection.
if ~isempty(filenameA)
    filepath=filepathA; 
end
if ~isempty(filenameB)
    filepath=filepathB;
end

% make 'logfileDir.txt' so logfiles open in same as previously selected directory  
cd(executableDir)
pause(.2)
fid = fopen('logfileDir.txt','w');
fprintf(fid,'%s\n',filepath);
fclose(fid);
    
try
    cd(filepath)
catch
    errordlg('please select file then click ''load+run'' ','error - no file selected!');
    set(PTfig, 'pointer', 'arrow')
    close(waitbarFid); 
end
    

%%%% file A 
if ~isempty(filenameA)
    if isempty(filenameAtmp)
        filenameAtmp=filenameA;  
        clear dataA dat_A
  %      try
        [dataA] = PTimport(filenameA);
  %      catch ME
  %          errmsg.PTimport=PTerrorMessages('PTimport', ME);
  %      end
        if ~isempty(dataA)
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisDuf[0]'};% to be computed below
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisDuf[1]'};
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisPID[0]'};
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisPID[1]'};
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisPID[2]'};
            tta=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'time')));    
            tta=tta-tta(1);
            
            %%%%%% Lograte and Looptime
            A_gyro_sync_denom=str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'gyro_sync_denom'),2))));
            A_pid_process_denom=str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'pid_process_denom'),2))));
            A_looptime=str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'looptime'),2))));
            A_lograte=round(1000/median(diff(tta)));
            if ~isempty(str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'debug_mode'),2)))))
                A_debugmode=str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'debug_mode'),2))));
            end
            if A_lograte > 4    
                waitfor(msgbox(['File A lograte = ' num2str(A_lograte) 'kHz. For faster processing, please consider logging @ 2kHz!']));
            end
            if A_lograte < 1
                waitfor(msgbox(['Caution, file A lograte = ' num2str(A_lograte) 'kHz. Spectrograms may be unreliable. Please consider logging @ 2kHz!']));
            end

            epoch1_A=round(tta(1)/us2sec)+2;
            epoch2_A=round(tta(end)/us2sec)-2;
            guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
             'callback','@textinput_call; epoch1_A=str2num(guiHandles.Epoch1_A_Input.String); PTprocess;PTplotLogViewer;');
            guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
             'callback','@textinput_call;epoch2_A=str2num(guiHandles.Epoch2_A_Input.String); PTprocess;PTplotLogViewer;');  
        else
            filenameA=[];
        end
    end 
else
     epoch1_A=[];epoch2_A=[];
     A_lograte=nan;
     A_looptime=nan;
    tta=0;
end

%%%% file B
if ~isempty(filenameB)
    if isempty(filenameBtmp)
        filenameBtmp=filenameB;   
        clear dataB dat_B
        try
        [dataB] = PTimport(filenameB);
        catch ME
            errmsg.PTimport=PTerrorMessages('PTimport', ME);
        end
        if ~isempty(dataB)
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisDuf[0]'};% to be computed below
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisDuf[1]'};
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisPID[0]'};
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisPID[1]'};
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisPID[2]'};
            
            ttb=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'time'))); 
            ttb=ttb-ttb(1);
            
            %%%%%% Lograte and Looptime
            B_gyro_sync_denom=str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'gyro_sync_denom'),2))));
            B_pid_process_denom=str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'pid_process_denom'),2))));
            B_looptime=str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'looptime'),2))));
            B_lograte=round(1000/median(diff(ttb)));
            if ~isempty(str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'debug_mode'),2)))))
                B_debugmode=str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'debug_mode'),2))));
            end
            if B_lograte > 4
                waitfor(msgbox(['File B lograte = ' num2str(B_lograte) 'kHz. For faster processing, please consider logging @ 2kHz!']));
            end
            if B_lograte < 1
                waitfor(msgbox(['File B lograte = ' num2str(B_lograte) 'kHz. Caution, spectrograms may be unreliable, please consider logging @ 2kHz!']));
            end
            epoch1_B=round(ttb(1)/us2sec)+2;
            epoch2_B=round(ttb(end)/us2sec)-2;
            guiHandles.Epoch1_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_B_Input],...
            'callback','@textinput_call; epoch1_B=str2num(guiHandles.Epoch1_B_Input.String);PTprocess;PTplotLogViewer; ');
            guiHandles.Epoch2_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_Input],...
            'callback','@textinput_call; epoch2_B=str2num(guiHandles.Epoch2_B_Input.String);PTprocess;PTplotLogViewer; '); 
        else
            filenameB=[];
        end
    end
else
     epoch1_B=[];epoch2_B=[];
    B_lograte=nan;
    B_looptime=nan;
    ttb=0;
end

%%%% if there is no data worth analyzing
if isempty(filenameA) && isempty(filenameB)
    a=errordlg('there is no valid data to analyze. closing program...');pause(3);close(a);
    close(waitbarFid);
    close(figure(1));
    clear
end

    
% collect full data here for time plots, and breakout plots
% where you want full range of data
if ~isempty(filenameA)
    clear DATmainA
 
    DATmainA.RCcommand(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[0]')));
    DATmainA.RCcommand(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[1]')));
    DATmainA.RCcommand(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[2]')));
    DATmainA.RCcommand(4,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[3]')));       
    
    DATmainA.GyroFilt(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'gyroADC[0]')));
    DATmainA.GyroFilt(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'gyroADC[1]')));
    DATmainA.GyroFilt(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'gyroADC[2]')));
    
    % motors
    for ii=1:4
        minM=min(dataA.DataMain(:,find(strcmp(dataA.VarLabels, ['motor[' int2str(ii-1) ']']))));
        maxM=max(dataA.DataMain(:,find(strcmp(dataA.VarLabels, ['motor[' int2str(ii-1) ']']))));
        if maxM<maxMotorOutput,
            MaxM=maxMotorOutput;
        end
        DATmainA.Motor(ii,:)=((dataA.DataMain(:,find(strcmp(dataA.VarLabels, ['motor[' int2str(ii-1) ']']))) - minM) / (maxM - minM)) * 100;
    end
    
    try 
        DATmainA.debug(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[0]'))); 
        DATmainA.debug(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[1]')));
        DATmainA.debug(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[2]')));  
        DATmainA.debug(4,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[3]')));
    catch % empty      
        DATmainA.debug(1,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
        DATmainA.debug(2,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
        DATmainA.debug(3,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
        DATmainA.debug(4,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
    end
    if A_debugmode==DSHOT_RPM_TELEMETRY % DSHOT_RPM_TELEMETRY
        DATmainA.debug(1,:)=PTscale2ref( dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[0]'))), DATmainA.Motor(1,:));
        DATmainA.debug(2,:)=PTscale2ref( dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[1]'))), DATmainA.Motor(2,:));
        DATmainA.debug(3,:)=PTscale2ref( dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[2]'))), DATmainA.Motor(3,:));
        DATmainA.debug(4,:)=PTscale2ref( dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[3]'))), DATmainA.Motor(4,:));        
    end
    
    DATmainA.Pterm(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisP[0]')));
    DATmainA.Pterm(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisP[1]')));
    DATmainA.Pterm(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisP[2]')));
     
    DATmainA.Iterm(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisI[0]')));
    DATmainA.Iterm(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisI[1]')));
    DATmainA.Iterm(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisI[2]')));
    
    try %dterm is only PID term that if set to 0 will not generate axisD variable at all
        DATmainA.DtermFilt(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisD[0]')));
        DATmainA.DtermFilt(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisD[1]'))); 
    catch
        DATmainA.DtermFilt(1,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
        DATmainA.DtermFilt(2,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
    end    
   
    DATmainA.DtermRaw(1,:)=[-(diff(DATmainA.GyroFilt(1,:))) 0]; 
    DATmainA.DtermRaw(2,:)=[-(diff(DATmainA.GyroFilt(2,:))) 0]; 
    
    DATmainA.DtermRaw(1,:)=PTscale2ref(DATmainA.DtermRaw(1,:),DATmainA.DtermFilt(1,:));
    DATmainA.DtermRaw(2,:)=PTscale2ref(DATmainA.DtermRaw(2,:),DATmainA.DtermFilt(2,:));
    
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisDuf[0]')))=zeros(size(dataA.DataMain(:,1)));
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisDuf[1]')))=zeros(size(dataA.DataMain(:,1)));
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisDuf[0]')))=DATmainA.DtermRaw(1,:)';
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisDuf[1]')))=DATmainA.DtermRaw(2,:)';
    
    try
    DATmainA.Fterm(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisF[0]')));
    DATmainA.Fterm(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisF[1]')));
    DATmainA.Fterm(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisF[2]')));
    catch
    DATmainA.Fterm(1,:)=zeros(1,length(DATmainA.Pterm(1,:)));
    DATmainA.Fterm(2,:)=zeros(1,length(DATmainA.Pterm(1,:)));
    DATmainA.Fterm(3,:)=zeros(1,length(DATmainA.Pterm(1,:))); 
    end
    
    DATmainA.PIDsum(1,:)=DATmainA.Pterm(1,:)+DATmainA.Iterm(1,:)+DATmainA.DtermFilt(1,:)+DATmainA.Fterm(1,:);
    DATmainA.PIDsum(2,:)=DATmainA.Pterm(2,:)+DATmainA.Iterm(2,:)+DATmainA.DtermFilt(2,:)+DATmainA.Fterm(2,:);
    DATmainA.PIDsum(3,:)=DATmainA.Pterm(3,:)+DATmainA.Iterm(3,:)+DATmainA.Fterm(3,:);
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisPID[0]')))=DATmainA.PIDsum(1,:);
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisPID[1]')))=DATmainA.PIDsum(2,:); 
    dataA.DataMain(:,find(strcmp(dataA.VarLabels,'axisPID[2]')))=DATmainA.PIDsum(3,:);
       
    if ~isempty(find(strcmp(dataA.VarLabels, 'rcCommands[0]')))% old set point
        DATmainA.RCRate(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[0]')));
        DATmainA.RCRate(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[1]')));
        DATmainA.RCRate(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[2]')));
        DATmainA.RCRate(4,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[3]'))); 
    elseif ~isempty(find(strcmp(dataA.VarLabels, 'setpoint[0]')))% new set point
        disp('setpoint for A called')
        DATmainA.RCRate(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'setpoint[0]')));
        DATmainA.RCRate(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'setpoint[1]')));
        DATmainA.RCRate(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'setpoint[2]')));
        DATmainA.RCRate(4,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'setpoint[3]')))/10;% scale to 100          
    else % if it doesnt exist
        disp('PTrc2deg for A called')
        DATmainA.RCRate(1,:)=PTrc2deg(DATmainA.RCcommand(1,:),dataA.rates(1,1), dataA.rates(2,1), dataA.rates(3,1));
        DATmainA.RCRate(2,:)=PTrc2deg(DATmainA.RCcommand(2,:),dataA.rates(1,2), dataA.rates(2,2), dataA.rates(3,2));
        DATmainA.RCRate(3,:)=PTrc2deg(DATmainA.RCcommand(3,:),dataA.rates(1,3), dataA.rates(2,3), dataA.rates(3,3));
        DATmainA.RCRate(4,:)=PTthrPercent(DATmainA.RCcommand(4,:));
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'rcCommands[0]'};
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'rcCommands[1]'};
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'rcCommands[2]'};
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'rcCommands[3]'};
        dataA.DataMain(:,end+1)=DATmainA.RCRate(1,:);
        dataA.DataMain(:,end+1)=DATmainA.RCRate(2,:);
        dataA.DataMain(:,end+1)=DATmainA.RCRate(3,:);
        dataA.DataMain(:,end+1)=DATmainA.RCRate(4,:);
    end
    
    try
    DATmainA.PIDerr(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisError[0]')));
    DATmainA.PIDerr(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisError[1]')));
    DATmainA.PIDerr(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisError[2]')));  
    catch
        DATmainA.PIDerr(1,:)=DATmainA.GyroFilt(1,:)-DATmainA.RCRate(1,:);
        DATmainA.PIDerr(2,:)=DATmainA.GyroFilt(2,:)-DATmainA.RCRate(2,:);
        DATmainA.PIDerr(3,:)=DATmainA.GyroFilt(3,:)-DATmainA.RCRate(3,:);
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisError[0]'};
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisError[1]'};
        dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisError[2]'};
        dataA.DataMain(:,end+1)=DATmainA.PIDerr(1,:);
        dataA.DataMain(:,end+1)=DATmainA.PIDerr(2,:);
        dataA.DataMain(:,end+1)=DATmainA.PIDerr(3,:);
    end
end

if ~isempty(filenameB)
    clear DATmainB
 
    DATmainB.RCcommand(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[0]')));
    DATmainB.RCcommand(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[1]')));
    DATmainB.RCcommand(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[2]')));
    DATmainB.RCcommand(4,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[3]')));  
    
    DATmainB.GyroFilt(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'gyroADC[0]')));
    DATmainB.GyroFilt(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'gyroADC[1]')));
    DATmainB.GyroFilt(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'gyroADC[2]')));
    
    % motors
    for ii=1:4
        minM=min(dataB.DataMain(:,find(strcmp(dataB.VarLabels, ['motor[' int2str(ii-1) ']']))));
        maxM=max(dataB.DataMain(:,find(strcmp(dataB.VarLabels, ['motor[' int2str(ii-1) ']']))));
        if maxM<maxMotorOutput,
            MaxM=maxMotorOutput;
        end
        DATmainB.Motor(ii,:)=((dataB.DataMain(:,find(strcmp(dataB.VarLabels, ['motor[' int2str(ii-1) ']']))) - minM) / (maxM - minM)) * 100;
    end
    
    try
        DATmainB.debug(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[0]'))); 
        DATmainB.debug(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[1]')));
        DATmainB.debug(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[2]')));
        DATmainB.debug(4,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[3]')));
    catch % empty
        DATmainB.debug(1,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
        DATmainB.debug(2,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
        DATmainB.debug(3,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
        DATmainB.debug(3,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
    end
    if B_debugmode==DSHOT_RPM_TELEMETRY % DSHOT_RPM_TELEMETRY
        DATmainB.debug(1,:)=PTscale2ref( dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[0]'))), DATmainB.Motor(1,:));
        DATmainB.debug(2,:)=PTscale2ref( dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[1]'))), DATmainB.Motor(2,:));
        DATmainB.debug(3,:)=PTscale2ref( dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[2]'))), DATmainB.Motor(3,:));
        DATmainB.debug(4,:)=PTscale2ref( dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[3]'))), DATmainB.Motor(4,:));        
    end
    
    DATmainB.Pterm(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisP[0]')));
    DATmainB.Pterm(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisP[1]')));
    DATmainB.Pterm(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisP[2]')));
    
    DATmainB.Iterm(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisI[0]')));
    DATmainB.Iterm(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisI[1]')));
    DATmainB.Iterm(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisI[2]')));
      
     try %dterm is only PID term that if set to 0 will not generate axisD variable at all
        DATmainB.DtermFilt(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisD[0]')));
        DATmainB.DtermFilt(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisD[1]')));
    catch
        DATmainB.DtermFilt(1,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
        DATmainB.DtermFilt(2,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
    end    
    
    
    DATmainB.DtermRaw(1,:)=[-(diff(DATmainB.GyroFilt(1,:))) 0]; 
    DATmainB.DtermRaw(2,:)=[-(diff(DATmainB.GyroFilt(2,:))) 0]; 
    DATmainB.DtermRaw(1,:)=PTscale2ref(DATmainB.DtermRaw(1,:),DATmainB.DtermFilt(1,:));
    DATmainB.DtermRaw(2,:)=PTscale2ref(DATmainB.DtermRaw(2,:),DATmainB.DtermFilt(2,:));
    
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisDuf[0]')))=zeros(size(dataB.DataMain(:,1)));
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisDuf[1]')))=zeros(size(dataB.DataMain(:,1)));
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisDuf[0]')))=DATmainB.DtermRaw(1,:)';
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisDuf[1]')))=DATmainB.DtermRaw(2,:)';
    
    try
    DATmainB.Fterm(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisF[0]')));
    DATmainB.Fterm(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisF[1]')));
    DATmainB.Fterm(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisF[2]')));
    catch
    DATmainB.Fterm(1,:)=zeros(1,length(DATmainB.Pterm(1,:)));
    DATmainB.Fterm(2,:)=zeros(1,length(DATmainB.Pterm(1,:)));
    DATmainB.Fterm(3,:)=zeros(1,length(DATmainB.Pterm(1,:)));
    end
    
    DATmainB.PIDsum(1,:)=DATmainB.Pterm(1,:)+DATmainB.Iterm(1,:)+DATmainB.DtermFilt(1,:)+DATmainB.Fterm(1,:);
    DATmainB.PIDsum(2,:)=DATmainB.Pterm(2,:)+DATmainB.Iterm(2,:)+DATmainB.DtermFilt(2,:)+DATmainB.Fterm(2,:);
    DATmainB.PIDsum(3,:)=DATmainB.Pterm(3,:)+DATmainB.Iterm(3,:)+DATmainB.Fterm(3,:);
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisPID[0]')))=DATmainB.PIDsum(1,:);
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisPID[1]')))=DATmainB.PIDsum(2,:);
    dataB.DataMain(:,find(strcmp(dataB.VarLabels,'axisPID[2]')))=DATmainB.PIDsum(3,:);
        
    if ~isempty(find(strcmp(dataB.VarLabels, 'rcCommands[0]')))% old set point   
        DATmainB.RCRate(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[0]')));
        DATmainB.RCRate(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[1]')));
        DATmainB.RCRate(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[2]')));
        DATmainB.RCRate(4,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[3]')));
    elseif ~isempty(find(strcmp(dataB.VarLabels, 'setpoint[0]')))% new set point
        disp('setpoint for B called')
        DATmainB.RCRate(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'setpoint[0]')));
        DATmainB.RCRate(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'setpoint[1]')));
        DATmainB.RCRate(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'setpoint[2]')));
        DATmainB.RCRate(4,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'setpoint[3]')))/10;% scale to 100  
    else
        disp('PTrc2deg for B called')
        DATmainB.RCRate(1,:)=PTrc2deg(DATmainB.RCcommand(1,:),dataB.rates(1,1), dataB.rates(2,1), dataB.rates(3,1));
        DATmainB.RCRate(2,:)=PTrc2deg(DATmainB.RCcommand(2,:),dataB.rates(1,2), dataB.rates(2,2), dataB.rates(3,2));
        DATmainB.RCRate(3,:)=PTrc2deg(DATmainB.RCcommand(3,:),dataB.rates(1,3), dataB.rates(2,3), dataB.rates(3,3));
        DATmainB.RCRate(4,:)=PTthrPercent(DATmainB.RCcommand(4,:));
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'rcCommands[0]'};
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'rcCommands[1]'};
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'rcCommands[2]'};
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'rcCommands[3]'};
        dataB.DataMain(:,end+1)=DATmainB.RCRate(1,:);
        dataB.DataMain(:,end+1)=DATmainB.RCRate(2,:);
        dataB.DataMain(:,end+1)=DATmainB.RCRate(3,:);
        dataB.DataMain(:,end+1)=DATmainB.RCRate(4,:);
     end
    
    try
        DATmainB.PIDerr(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisError[0]')));
        DATmainB.PIDerr(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisError[1]')));
        DATmainB.PIDerr(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisError[2]')));
    catch
        DATmainB.PIDerr(1,:)=DATmainB.GyroFilt(1,:)-DATmainB.RCRate(1,:);
        DATmainB.PIDerr(2,:)=DATmainB.GyroFilt(2,:)-DATmainB.RCRate(2,:);
        DATmainB.PIDerr(3,:)=DATmainB.GyroFilt(3,:)-DATmainB.RCRate(3,:);
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisError[0]'};
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisError[1]'};
        dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisError[2]'};
        dataB.DataMain(:,end+1)=DATmainB.PIDerr(1,:);
        dataB.DataMain(:,end+1)=DATmainB.PIDerr(2,:);
        dataB.DataMain(:,end+1)=DATmainB.PIDerr(3,:);
    end 
end
%%
clear Firmware_revision_A looptime_A frameIntervalPDenom_A rollPIDF_A pitchPIDF_A yawPIDF_A rc_rates_A rc_expo_A Super_rates_A gyro_lowpass_hz_A gyro_lowpass2_hz_A  dterm_lpf_hz_A 
clear Firmware_revision_B looptime_B frameIntervalPDenom_B rollPIDF_B pitchPIDF_B yawPIDF_B rc_rates_B rc_expo_B Super_rates_B gyro_lowpass_hz_B gyro_lowpass2_hz_B  dterm_lpf_hz_B 

%%%%% only for finding setup info from BBlog file directly
infoStr={'Firmware revision';'looptime';'rollPID';'pitchPID';'yawPID'; 'rc_rates';'rc_expo';'rates';'gyro_lowpass_hz';'gyro_lowpass2_hz';'dterm_lowpass_hz';'dterm_lowpass2_hz'};
infoStr2={'Firmware_revision';'looptime';'rollPIDF';'pitchPIDF';'yawPIDF'; 'rc_rates';'rc_expo';'Super_rates';'gyro_lowpass_hz';'gyro_lowpass2_hz';'dterm_lpf_hz';'dterm_lpf2_hz'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(filenameA)    
    Firmware_revision_A=char(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'Firmware revision')),:));
    looptime_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'looptime')),:));
    frameIntervalPDenom_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'frameIntervalPDenom')),:));
    rollPIDF_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'rollPID')),:));
    pitchPIDF_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'pitchPID')),:));
    yawPIDF_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'yawPID')),:));
    rc_rates_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'rc_rates')),:));
    rc_expo_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'rc_expo')),:));
    Super_rates_A=(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'rates')),:));
    gyro_lowpass_hz_A=dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'gyro_lowpass_hz')),:);
    gyro_lowpass2_hz_A=dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'gyro_lowpass2_hz')),:);
    dterm_lpf_hz_A=dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'dterm_lpf_hz')),:);
    dterm_lpf2_hz_A=dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'dterm_lpf2_hz')),:);
    try
        FF_A=str2num(char(dataA.SetupInfo(find(strcmp(dataA.SetupInfo(:,1), 'feedforward_weight')),2)));
        Rtmp=num2str([str2num(rollPIDF_A{2}) FF_A(1)]); rollPIDF_A{2}=Rtmp;
        Ptmp=num2str([str2num(pitchPIDF_A{2}) FF_A(2)]); pitchPIDF_A{2}=Ptmp;
        Ytmp=num2str([str2num(yawPIDF_A{2}) FF_A(3)]); yawPIDF_A{2}=Ytmp;
    catch
    end
end
if ~isempty(filenameB)
    Firmware_revision_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'Firmware revision')),:));
    looptime_B=dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'looptime')),:);
    frameIntervalPDenom_B=dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'frameIntervalPDenom')),:);
    rollPIDF_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'rollPID')),:));
    pitchPIDF_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'pitchPID')),:));
    yawPIDF_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'yawPID')),:));
    rc_rates_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'rc_rates')),:));
    rc_expo_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'rc_expo')),:));
    Super_rates_B=(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'rates')),:));
    gyro_lowpass_hz_B=dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'gyro_lowpass_hz')),:);
    gyro_lowpass2_hz_B=dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'gyro_lowpass2_hz')),:);
    dterm_lpf_hz_B=dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'dterm_lpf_hz')),:);
    dterm_lpf2_hz_B=dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'dterm_lpf2_hz')),:);
    try
        FF_B=str2num(char(dataB.SetupInfo(find(strcmp(dataB.SetupInfo(:,1), 'feedforward_weight')),2)));
        Rtmp=num2str([str2num(rollPIDF_B{2}) FF_B(1)]); rollPIDF_B{2}=Rtmp;
        Ptmp=num2str([str2num(pitchPIDF_B{2}) FF_B(2)]); pitchPIDF_B{2}=Ptmp;
        Ytmp=num2str([str2num(yawPIDF_B{2}) FF_B(3)]); yawPIDF_B{2}=Ytmp;
    catch
    end
end


%%
set(PTfig, 'pointer', 'arrow')

end

catch ME
    errmsg.PTload=PTerrorMessages('PTload', ME); 
end

%% some functions used within this script
function [throttlePercent] = PTthrPercent(X) 
% converts raw throttle [RCcommand] to percent    
    rcCommandf = (X-1000);  
    throttlePercent = ((rcCommandf-0) / (1000-0)) * 100;
end


