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
    [status,result]=system(['blackbox_decode.exe --debug ' filename]);
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
    %%%% import csv data
   
    if ~BBfileFlag %csv created from BB explorer
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
                 tmp=split(hdr(m),',')';
                 SetupInfo(m,:)=tmp(1,1:2);
             end 
             NUM=csvread(csvFname, length(hdr)+2,0);% use hdr length to determine where main data starts, +1=var names so +2=data 
         catch
             SetupInfo=hdr;
             NUM=csvread(csvFname, 100,0);% start at 100th row will always be after header info
         end
         
    end
   
    if BBfileFlag, % read header info directly from bbl or bfl if does not exist in csv file  
        fid = fopen(csvFname, 'r');
        c = fread(fid, 'uint8=>char')';
        fclose(fid);
        h1=strfind(c,'loopIteration'); %first variable
        h2=strfind(c,'rxFlightChannelsValid')+22; %last variable
        TXT=strsplit(c(h1:h2),',');
        TXT(40:end)=[];% delete last few so I dont have to deal with cumbersome text
        
        %no matter how you slice it, this seems to be slow 
        fid = fopen(csvFname, 'r');
        c =  textscan( fid,'%s', 'Delimiter',{'\t'} );
        fclose(fid);
        c{1}(1:3)=[];
        
        % too dam slow
%         m=1;NUM=[];
%         while ~isempty((cell2mat(c{1}(m))))           
%             d=[];
%             if strcmp(char(string(c{1}(m))), 'S frame: ANGLE_MODE, SMALL_ANGLE, IDLE, 1, 1')
%                 c{1}(m)=[];
%             else
%                 d=(cell2mat(c{1}(m))); 
%                 NUM(m,:)=str2double(char(string(d)));
%                 m=m+1;
%             end
%         end
        
        NUM=xlsread(csvFname);% will only work on some machines
               
        currentBBlogNum=str2num(csvFname(end-5:end-4));        
        delete(csvFname);% we r done with this-dont wanna leave junk on main directory
        
        % get header info from .bbl/.bfl file directly
        a=strfind(mainFname,'.');
        fid = fopen(mainFname, 'r');
        c = fread(fid, 'uint8=>char')'; %c2 = native2unicode(c)
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
        DataMain=NUM;
    else
        rc_rates=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rc_rates')),:));
        rc_expo=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rc_expo')),:));
        Super_rates=(SetupInfo(find(strcmp(SetupInfo(:,1), 'rates')),:));     
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
    DAT.BBfileFlag=BBfileFlag;
    try
    DAT.blackbox_decode_results=result;
    catch
    end
else
    DAT=[];
end

