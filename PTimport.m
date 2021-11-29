function [DAT newFileName] = PTimport(csvFname, BBLFileName)
%% [DAT newFileName] = PTimport(filename, BBLFileName)
%  Imports log data in multiple formats (fw=selected firmware/logfile type). Default is .csv, but if using .bbl or .bfl files, 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

newFileName=csvFname;
T=readtable(csvFname);

delete(csvFname);% we r done with this-dont wanna leave junk on main directory

% get header info from .bbl/.bfl file directly
a=strfind(BBLFileName,'.');
fid = fopen(BBLFileName, 'r');
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
DAT.mainFname=BBLFileName;
DAT.csvFname=csvFname;
DAT.SetupInfo=SetupInfo;
try
DAT.blackbox_decode_results=result;
catch
end

end
