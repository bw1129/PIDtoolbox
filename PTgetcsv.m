function [csvFnames] = PTgetcsv(filename, firmware_flag)
%% [csvFnames] = PTgetcsv(filename, firmware_flag)
% Converts bbl files to csv using blackbox_decode

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


fnums = 1;

a=strfind(filename, ' ');% had to remove white space  to run in bb decode
a=fliplr(a);
if ~isempty((find(isspace(filename))))
    filename2=filename(find(~isspace(filename)));% have to get rid of spaces to run blackbox_decode using 'system' function
    movefile(filename,filename2);%rename file without spaces
    filename=filename2; 
    clear filename2
end

filename_nchars = 17;
if size(filename,2)>20
     f=[filename(1:filename_nchars) '...'];
 else
     f=filename;
end
 
mainFname=filename;
if strcmp(filename(end-3:end),'.BFL') || strcmp(filename(end-3:end),'.BBL') || strcmp(filename(end-3:end),'.bfl') || strcmp(filename(end-3:end),'.bbl') || strcmp(filename(end-3:end),'.txt') || strcmp(filename(end-3:end),'.TXT')          

    if firmware_flag < 3
        [status,result]=system(['./blackbox_decode ' filename]);  
    else
        [status,result]=system(['./blackbox_decode_INAV ' filename]);        
    end
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
    files = dir([filename(1:end-4) '*.csv']);
    
    % if more than one file
    
    if size(files,1) > 1
        x=size(files,1);
        clear f2; m=1;
        for k=1:x 
            if isempty(readtable(files(k).name,'Format','%s%s','Delimiter','_'))  %((files(k).bytes)) < 1000 %isempty(readtable(files(k).name)) %((files(k).bytes)) < 1000 % delete if < 1000bytes 
                delete(files(k).name)
                files(k).name
            else
                f2(m,:)=files(k);
                m=m+1;
            end
        end 
        files=f2;clear f2   
        a=strfind(result,'duration');
        logDurStr='';
        for d=1:length(a)
            logDurStr{d}=[int2str(d) ') ' result(a(d):a(d)+filename_nchars)];
        end
        
       if size(files,1)>0            
        x=size(files,1); 
            if x>1 % if multiple logs exist in BB file 
                [fnums , tf] = listdlg('ListString',logDurStr, 'ListSize',[250,round(size(logDurStr,2) * 20)], 'Name','Select file(s): ' );   
                %%%% delete all unused BB decoded csv files
                for k=1:x                    
                    if k~=fnums, delete(files(k).name); end
                end
            end
        else
            validData=0;
            a=errordlg(['no valid data in ' mainFname]);pause(3);close(a);
       end
    end
end
csvFnames={};
for k = 1 : length(fnums)
    csvFnames{k} = files(fnums(k)).name;
end

end