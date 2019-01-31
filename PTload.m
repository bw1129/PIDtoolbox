%% PTload - script to load and organize main data and create main directories 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) | ~isempty(filenameB)

us2sec=1000000;

set(PTfig, 'pointer', 'watch')
waitbarFid = waitbar(0,'Please wait...');
pause(.5)

cd(filepath)

%%%% file A 
if ~isempty(filenameA),
    if isempty(filenameAtmp),
        filenameAtmp=filenameA;  
        waitbar(.33,waitbarFid,['importing data from ' filenameA]); 
        clear dataA dat_A
        [dataA] = PTimport(filenameA);
        if ~isempty(dataA)
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisDuf[0]'};% to be computed below
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisDuf[1]'};
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisPID[0]'};
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisPID[1]'};
            dataA.VarLabels(size(dataA.VarLabels,2)+1)={'axisPID[2]'};
            tta=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'time')));    
            tta=tta-tta(1);
            
            %%%%%% Lograte and Looptime
            try
                A_gyro_sync_denom=str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'gyro_sync_denom'),2))));
                A_pid_process_denom=str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'pid_process_denom'),2))));
                A_looptime=((1000/str2num(char(string(dataA.SetupInfo(strcmp(dataA.SetupInfo(:,1),'looptime'),2))))) * 1000) / A_pid_process_denom;
                A_lograte=round((A_looptime) * (1000/A_looptime/median(diff(tta))));
            catch
                clear a b
                a=char(string(dataA.SetupInfo));
                for i=1:length(a),
                    b(i,:)=strsplit(a(i,:),':');   
                end        
                A_gyro_sync_denom=str2num(char(string(b(strcmp(b(:,1),'gyro_sync_denom'),2))));
                A_pid_process_denom=str2num(char(string(b(strcmp(b(:,1),'pid_process_denom'),2))));
                A_looptime=((1000/str2num(char(string(b(strcmp(b(:,1),'looptime'),2))))) * 1000) / A_pid_process_denom;
                A_lograte=((round(1000/median(diff(tta)))) / A_looptime) * A_looptime;
            end   
            
            epoch1_A=round(tta(1)/us2sec)+5;
            epoch2_A=round(tta(end)/us2sec)-5;
            guiHandles.Epoch1_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_A_Input],...
             'callback','@textinput_call; epoch1_A=str2num(guiHandles.Epoch1_A_Input.String); PTprocess;PTplotRaw;');
            guiHandles.Epoch2_A_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_A)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_A_Input],...
             'callback','@textinput_call;epoch2_A=str2num(guiHandles.Epoch2_A_Input.String); PTprocess;PTplotRaw;');  
        else
            filenameA=[];
        end
    end 
else
     epoch1_A=[];epoch2_A=[];
     A_lograte=nan;
     A_looptime=nan;
    tta=0;
    dataA.BBfileFlag=0;
end

%%%% file B
if ~isempty(filenameB),
    if isempty(filenameBtmp),
        filenameBtmp=filenameB;   
        waitbar(.66,waitbarFid,['importing data from ' filenameB]); 
        clear dataB dat_B
        [dataB] = PTimport(filenameB);
        if ~isempty(dataB)
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisDuf[0]'};% to be computed below
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisDuf[1]'};
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisPID[0]'};
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisPID[1]'};
            dataB.VarLabels(size(dataB.VarLabels,2)+1)={'axisPID[2]'};
            
            ttb=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'time'))); 
            ttb=ttb-ttb(1);
            
            %%%%%% Lograte and Looptime
            try
                B_gyro_sync_denom=str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'gyro_sync_denom'),2))));
                B_pid_process_denom=str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'pid_process_denom'),2))));
                B_looptime=((1000/str2num(char(string(dataB.SetupInfo(strcmp(dataB.SetupInfo(:,1),'looptime'),2))))) * 1000) / B_gyro_sync_denom;
                B_lograte=round((B_looptime) * (1000/B_looptime/median(diff(ttb))));
            catch
                clear a b
                a=char(string(dataB.SetupInfo));
                for i=1:length(a),
                    b(i,:)=strsplit(a(i,:),':');   
                end
                B_gyro_sync_denom=str2num(char(string(b(strcmp(b(:,1),'gyro_sync_denom'),2))));
                B_pid_process_denom=str2num(char(string(b(strcmp(b(:,1),'pid_process_denom'),2))));
                B_looptime=((1000/str2num(char(string(b(strcmp(b(:,1),'looptime'),2))))) * 1000) / B_pid_process_denom;
                B_lograte=((round(1000/median(diff(ttb)))) / B_looptime) * B_looptime;
            end   
            
            epoch1_B=round(ttb(1)/us2sec)+5;
            epoch2_B=round(ttb(end)/us2sec)-5;
            guiHandles.Epoch1_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch1_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch1_B_Input],...
            'callback','@textinput_call; epoch1_B=str2num(guiHandles.Epoch1_B_Input.String);PTprocess;PTplotRaw; ');
            guiHandles.Epoch2_B_Input = uicontrol(PTfig,'style','edit','string',[int2str(epoch2_B)],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.Epoch2_B_Input],...
            'callback','@textinput_call; epoch2_B=str2num(guiHandles.Epoch2_B_Input.String);PTprocess;PTplotRaw; '); 
        else
            filenameB=[];
        end
    end
else
     epoch1_B=[];epoch2_B=[];
    B_lograte=nan;
    B_looptime=nan;
    ttb=0;
    dataB.BBfileFlag=0;
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
if ~isempty(filenameA),
    clear DATmainA
 
    DATmainA.RCcommand(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[0]')));
    DATmainA.RCcommand(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[1]')));
    DATmainA.RCcommand(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[2]')));
    DATmainA.RCcommand(4,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommand[3]')));       
    
    DATmainA.GyroFilt(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'gyroADC[0]')));
    DATmainA.GyroFilt(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'gyroADC[1]')));
    DATmainA.GyroFilt(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'gyroADC[2]')));
    
    try
    DATmainA.GyroRaw(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[0]'))); 
    DATmainA.GyroRaw(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[1]')));
    DATmainA.GyroRaw(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'debug[2]')));
    catch
    DATmainA.GyroRaw(1,:)=zeros(1,length(DATmainA.GyroFilt(1,:)));
    DATmainA.GyroRaw(2,:)=zeros(1,length(DATmainA.GyroFilt(2,:)));
    DATmainA.GyroRaw(3,:)=zeros(1,length(DATmainA.GyroFilt(3,:)));
    end
    DATmainA.Pterm(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisP[0]')));
    DATmainA.Pterm(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisP[1]')));
    DATmainA.Pterm(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisP[2]')));
     
    DATmainA.Iterm(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisI[0]')));
    DATmainA.Iterm(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisI[1]')));
    DATmainA.Iterm(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisI[2]')));
    
    DATmainA.DtermFilt(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisD[0]')));
    DATmainA.DtermFilt(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisD[1]'))); 

    DATmainA.DtermRaw(1,:)=[-(diff(DATmainA.GyroFilt(1,:))) 0]; 
    DATmainA.DtermRaw(2,:)=[-(diff(DATmainA.GyroFilt(2,:))) 0]; 
    DATmainA.DtermRaw(1,:)=PTscale2ref(DATmainA.DtermRaw(1,:), DATmainA.DtermFilt(1,:));% scaling function
    DATmainA.DtermRaw(2,:)=PTscale2ref(DATmainA.DtermRaw(2,:), DATmainA.DtermFilt(2,:));
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
       
    try
    DATmainA.RCRate(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[0]')));
    DATmainA.RCRate(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[1]')));
    DATmainA.RCRate(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[2]')));
    DATmainA.RCRate(4,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'rcCommands[3]'))); 
    
    DATmainA.PIDerr(1,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisError[0]')));
    DATmainA.PIDerr(2,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisError[1]')));
    DATmainA.PIDerr(3,:)=dataA.DataMain(:,find(strcmp(dataA.VarLabels, 'axisError[2]')));  
    catch
    end
end

if ~isempty(filenameB),
    clear DATmainB
 
    DATmainB.RCcommand(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[0]')));
    DATmainB.RCcommand(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[1]')));
    DATmainB.RCcommand(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[2]')));
    DATmainB.RCcommand(4,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommand[3]')));  
    
    DATmainB.GyroFilt(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'gyroADC[0]')));
    DATmainB.GyroFilt(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'gyroADC[1]')));
    DATmainB.GyroFilt(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'gyroADC[2]')));
    
    try
    DATmainB.GyroRaw(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[0]'))); 
    DATmainB.GyroRaw(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[1]')));
    DATmainB.GyroRaw(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'debug[2]')));
    catch
    DATmainB.GyroRaw(1,:)=zeros(1,length(DATmainB.GyroFilt(1,:)));
    DATmainB.GyroRaw(2,:)=zeros(1,length(DATmainB.GyroFilt(2,:)));
    DATmainB.GyroRaw(3,:)=zeros(1,length(DATmainB.GyroFilt(3,:)));
    end
    
    DATmainB.Pterm(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisP[0]')));
    DATmainB.Pterm(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisP[1]')));
    DATmainB.Pterm(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisP[2]')));
    
    DATmainB.Iterm(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisI[0]')));
    DATmainB.Iterm(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisI[1]')));
    DATmainB.Iterm(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisI[2]')));
      
    DATmainB.DtermFilt(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisD[0]')));
    DATmainB.DtermFilt(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisD[1]')));
    
    DATmainB.DtermRaw(1,:)=[-(diff(DATmainB.GyroFilt(1,:))) 0]; 
    DATmainB.DtermRaw(2,:)=[-(diff(DATmainB.GyroFilt(2,:))) 0]; 
    DATmainB.DtermRaw(1,:)=PTscale2ref(DATmainB.DtermRaw(1,:), DATmainB.DtermFilt(1,:));% scaling function
    DATmainB.DtermRaw(2,:)=PTscale2ref(DATmainB.DtermRaw(2,:), DATmainB.DtermFilt(2,:));
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
        
    try
    DATmainB.RCRate(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[0]')));
    DATmainB.RCRate(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[1]')));
    DATmainB.RCRate(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[2]')));
    DATmainB.RCRate(4,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'rcCommands[3]')));
    
    DATmainB.PIDerr(1,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisError[0]')));
    DATmainB.PIDerr(2,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisError[1]')));
    DATmainB.PIDerr(3,:)=dataB.DataMain(:,find(strcmp(dataB.VarLabels, 'axisError[2]')));
    catch
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
    if  ~dataA.BBfileFlag
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
    else
         for i=1:size(infoStr,1)
            a=strfind(dataA.SetupInfo,infoStr{i});
            b=find(cellfun(@(a)~isempty(a)&&a>0,a)); 
            if i==8, if length(b)>1,b=b(2);end; end
            eval([infoStr2{i} '_A=dataA.SetupInfo{b}(strfind(dataA.SetupInfo{b},'':'')+1:end);']);  
        end
    end
end
if ~isempty(filenameB)
    if ~dataB.BBfileFlag
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
    else
        for i=1:size(infoStr,1)
            a=strfind(dataB.SetupInfo,infoStr{i}); 
            b=find(cellfun(@(a)~isempty(a)&&a>0,a)); 
            if i==8, if length(b)>1,b=b(2);end; end
            eval([infoStr2{i} '_B=dataB.SetupInfo{b}(strfind(dataB.SetupInfo{b},'':'')+1:end);']);  
        end
    end
end

%%
if ~isempty(filenameA) & dataA.BBfileFlag % if data imported from BB log using blackbox_decode
    clear RCratesA RCexpoA RCsuperA 
    RCratesA=str2num(char(string(dataA.rates(1,2))));
    RCexpoA=str2num(char(string(dataA.rates(2,2))));
    RCsuperA=str2num(char(string(dataA.rates(3,2)))); 
    
      % compute RCrate
    clear DATmainA.RCRate DATmainA.PIDerr 
    DATmainA.RCRate(1,:)=PTrc2deg(DATmainA.RCcommand(1,:),RCratesA(1),RCexpoA(1),RCsuperA(1));
    DATmainA.RCRate(2,:)=PTrc2deg(DATmainA.RCcommand(2,:),RCratesA(2),RCexpoA(2),RCsuperA(2));
    DATmainA.RCRate(3,:)=PTrc2deg(DATmainA.RCcommand(3,:),RCratesA(3),RCexpoA(3),RCsuperA(3));
    DATmainA.RCRate(4,:)=(DATmainA.RCcommand(4,:)-999) / 10;
    
    DATmainA.PIDerr(1,:)=DATmainA.GyroFilt(1,:)-DATmainA.RCRate(1,:);
    DATmainA.PIDerr(2,:)=DATmainA.GyroFilt(2,:)-DATmainA.RCRate(2,:);
    DATmainA.PIDerr(3,:)=DATmainA.GyroFilt(3,:)-DATmainA.RCRate(3,:);
end

if  ~isempty(filenameB) & dataB.BBfileFlag % if data imported from BB log using blackbox_decode
    clear RCratesB RCexpoB RCsuperB   
    RCratesB=str2num(char(string(dataB.rates(1,2))));
    RCexpoB=str2num(char(string(dataB.rates(2,2))));
    RCsuperB=str2num(char(string(dataB.rates(3,2))));
 %   thrMidB=str2num(char(string(dataB.rates(4,2))));
 %   thrExpoB=str2num(char(string(dataB.rates(5,2))));
    
    clear DATmainB.RCRate DATmainB.PIDerr
    DATmainB.RCRate(1,:)=PTrc2deg(DATmainB.RCcommand(1,:),RCratesB(1),RCexpoB(1),RCsuperB(1));
    DATmainB.RCRate(2,:)=PTrc2deg(DATmainB.RCcommand(2,:),RCratesB(2),RCexpoB(2),RCsuperB(2));
    DATmainB.RCRate(3,:)=PTrc2deg(DATmainB.RCcommand(3,:),RCratesB(3),RCexpoB(3),RCsuperB(3));
    DATmainB.RCRate(4,:)=(DATmainB.RCcommand(4,:)-999) / 10;

    DATmainB.PIDerr(1,:)=DATmainB.GyroFilt(1,:)-DATmainB.RCRate(1,:);
    DATmainB.PIDerr(2,:)=DATmainB.GyroFilt(2,:)-DATmainB.RCRate(2,:);
    DATmainB.PIDerr(3,:)=DATmainB.GyroFilt(3,:)-DATmainB.RCRate(3,:);
end

%%

%%%% get estimated phase delay
try 
clear a b r p sampTime maxlag
sampTime=(mean(diff(tta)));
maxlag=int8(round(5000/sampTime)); %~5s delay
r=finddelay(DATmainA.GyroRaw(1,:),DATmainA.GyroFilt(1,:),maxlag) * sampTime / 1000;
p=finddelay(DATmainA.GyroRaw(2,:),DATmainA.GyroFilt(2,:),maxlag) * sampTime / 1000;
a=[r p];
b=find(a)<5 & find(a)>.1;
if length(b)>1
    PhaseDelay_A=mean(a);
else
    PhaseDelay_A=(a(b));
end
if PhaseDelay_A<.1, PhaseDelay_A=[]; end % when garbage gets through

clear a b r p 
r=finddelay(DATmainA.DtermRaw(1,:),DATmainA.DtermFilt(1,:),maxlag) * sampTime / 1000;
p=finddelay(DATmainA.DtermRaw(2,:),DATmainA.DtermFilt(2,:),maxlag) * sampTime / 1000;
a=[r p];
b=find(a)<5 & find(a)>.1;
if length(b)>1
    PhaseDelay2_A=mean(a);
else
    PhaseDelay2_A=(a(b));
end
if PhaseDelay2_A<.1, PhaseDelay2_A=[]; end % when garbage gets through

ResponseDelayR_A=finddelay(DATmainA.RCRate(1,:),DATmainA.GyroFilt(1,:),maxlag*4) * sampTime / 1000;
ResponseDelayP_A=finddelay(DATmainA.RCRate(2,:),DATmainA.GyroFilt(2,:),maxlag*4) * sampTime / 1000;
ResponseDelayY_A=finddelay(DATmainA.RCRate(3,:),DATmainA.GyroFilt(3,:),maxlag*4) * sampTime / 1000;
clear a b r p sampTime maxlag

catch
end


try
clear a b r p sampTime maxlag
sampTime=(mean(diff(ttb)));
maxlag=int8(round(5000/sampTime)); %~5s delay
r=finddelay(DATmainB.GyroRaw(1,:),DATmainB.GyroFilt(1,:),maxlag) * sampTime / 1000;
p=finddelay(DATmainB.GyroRaw(2,:),DATmainB.GyroFilt(2,:),maxlag) * sampTime / 1000;
a=[r p];
b=find(a)<5 & find(a)>.1;
if length(b)>1
    PhaseDelay_B=mean(a);
else
    PhaseDelay_B=(a(b));
end
if PhaseDelay_B<.1, PhaseDelay_B=[]; end % when garbage gets through

clear a b r p 
r=finddelay(DATmainB.DtermRaw(1,:),DATmainB.DtermFilt(1,:),maxlag) * sampTime / 1000;
p=finddelay(DATmainB.DtermRaw(2,:),DATmainB.DtermFilt(2,:),maxlag) * sampTime / 1000;
a=[r p];
b=find(a)<5 & find(a)>.1;
if length(b)>1
    PhaseDelay2_B=mean(a);
else
    PhaseDelay2_B=(a(b));
end
if PhaseDelay2_B<.1, PhaseDelay2_B=[]; end % when garbage gets through

ResponseDelayR_B=finddelay(DATmainB.RCRate(1,:),DATmainB.GyroFilt(1,:),maxlag*4) * sampTime / 1000;
ResponseDelayP_B=finddelay(DATmainB.RCRate(2,:),DATmainB.GyroFilt(2,:),maxlag*4) * sampTime / 1000;
ResponseDelayY_B=finddelay(DATmainB.RCRate(3,:),DATmainB.GyroFilt(3,:),maxlag*4) * sampTime / 1000;
clear a b r p sampTime maxlag
catch
end

%% create saveDirectory
if ~isempty(filenameA) & ~isempty(filenameB)
    saveDirectory=[filenameA(1:end-4) '-' filenameB(1:end-4)];
end
if ~isempty(filenameA) & isempty(filenameB)
    saveDirectory=[filenameA(1:end-4)];
end
if ~isempty(filenameB) & isempty(filenameA)
    saveDirectory=[filenameB(1:end-4)];
end
if ~exist(saveDirectory,'dir')
    if ~isempty(strfind(saveDirectory,'.bbl')) 
        s=strfind(saveDirectory,'.bbl');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
    end
     if ~isempty(strfind(saveDirectory,'.bfl')) 
        s=strfind(saveDirectory,'.bfl');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
     end
    if ~isempty(strfind(saveDirectory,'.BBL'))  
        s=strfind(saveDirectory,'.BBL');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
    end
     if ~isempty(strfind(saveDirectory,'.BFL'))
        s=strfind(saveDirectory,'.BFL');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
    end
   mkdir(saveDirectory)
end


%%
close(waitbarFid)
set(PTfig, 'pointer', 'arrow')

else
    PlotSelect.Value=1;
end
