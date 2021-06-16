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
if strcmp(filename(end-3:end),'.BFL') || strcmp(filename(end-3:end),'.BBL') || strcmp(filename(end-3:end),'.bfl') || strcmp(filename(end-3:end),'.bbl') || strcmp(filename(end-3:end),'.txt') || strcmp(filename(end-3:end),'.TXT')          
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
        errordlg('Please ensure your log files are in the ''main'' folder along with blackbox_decode and PIDtoolbox! ', 'blackbox_decode error');
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
        % delete files with < 1000kb - may need better work-around eventually
        x=size(files,1);
        m=1;
        for k=1:x,            
            if ((files(k).bytes)) < 1000 % delete if < 1000bytes
                delete(files(k).name)
            else
                f2(m,:)=files(k);
                m=m+1;
            end
        end 
        files=f2;clear f2   
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
else
    csvFname=filename; 
end
%%
waitbar(.5,waitbarFid,['importing csv for ' f]);
T=readtable(csvFname);

delete(csvFname);% we r done with this-dont wanna leave junk on main directory

% get header info from .bbl/.bfl file directly
a=strfind(mainFname,'.');
fid = fopen(mainFname, 'r');
c = textscan(fid, '%s', 'Delimiter','\n','CollectOutput',1); %c2 = native2unicode(c)
fclose(fid);

logStartPoints=[];
logEndPoints=[];

a=strfind(c{1},'Firmware version');
if isempty(find(cellfun(@(a)~isempty(a)&&a>0,a)))
    a=strfind(c{1},'Firmware revision');
    logStartPoints=find(cellfun(@(a)~isempty(a)&&a>0,a));  
else
    a=strfind(c{1},'Firmware version'); 
    logStartPoints=find(cellfun(@(a)~isempty(a)&&a>0,a));   
end

endStr={'debug_mode' ; 'motor_pwm_rate' ; 'motor_pwm_protocol' ; 'use_unsynced_pwm' ; 'gyro_32khz_hardware_lpf' ; 'gyro_hardware_lpf' ; 'yaw_deadband' ; 'deadband' ; 'pidsum_limit_yaw' ; 'pidsum_limit' ; 'energyCumulative (mAh)'; 'looptime'};% strings not in all revisions, try a few 
m=1; a=strfind(c{1},endStr{m});
while isempty(find(cellfun(@(a)~isempty(a)&&a>0,a)))         
    a=strfind(c{1},endStr{m});
    m=m+1;
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

%%%%%%
DAT.T=T;
DAT.mainFname=mainFname;
DAT.csvFname=csvFname;
DAT.SetupInfo=SetupInfo;
try
DAT.blackbox_decode_results=result;
catch
end
close(waitbarFid)


