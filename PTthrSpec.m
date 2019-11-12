function [freq ampMat] = PTthrSpec(X, Y, RC, RClim, F, counter, numspectrograms, subsamp)
%% [freq ampMat] = PTthrSpec(X, Y, RC, RClim, F, counter, numspectrograms, subsamp)
%   computes fft as function of throttle(or motor output, optional) and generates throttle/motor x freq
%   matrix. X is throttle/motor output data in percent, Y is flight data (gyro, PIDerror, etc), 
%   RClim sets the limit on the RC data (RPY set-point) used to compute FFT,
%   F is sample frequency in Hz of the input flight data. Counter and numspectrograms are 
%   used for the waitbar, and subsamp is an factor that specifies degree of subsampling (higher, more subsampling, but slower
%   The function returns a throttle/motor output x freq matrix/spectrogram [ampMat] of input data X and Y.  %   

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

hw = waitbar(0,['organizing data for spectrogram '  int2str(counter) ]); 

    % only uses data with RC (set point) < RClim
    X=X(abs(RC(1,:))<RClim & abs(RC(2,:))<RClim & abs(RC(3,:))<RClim);
    Y=Y(abs(RC(1,:))<RClim & abs(RC(2,:))<RClim & abs(RC(3,:))<RClim);
    X=X';
    Y=Y';

    Tr=100;% throttle range
    multiplier=.3; % results in 300ms segments (must be same in datatip for accurate reading)
    wnd=1; % window size 
    segment_length=(F*1000)*multiplier; % 300ms segments (~= plasmatree pid analyzer)
 %   freq_smoothfactor=4*(F/1000);
 %   thr_smoothfactor=15 ; % more smoothing in throttle domain
    
    subsampleFactor=subsamp;% larger=smoother but slower

    segment_vector=1:segment_length/subsampleFactor:length(Y);
    for i=1:length(segment_vector)-subsampleFactor 
        Tm(i)=nanmean(X(segment_vector(i):segment_vector(i)+segment_length));  
        Yseg(i,:)=Y(segment_vector(i):segment_vector(i)+segment_length); 
    end
    ampMat=zeros(Tr,(segment_length/2)+1);
    freq=zeros(Tr,(segment_length/2)+1);
    
    Tm(find(Tm<0))=0;
    [Thr_sort Thr_sortInd]=sort(Tm');
    Yseg_sort=Yseg(Thr_sortInd,:);% sorted Y according to X (throttle or motor output) 
    
     for i=1:Tr
        waitbar(i/Tr,hw,['computing fft for spectrogram ' int2str(counter) ]);  
        clear tmp
        if ~isempty(find(Thr_sort>i-wnd & Thr_sort<=i+wnd))
            ind=find(Thr_sort>i-wnd & Thr_sort<=i+wnd);
            for j=1:length(ind)
                try
                clear Ytmp Ytmp2 YA LA PA
                
                Ytmp=Yseg_sort(ind(j),:)';                
                Ytmp2 = Ytmp.*hann(length(Ytmp));% hann taper seems best / others: hamming blackman barthannwin bartlett parzenwin nuttallwin
                pad = 1024 - rem(length(Ytmp2), 1024) +1;
                YA=fft(Ytmp2);%,pad);% YA=fft(Ytmp2,2000);%padding
                LA=length(YA);
                PA = abs(YA/LA); % normalization -> plasmatree -> sqrt(LA)
                tmp(j,:) = PA(1:(LA/2)+1);                
                warning off
                fA = (F*1000)*(0:(LA/2))/LA;
                catch
                end
            end 
            a=nanmean(tmp,1);
            ampMat(i,:)=a;
            freq(i,:) = fA;
         %   dat(i,:)=abs(Ytmp);
        end
     end
   clear tmp
   tmp = ampMat;
    clear ampMat
    if F>2, ampMat=tmp(:,1:floor(size(tmp,2)*(1/F)*2)); end 
    if F<=2, ampMat=tmp; end
    close(hw)
end
            
