function [Fs spec] = PTSpec2d(Y, F, psd)
%% [Fs spec] = PTSpec2d(Y, F, psd) 
%   computes standard fft on input data Y. F is sample frequency in Hz.  

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if psd
    % N = length(Y);
    % [psdx,Fs] = periodogram(Y,[], N-1, F*1000,'psd'); % power psd
    % [spec,Fs] = pspectrum(Y, F*1000, 'FrequencyResolution', 10);
    
    N = length(Y);
    Fs = ((F*1000)*(0:(N/2))/N);
    Y = Y.*hann(N)';
    Y = fft(Y); 
    psdx = abs(Y).^2 / (F*1000*N); % (1/(F*N)) * abs(Y).^2  is exactly same as  abs(Y).^2 / (F*N), to 
    psdx(2:end-1) = 2*psdx(2:end-1);
    psdx = psdx(1:N/2+1); 
%     % scale to dB
     spec = 10 * log10(psdx)';
else       
    N = length(Y);
    Fs = ((F*1000)*(0:(N/2))/N);
    Y = Y.*hann(N)';
    Y = fft(Y); 
    spec = abs(Y) / N; % (1/(F*N)) * abs(Y).^2  is exactly same as  abs(Y).^2 / (F*N), to 
    spec = spec(1:N/2+1)';
end

end
