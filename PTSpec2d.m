function [Fs amp2d] = PTSpec2d(Y, F, psd)
%% [freq amp2d] = PTSpec2d(Y, F, psd) 
%   computes standard fft on input data Y. F is sample frequency in Hz.  

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
N=length(Y);

if psd
     [amp2d,Fs] = periodogram(Y, [], N-1,F*1000,'psd');
else                  
    Y2 = fft(Y);
    P2 = abs(Y2/N); % 'normalize' amplitude spectrum by length of signal
    P1 = P2(1:N/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    Fs = ((F*1000)*(0:(N/2))/N);
    amp2d=P1;
end

end
