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
    
        filepath=filepathA; 

        us2sec=1000000;
        maxMotorOutput=2000; 

        set(PTfig, 'pointer', 'watch')
        guiHandles.runAll.FontWeight='Bold';

        pause(.2)

        % make 'logfileDir.txt' so logfiles open in same as previously selected directory  
        cd(executableDir)
        pause(.2)
        fid = fopen('logfileDir.txt','w');
        fprintf(fid,'%s\n',filepath);
        fclose(fid);

        try
            cd(filepath)
        catch
            warndlg('Please select file(s)');
            close(waitbarFid); 
        end

        fnameMaster = [fnameMaster filenameA];
        Nfiles = size(fnameMaster,2);

    %    clear T dataA tta A_lograte epoch1_A epoch2_A    SetupInfo rollPIDF pitchPIDF yawPIDF

        n = size(filenameA,2)
        for ii = 1 : n  
            fcnt = fcnt + 1;
            dataA(fcnt) = PTimport(filenameA{ii});
            T{fcnt}=dataA(fcnt).T;

            tta{fcnt}=T{fcnt}.time_us_-T{fcnt}.time_us_(1);
            A_lograte(fcnt)=round(1000/median(diff(tta{fcnt})));
            epoch1_A(fcnt)=round(((tta{fcnt}(1)/us2sec)+LogStDefault)*10) / 10;
            epoch2_A(fcnt)=round(((tta{fcnt}(end)/us2sec)-LogNdDefault)*10) / 10;

            clear a b r p y dm ff
            SetupInfo{fcnt}=dataA(fcnt).SetupInfo;
            r = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'rollPID')),2));  
            p = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'pitchPID')),2));
            y = (SetupInfo{fcnt}(find(strcmp(SetupInfo{fcnt}(:,1), 'yawPID')),2));
            
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


            for k = 0 : 3
                try
                    eval(['T{fcnt}.debug_' int2str(k) '_(1);'])
                    eval(['T{fcnt}.axisF_' int2str(k) '_(1);'])
                catch
                    eval(['T{fcnt}.(''debug_' int2str(k) '_'')' '= nan(length(T{fcnt}.loopIteration),1);']) ;
                    eval(['T{fcnt}.(''axisF_' int2str(k) '_'')' '= zeros(length(T{fcnt}.loopIteration),1);']);
                end 
                
                eval(['T{fcnt}.motor_' int2str(k) '_ = ((T{fcnt}.motor_' int2str(k) '_ - 0) / (2000 - 0)) * 100;'])% scale motor sigs to %
                if k < 3,
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
    end

catch ME
    errmsg.PTload=PTerrorMessages('PTload', ME); 
end

