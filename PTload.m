%% PTload - script to load and organize main data and create main directories 

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


% betaflight debug_modes
% https://github.com/betaflight/betaflight/wiki/Debug-Modes?fbclid=IwAR2bKepD_cNZNnRtlAxf7yf3CWjYm2-MbFuwoGn3tUm8wPefp9CCJQR7c9Y
    
try    
    if ~isempty(filenameA)
    
        logfile_directory=filepathA; 

        us2sec=1000000;
        maxMotorOutput=2000; 

   %     set(PTfig, 'pointer', 'watch')
        guiHandles.runAll.FontWeight='Bold';

        pause(.2)
        
        try
            cd(main_directory)
            if ~strcmp(main_directory, logfile_directory)
                fid = fopen('logfileDir.txt','w');
                fprintf(fid,'%c',logfile_directory);
                fclose(fid);
            end
        catch
        end

        try
            cd(logfile_directory)
        catch
            errordlg('please select file then click ''load+run'' ','error - no file selected!');
        end
        
        cd(main_directory)
        ldr = ['logfileDirectory: ' logfile_directory ];
        try
            defaults = readtable('PTBdefaults.txt');
            a = char([cellstr([char(defaults.Parameters) num2str(defaults.Values)]); {rdr}; {mdr}; {ldr}]);
            t = uitable(PTfig, 'ColumnWidth',{500},'ColumnFormat',{'char'},'Data',[cellstr(a)]);
            set(t,'units','normalized','OuterPosition',[.89 vPos-.82 .105 .3],'FontSize',fontsz*.8, 'ColumnName', [''])
        catch
            defaults = ' '; 
            a = char(['Unable to set user defaults '; {rdr}; {mdr}; {ldr}]);
            t = uitable(PTfig, 'ColumnWidth',{500},'ColumnFormat',{'char'},'Data',[cellstr(a)]);
            set(t,'units','normalized','OuterPosition',[.89 vPos-.82 .105 .3],'FontSize',fontsz*.8, 'ColumnName', [''])
        end
        
        fnameMaster = [fnameMaster filenameA];
 
    %    clear T dataA tta A_lograte epoch1_A epoch2_A    SetupInfo rollPIDF pitchPIDF yawPIDF
    
        n = size(filenameA,2);
        waitbarFid = waitbar(0,'Please wait...');
        for ii = 1 : n    
            % temporarily copy logfile to 'main' where blackbox_decode is
            try % 
                source = fullfile(logfile_directory,filenameA{ii}); 
                destination = fullfile(main_directory,filenameA{ii}); 
                copyfile(source,destination); 
            catch
            end
            
            clear subFiles;
            [filenameA{ii} subFiles] = PTgetcsv(filenameA{ii}, guiHandles.Firmware.Value);
            
             
            for jj = 1 : size(subFiles,2)
                waitbar((ii+jj)/(n+size(subFiles,2)+1) , waitbarFid,['Importing File ' int2str(ii) ', Subfile ' int2str(jj)]);

                fcnt = fcnt + 1;
                Nfiles= fcnt;
                
                [dataA(fcnt) fnameMaster{fcnt}] = PTimport(subFiles{jj}, char(filenameA{ii}));
            
                T{fcnt}=dataA(fcnt).T;

                tta{fcnt}=T{fcnt}.time_us_-T{fcnt}.time_us_(1);
                A_lograte(fcnt)=round((1000/median(diff(tta{fcnt}))) * 10) / 10;
               
                epoch1_A(fcnt)=round(((tta{fcnt}(1)/us2sec)+LogStDefault)*10) / 10;
                epoch2_A(fcnt)=round(((tta{fcnt}(end)/us2sec)-LogNdDefault)*10) / 10;

                clear a b r p y dm ff
                SetupInfo{fcnt}=dataA(fcnt).SetupInfo;
                r = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'rollPID')),2));  
                p = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'pitchPID')),2));
                y = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'yawPID')),2));
                
                %%%%%%%%%% collect debug mode info %%%%%%%%%%
                try
                    debugmode(fcnt) = str2num(char(SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'debug_mode')),2)));
                catch
                    debugmode(fcnt) = 6;% default to gyro_scaled
                end

                dm = {};
                if ~isempty(SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'd_min')),2))
                    dm = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'd_min')),2));
                else
                    dm = {' , , '};
                end
                ff = {};
                if ~isempty(SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'feedforward_weight') | strcmp(SetupInfo{fcnt}(:,1), 'ff_weight')),2))
                    ff = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'feedforward_weight') | strcmp(SetupInfo{fcnt}(:,1), 'ff_weight')),2));
                else 
                    ff = {' , , '};
                end

                a=strfind(char(dm),',');
                b=strfind(char(ff),',');
                rollPIDF{fcnt} = [char(r) ',' dm{1}(1:a(1)-1) ',' ff{1}(1:b(1)-1)];
                pitchPIDF{fcnt} = [char(p) ',' dm{1}(a(1)+1:a(2)-1) ',' ff{1}(b(1)+1:b(2)-1)];
                yawPIDF{fcnt} = [char(y) ',' dm{1}(a(2)+1:end) ',' ff{1}(b(2)+1:end)];

                if guiHandles.Firmware.Value == 3 % INAV
                    T{fcnt}.setpoint_0_ = T{fcnt}.axisRate_0_;
                    T{fcnt}.setpoint_1_ = T{fcnt}.axisRate_1_;
                    T{fcnt}.setpoint_2_ = T{fcnt}.axisRate_2_;
                    T{fcnt}.setpoint_3_ = (T{fcnt}.rcData_3_ - 1000);
                end              

                for k = 0 : 3
                    try
                        eval(['T{fcnt}.debug_' int2str(k) '_(1);'])
                    catch
                        eval(['T{fcnt}.(''debug_' int2str(k) '_'')' '= zeros(length(T{fcnt}.loopIteration),1);']) ;
                    end 
                    try
                        eval(['T{fcnt}.axisF_' int2str(k) '_(1);'])
                    catch
                        eval(['T{fcnt}.(''axisF_' int2str(k) '_'')' '= zeros(length(T{fcnt}.loopIteration),1);']);
                    end 
                    
                    if guiHandles.Firmware.Value == 3 % INAV
                        eval(['T{fcnt}.motor_' int2str(k) '_ = ((T{fcnt}.motor_' int2str(k) '_ - 1000)) / 10;'])% scale motor sigs to %
                        try 
                            eval(['T{fcnt}.motor_' int2str(k+4) '_ = ((T{fcnt}.motor_' int2str(k+4) '_ - 1000)) / 10;'])% scale motor sigs 4-7 for x8 configuration
                        catch
                        end  
                    else
                        eval(['T{fcnt}.motor_' int2str(k) '_ = ((T{fcnt}.motor_' int2str(k) '_) / 2000) * 100;'])% scale motor sigs to %
                        try 
                            eval(['T{fcnt}.motor_' int2str(k+4) '_ = ((T{fcnt}.motor_' int2str(k+4) '_) / 2000) * 100;'])% scale motor sigs 4-7 for x8 configuration
                        catch
                        end
                    end
                    if k < 3 
                        if k < 2 % compute prefiltered dterm and scale
                            eval(['T{fcnt}.axisDpf_' int2str(k) '_ = -[0; diff(T{fcnt}.gyroADC_' int2str(k) '_)];'])
                            clear d1 d2 d3 sclr
                            eval(['d1 = smooth(T{fcnt}.axisDpf_' int2str(k) '_, 100);'])
                            eval(['d2 = smooth(T{fcnt}.axisD_' int2str(k) '_, 100);'])
                            d3 = (d2 ./ d1);
                            sclr = nanmedian(d3(~isinf(d3) & d3 > 0));
                            eval(['T{fcnt}.axisDpf_' int2str(k) '_ = T{fcnt}.axisDpf_' int2str(k) '_ * sclr;'])
                        end

                        eval(['T{fcnt}.(''piderr_' int2str(k) '_'') = T{fcnt}.gyroADC_' int2str(k) '_ - T{fcnt}.setpoint_' int2str(k) '_;'])
                        try
                            eval(['T{fcnt}.(''pidsum_' int2str(k) '_'') = T{fcnt}.axisP_' int2str(k) '_ + T{fcnt}.axisI_' int2str(k) '_ + T{fcnt}.axisD_' int2str(k) '_ + T{fcnt}.axisF_' int2str(k) '_;'])
                        catch
                            eval(['T{fcnt}.(''pidsum_' int2str(k) '_'') = T{fcnt}.axisP_' int2str(k) '_ + T{fcnt}.axisI_' int2str(k) '_ + T{fcnt}.axisF_' int2str(k) '_;'])
                        end
                    end
                end
            end
            % delete bbl from main directory only if not same as logfile_directory
            if ~strcmp(main_directory, logfile_directory)
                delete(filenameA{ii})
            end
        end
    end
  
    try close(waitbarFid), catch, end
catch  ME
   %  errmsg.PTload=PTerrorMessages('PTload', ME); 
end

