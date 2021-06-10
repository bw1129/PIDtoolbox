function [freq ampMat] = PTthrSpec(X, Y, F, psd)
%% [freq ampMat] = PTthrSpec(X, Y, F, numspectrograms)
%   computes fft as function of throttle(or motor output, optional) and generates throttle/motor x freq
%   matrix. X is throttle/motor output data in percent, Y is flight data (gyro, PIDerror, etc), 
%   RClim sets the limit on the RC data (RPY set-point) used to compute FFT,
%   F is sample frequency in Hz of the input flight data.
%   The function returns a throttle/motor output x freq matrix/spectrogram [ampMat] of input data X and Y.  %   

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


    Tr=100;% throttle range
    multiplier=.3; % results in 300ms segments (must be same in datatip for accurate reading)
    wnd=1; % throttle window size -> throttle +/- wnd
    segment_length=(F*1000)*multiplier; % 300ms segments
    
    subsampleFactor = round(15 - log(length(X)));% subsampleFactor > for smaller logfiles
    if subsampleFactor < 1, subsampleFactor = 1; end

    segment_vector=1:segment_length/subsampleFactor:length(Y);
    for i=1:length(segment_vector)-subsampleFactor-1
        Tm(i)=nanmean(X(segment_vector(i):segment_vector(i)+segment_length));  
        Yseg(i,:)=Y(segment_vector(i):segment_vector(i)+segment_length-1); 
    end
    pad = 0;%(2^10)-segment_length;
    ampMat=zeros(Tr,(segment_length/2)+pad);
    freq=zeros(Tr,(segment_length/2)+pad);
    
    Tm(find(Tm<0))=0;
    [Thr_sort Thr_sortInd]=sort(Tm');
    Yseg_sort=Yseg(Thr_sortInd,:);% sorted Y according to X (throttle or motor output) 
    
     for i=1:Tr 
        clear tmp
        if ~isempty(find(Thr_sort>i-wnd & Thr_sort<=i+wnd))
            ind=find(Thr_sort>i-wnd & Thr_sort<=i+wnd);
            for j=1:length(ind)
                try
                clear Ytmp Ytmp2 Y N Np Fs
                Ytmp=Yseg_sort(ind(j),:)'; 
                N=length(Ytmp);
                Np=length(Ytmp)+(pad*2);
                Fs = (F*1000)*(1:(Np/2))/Np;
                Ytmp2 = Ytmp.*hann(N);% hann taper on non padded signal
                
              if psd
                  [Y,Fs] = periodogram(Ytmp2, [],(Np)-1,F*1000,'psd');
                 % Y = Y ./ Fs';
              else
                    Y = abs(fft(Ytmp2,Np)) / Np;
                    Y = Y(1:(Np/2));
               %     Y = Y ./ Fs';
               end
       
                % psd - work in progress
%               Ytmp2 = Ytmp.*hann(N-(pad*2));
%               Y = (1/((F*1000)*N)) * abs(fft(Ytmp2,N)).^2;
%               Y = 2*Y(1:N/2);
                % matlab psd function   
             %   Ytmp2 = Ytmp.*hann(N);
             %  [Y,Fs] = periodogram(Ytmp2, [],(N+(pad*2))-1,F*1000,'psd');
             
                % common Y scaling for psd 
       %        Y=10*log10(Y); 
               
 
                tmp(j,:) = Y;                
                warning off

                catch
                end
            end 
            a=nanmean(tmp,1);
            ampMat(i,:)=a;
            freq(i,:) = Fs;
         %   dat(i,:)=abs(Ytmp);
        end
     end
   clear tmp
   tmp = ampMat;
    clear ampMat
    if F>2, ampMat=tmp(:,1:floor(size(tmp,2)*(1/F)*2)); end 
    if F<=2, ampMat=tmp; end
end
            
