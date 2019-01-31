function [DAT] = PTimport(filename)
%[mainFname, csvFname, SetupInfo, VarLabels, DataMain, BBfileFlag] = PTimport(filename)
%   Imports log data in multiple formats. Default is .csv, but if using .bbl or .bfl files, 
% a version of blackbox_decode.exe must be in the log file folder
% blackbox_decode.exe is part of "blackbox_tools", which can be found here:
% https://github.com/cleanflight/blackbox-tools
% https://github.com/betaflight/blackbox-tools
 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


BBfileFlag=0;
validData=1;
a=strfind(filename, ' ');% had to fill white space with underscore for system func below - grrr!
filename2=filename;
if a,
    for k=1:length(a),
        filename2(a)='_';
    end
    movefile(filename,filename2);% rename old file with new underscore version - grrr!
    delete(filename);% delete old file
    filename=filename2;
end
mainFname=filename;
if strcmp(filename(end-3:end),'.BFL') | strcmp(filename(end-3:end),'.BBL') | strcmp(filename(end-3:end),'.bfl') | strcmp(filename(end-3:end),'.bbl')          
    [status,result]=system(['blackbox_decode.exe ' filename]);
    files=dir([filename(1:end-4) '*.csv']);
    
    % only choose files that don't have .bbl or .bfl extension
    clear f2;m=1;
    for k=1:length(files)
        if ~contains(files(k).name,'.bbl','IgnoreCase',true) & ~contains(files(k).name,'.bfl','IgnoreCase',true) 
            f2(m)=files(k);
            m=m+1;
        end
    end
    files=f2;clear f2;
    % get rid of all event files and gps.gpx files 
    fevt=dir([filename(1:end-4) '*.event']);
    for k=1:size(fevt,1)
        delete([fevt(k).name]);
    end
    fevt=dir([filename(1:end-4) '*.gps.gpx']);
    for k=1:size(fevt,1)
        delete([fevt(k).name]);
    end
    % if more than one file
    if length(files) > 1
        % delete files with < 500kb - may need better work-around eventually
        x=length(files);
        m=1;
        for k=1:x,            
            if ((files(k).bytes)/1000000) < .5 % delete if < half MB
                delete(files(k).name)
            else
                f2(m)=files(k);
                m=m+1;
            end
        end 
        files=f2;clear f2
        
        if length(files)>0            
        x=length(files); 
            if x>1 % if multiple logs exist in BB file
                y=0;
                while y <= 0 | y > x   
                    y=str2num(char(inputdlg([filename(1:end-4) ' - select from log 1-' int2str(x) ':'])));
                    if y <= 0 | y > x,
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

if validData
    %%%% now import csv data
    [NUM,TXT,RAW]=xlsread(csvFname);
   
    if BBfileFlag, % read header info directly from bbl or bfl if does not exist in csv file   
        currentBBlogNum=str2num(csvFname(end-5:end-4));        
        delete(csvFname);% we r done with this-dont wanna leave junk on main directory
        
        a=strfind(mainFname,'.');
        fid = fopen(mainFname, 'r');
        c = fread(fid, 'int8')'; %c2 = native2unicode(c)
        fclose(fid);
        if ~ischar(c), c=char(c); end
        setupInfoIndStart=strfind(c,'Firmware revision'); % start of multiple instances of setup info for each log  
        relevantSetupinfoStart=setupInfoIndStart(currentBBlogNum); % relevant start point for selected log
        c=c(relevantSetupinfoStart:end);
        fwareVersion=c(strfind(c,'Firmware revision'):strfind(c,'Firmware date')-4);
        
        SetupInfo=[fwareVersion c(strfind(c,'Craft name')-3:strfind(c,'acc_hardware')+11)]; % dont ask...
        SetupInfo=strsplit(SetupInfo,'H')'; 

        a=strfind(SetupInfo,'rc_rates');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));
        rc_rates{2}=SetupInfo{b}(strfind(SetupInfo{b},':')+1:end); 

        a=strfind(SetupInfo,'rc_expo');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));
        rc_expo{2}=SetupInfo{b}(strfind(SetupInfo{b},':')+1:end);  

        a=strfind(SetupInfo,'rates');
        b=find(cellfun(@(a)~isempty(a)&&a>0,a));if length(b)>1,b=b(2);end
        Super_rates{2}=SetupInfo{b}(strfind(SetupInfo{b},':')+1:end);     
        %%%% no header info in decoded data  
        VarLabels=TXT(1,:);
        DataMain=NUM(1:end,:);
    else
        SetupInfo=RAW(1:size(TXT(1:end-1,1:2),1),1:2);
        rc_rates=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rc_rates')),:));
        rc_expo=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rc_expo')),:));
        Super_rates=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rates')),:));
        %%%% header info coded as nans in NUM data
        a=find(~isnan(NUM(:,1)));
        VarLabels=TXT(a(1),:);
        DataMain=NUM(a(1):end,:);
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
    DAT.BBfileFlag=BBfileFlag;
    try
    DAT.blackbox_decode_results=result;
    catch
    end
else
    DAT=[];
end

