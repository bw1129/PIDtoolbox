function [DAT] = PTimport(filename)
%% [mainFname, csvFname, SetupInfo, VarLabels, DataMain, BBfileFlag] = PTimport(filename)
%  Imports log data in multiple formats. Default is .csv, but if using .bbl or .bfl files, 
% a version of blackbox_decode.exe must be in the log file folder
% blackbox_decode.exe is part of "blackbox_tools", which can be found here:
% https://github.com/betaflight/blackbox-tools
% https://github.com/cleanflight/blackbox-tools
 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

%%
    
waitbarFid = waitbar(0,'Please wait...');
pause(.5)

BBfileFlag=0;
validData=1;
a=strfind(filename, ' ');% had to remove white space  to run in bb decode
a=fliplr(a);
if ~isempty((find(isspace(filename))))
    filename2=filename(find(~isspace(filename)));% have to get rid of spaces to run blackbox_decode using 'system' function
    movefile(filename,filename2);%rename file without spaces
    filename=filename2; 
    clear filename2
end
if size(filename,2)>20
     f=[filename(1:17) '...'];
 else
     f=filename;
end
 
mainFname=filename;
if strcmp(filename(end-3:end),'.BFL') || strcmp(filename(end-3:end),'.BBL') || strcmp(filename(end-3:end),'.bfl') || strcmp(filename(end-3:end),'.bbl')          
    waitbar(.25,waitbarFid,['converting ' f ' to csv using BB-tools']);  
    [status,result]=system(['blackbox_decode.exe ' filename]);  
    files=dir([filename(1:end-4) '*.csv']);
    
    % only choose files that don't have .bbl or .bfl extension
    clear f2;m=1;
    for k=1:size(files,1)
        if ~contains(files(k).name,'.bbl','IgnoreCase',true) & ~contains(files(k).name,'.bfl','IgnoreCase',true)  
            f2(m,:)=files(k);
            m=m+1;
        end
    end
    % report to user, the most common loading error
    try 
        files=f2;clear f2;
    catch % report blackbox_decode error to user
        set(gcf, 'pointer', 'arrow')
        close(waitbarFid)
        errordlg('Please ensure your log files are in the ''main'' folder along with blackbox_decode.exe and PIDtoolbox.exe! ', 'blackbox_decode error');
    end
    
    % get rid of all event files and gps.gpx files 
    fevt=dir([filename(1:end-4) '*.event']);
    for k=1:size(fevt,1)
        delete([fevt(k).name]);
    end
    fevt=dir([filename(1:end-4) '*.gps.gpx']);
    for k=1:size(fevt,1)
        delete([fevt(k).name]);
    end    
    fevt=dir([filename(1:end-4) '*.gps.csv']);
    for k=1:size(fevt,1)
        delete([fevt(k).name]);
    end
    
    % get list of files after erasing junk
    files=dir([filename(1:end-4) '*.csv']);
    
    % if more than one file
    if size(files,1) > 1
        % delete files with < 500kb - may need better work-around eventually
        x=size(files,1);
        m=1;
        for k=1:x,            
            if ((files(k).bytes)) < 600 % delete if < 500bytes
                delete(files(k).name)
            else
                f2(m,:)=files(k);
                m=m+1;
            end
        end 
        files=f2;clear f2   
%         for m=1:size(files,1)
%             fileNums(m)=str2num(char(files(m).name(end-5:end-4)));
%         end
        a=strfind(result,'duration');
        logDurStr='SELECT LOG NUMBER:    ';
        for d=2:length(a)+1
            if d<11,
                logDurStr(d,:)=[' ' int2str(d-1) ') ' result(a(d-1):a(d-1)+17)];
            else
                logDurStr(d,:)=[int2str(d-1) ') ' result(a(d-1):a(d-1)+17)];
            end
        end
        
       if size(files,1)>0            
        x=size(files,1); 
            if x>1 % if multiple logs exist in BB file
                y=0;
                while y <= 0 || y > x   
                    y=PTstr2num(char(inputdlg([logDurStr])));
                    if y <= 0 || y > x,
                    errordlg('invalid selection. try again.');    
                    end
                end  
                csvFname=[files(y).name]; 
                %%%% delete all unused BB decoded csv files
                for k=1:x
                    if k~=y, delete(files(k).name); end
                end
            else
            csvFname=[files.name];
            end
        else
            validData=0;
            a=errordlg(['no valid data in ' mainFname]);pause(3);close(a);
        end
    else
    csvFname=[filename(1:end-4) '.01.csv'];
    end
    BBfileFlag=1;  
else
    csvFname=filename; 
end
%%
if validData
    %%%% import csv data   
    if ~BBfileFlag %csv created from BB explorer
        waitbar(.5,waitbarFid,['getting header info for ' f]);
         fid = fopen(csvFname, 'r');
         c = fread(fid, 'uint8=>char')';
         fclose(fid);
         h1=strfind(c,'loopIteration')-1; %first variable
         h2=strfind(c,'axisError[2]')+12; %last variable
         
         TXT=strsplit(c(h1:h2),',');
         
         %get rid of quotes in the strings
         try
         a=strfind(TXT,'"'); %find quotes
         for m=1:size(TXT,2)
             TXT{m}(a{m})=[]; % delete quotes
         end
         catch
         end
         
         hdr=splitlines(c(1:strfind(c,'loopIteration')-3));
         try
             a=strfind(hdr,'"'); %find quotes
             for m=1:length(hdr)
                 hdr{m}(a{m})=[]; % get rid of quotes
                 a2=strfind(hdr{m},',');
                  a3=char(string(hdr{m}));
                  SetupInfo(m,:)=[{a3(1:a2-1)} {a3(a2+1:end)}];
             end
                        
             waitbar(.8,waitbarFid,['importing csv for ' f]); 
             NUM=csvread(csvFname, length(hdr)+2,0);% use hdr length to determine where main data starts, +1=var names so +2=data 
         catch
             SetupInfo=hdr;
             NUM=csvread(csvFname, 100,0);% start at 100th row will always be after header info
         end
         
    end
   
    if BBfileFlag % read header info directly from bbl or bfl if does not exist in csv file 
        waitbar(.5,waitbarFid,['importing csv for ' f]);
        fid = fopen(csvFname, 'r');
        C = textscan(fid, '%s', 'Delimiter',',','CollectOutput',1);
        ncol=mode(diff(find(not(cellfun('isempty',strfind(C{1}(:),'ANGLE_MODE'))))));% # columns
        if isnan(ncol)
            ncol=find(not(cellfun('isempty',strfind(C{1}(:),'rxFlightChannelsValid'))));% # columns            
        end
        TXT=C{1}(1:ncol)';% contains column headers
        fclose(fid);

        waitbar(.75,waitbarFid,['importing csv for ' f]);
        fmt=[repmat('%s',1,ncol) '\n'];
        fid = fopen(csvFname);          
        C = textscan(fid, fmt, 'Delimiter',',','Headerlines',1,'CollectOutput',1);
        fclose(fid);
        
        %flength=length(char(C{1}(:,1)));
            
        for m=1:ncol % width of matrix 
            waitbar(m/ncol,waitbarFid,['converting csv numerical data for ' f]); 
            if  ~strcmp(TXT(m), 'vbatLatest (V)') && ~strcmp(TXT(m), 'amperageLatest (A)')...,
                && ~strcmp(TXT(m), 'energyCumulative (mAh)') && ~strcmp(TXT(m), 'flightModeFlags (flags)')...,
                && ~strcmp(TXT(m), 'stateFlags (flags)') && ~strcmp(TXT(m), 'failsafePhase (flags)')...,
                && ~strcmp(TXT(m), 'rxSignalReceived') && ~strcmp(TXT(m), 'rxFlightChannelsValid')
                 
                NUM(:,m)=PTstr2num(char(C{1}(:,m)));
            else
                NUM(:,m)=zeros(length(PTstr2num(char(C{1}(:,1)))),1);
            end
        end         
             
        currentBBlogNum=str2num(csvFname(end-5:end-4));        
        delete(csvFname);% we r done with this-dont wanna leave junk on main directory
        
        % get header info from .bbl/.bfl file directly
        a=strfind(mainFname,'.');
        fid = fopen(mainFname, 'r');
        c = textscan(fid, '%s', 'Delimiter','\n','CollectOutput',1); %c2 = native2unicode(c)
        fclose(fid);
        a=strfind(c{1},'Firmware revision');
        logStartPoints=find(cellfun(@(a)~isempty(a)&&a>0,a));      
        endStr={'debug_mode' ; 'motor_pwm_rate' ; 'motor_pwm_protocol' ; 'use_unsynced_pwm' ; 'gyro_32khz_hardware_lpf' ; 'gyro_hardware_lpf' ; 'yaw_deadband' ; 'deadband' ; 'pidsum_limit_yaw' ; 'pidsum_limit' };% strings not in all revisions, try a few 
        m=1; a=strfind(c{1},endStr{m});
        while isempty(find(cellfun(@(a)~isempty(a)&&a>0,a)))         
            m=m+1;
            a=strfind(c{1},endStr{m});
        end
        logEndPoints=find(cellfun(@(a)~isempty(a)&&a>0,a));
        
        relevantLogNum=str2num(csvFname(end-5:end-4));
        s=c{1}(logStartPoints(relevantLogNum):logEndPoints(relevantLogNum));
        n=1;
        for m=1:size(s,1)
            waitbar(m/size(s,1),waitbarFid,['extracting setup info from ' f]);
            if size(strsplit(char(s(m)),':'),2)==2
                SetupInfo(n,:)=(strsplit(char(s(m)),':'));
                a=char(SetupInfo(n,1));
                if strcmp(a(1:2),'H ')
                    SetupInfo(n,1)={a(3:end)};
                end
                n=n+1;
            end
        end

        a=strfind(SetupInfo,'rc_rates');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));
        rc_rates=str2num(char(SetupInfo(b,2)));

        a=strfind(SetupInfo,'rc_expo');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));
        rc_expo=str2num(char(SetupInfo(b,2)));
        
        a=strfind(SetupInfo,'rates');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));if length(b)>1,b=b(2);end
        Super_rates=str2num(char(SetupInfo(b,2))); 
        
         a=strfind(SetupInfo,'thr_mid');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));
        thr_mid=str2num(char(SetupInfo(b,2)));
        
         a=strfind(SetupInfo,'thr_expo');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));
        thr_expo=str2num(char(SetupInfo(b,2)));

        %%%% no header info in decoded data  
        VarLabels=TXT(1,:);
        DataMain=NUM;
    else
        rc_rates=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rc_rates')),:));
        rc_expo=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rc_expo')),:));
        Super_rates=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rates')),:));
        thr_mid=(SetupInfo(find(strcmp(SetupInfo(:,1), 'thr_mid')),:));
        thr_expo=(SetupInfo(find(strcmp(SetupInfo(:,1), 'thr_expo')),:));

        VarLabels=TXT(1,:);
        DataMain=NUM;
    end

    %%%%%% white space issues in blackbox_decode files
    for k=1:size(VarLabels,2)
        if strcmp(VarLabels{k}(1),' ')
            VarLabels{k}(1)=[];
        end
    end
    if strfind(VarLabels{2},'time (us)'),
        VarLabels{2}=VarLabels{2}(1:4);
    end
    %%%%%%
    DAT.DataMain=DataMain;
    DAT.mainFname=mainFname;
    DAT.csvFname=csvFname;
    DAT.SetupInfo=SetupInfo;
    DAT.VarLabels=VarLabels;
    DAT.rates=[rc_rates; rc_expo; Super_rates];
    DAT.throttle=[thr_mid; thr_expo];
    DAT.BBfileFlag=BBfileFlag;
    try
    DAT.blackbox_decode_results=result;
    catch
    end
    close(waitbarFid)
else
    DAT=[];
end

